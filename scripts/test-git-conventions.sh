#!/bin/sh

set -u

script_directory=$(CDPATH= cd "$(dirname "$0")" && pwd)
repository_root=$(CDPATH= cd "$script_directory/.." && pwd)
validator="$script_directory/validate-git-conventions.sh"
commit_hook="$repository_root/.githooks/commit-msg"
pre_push_hook="$repository_root/.githooks/pre-push"
temporary_directory=$(mktemp -d "${TMPDIR:-/tmp}/habit-tracker-git-test.XXXXXX")
message_file="$temporary_directory/commit-message"
git_repository="$temporary_directory/repository"
passed=0
failed=0

cleanup() {
    rm -rf "$temporary_directory"
}

trap cleanup EXIT HUP INT TERM

assert_success() {
    description=$1
    shift

    if "$@"; then
        passed=$((passed + 1))
        printf 'PASS: %s\n' "$description"
    else
        failed=$((failed + 1))
        printf 'FAIL: %s\n' "$description" >&2
    fi
}

assert_failure() {
    description=$1
    shift

    if "$@"; then
        failed=$((failed + 1))
        printf 'FAIL: %s\n' "$description" >&2
    else
        passed=$((passed + 1))
        printf 'PASS: %s\n' "$description"
    fi
}

write_message() {
    printf '%s\n' "$1" > "$message_file"
}

run_commit_message() {
    write_message "$1"
    "$validator" commit-message "$message_file"
}

run_commit_hook() {
    "$commit_hook" "$message_file"
}

run_branch() {
    "$validator" branch "$1"
}

run_pre_push() {
    printf '%s\n' "$1" | "$validator" pre-push
}

run_pre_push_hook() {
    printf '%s\n' "$1" | "$pre_push_hook"
}

run_pre_push_from_repository() {
    (
        cd "$git_repository" || exit 1
        printf '%s\n' "$1" | "$validator" pre-push
    )
}

run_commit_range() {
    (
        cd "$git_repository" || exit 1
        "$validator" commit-range "$1" "$2"
    )
}

assert_success 'validator is executable' test -x "$validator"
assert_success 'commit-msg hook is executable' test -x "$commit_hook"
assert_success 'pre-push hook is executable' test -x "$pre_push_hook"
assert_success 'installer is executable' test -x "$repository_root/.githooks/install.sh"

for commit_type in feat fix docs style refactor perf test build ci chore revert; do
    assert_success "valid commit type: $commit_type" run_commit_message "$commit_type(HT-2): add habit"
done

assert_success 'valid HT-X commit scope' run_commit_message 'docs(HT-X): update workflow'
assert_success 'valid commit body and footer' run_commit_message "docs(HT-X): update workflow

Document the local hook installation.
Refs: HT-X"
assert_success 'valid commit hook message' run_commit_message 'chore(HT-2): validate hooks'
assert_success 'commit hook accepts valid message' run_commit_hook

assert_failure 'old ticket-only commit format' run_commit_message 'HT-2: old style'
assert_failure 'unknown commit type' run_commit_message 'unknown(HT-2): bad'
assert_failure 'breaking marker is rejected' run_commit_message 'feat(HT-2)!: breaking'
assert_failure 'missing commit description' run_commit_message 'feat(HT-2): '
assert_failure 'malformed commit scope' run_commit_message 'feat(ht-2): bad scope'
assert_failure 'commit hook rejects invalid message' run_commit_message 'HT-2: old style'
assert_failure 'commit hook returns failure for invalid message' run_commit_hook

for branch_type in feat fix docs style refactor perf test build ci chore revert; do
    assert_success "valid branch type: $branch_type" run_branch "$branch_type/HT-123/add_habit"
done

assert_success 'valid HT-X branch' run_branch 'docs/HT-X/update_docs'
assert_success 'dev branch exception' run_branch dev
assert_success 'main branch exception' run_branch main
assert_failure 'branch without description' run_branch 'feat/HT-2'
assert_failure 'branch with unknown type' run_branch 'unknown/HT-2/bad'
assert_failure 'branch with lowercase ticket scope' run_branch 'feat/ht-2/bad'
assert_failure 'branch with uppercase slug' run_branch 'feat/HT-2/Bad'
assert_failure 'branch with slash in slug' run_branch 'feat/HT-2/bad/slash'
assert_failure 'branch with unsupported type' run_branch 'feature/HT-2/add_habit'

valid_ref='refs/heads/feat/HT-2/add_habit 1111111111111111111111111111111111111111 refs/heads/feat/HT-2/add_habit 2222222222222222222222222222222222222222'
tag_ref='refs/tags/v1.0 1111111111111111111111111111111111111111 refs/tags/v1.0 2222222222222222222222222222222222222222'
deleted_ref='refs/heads/feat/HT-2/deleted 0000000000000000000000000000000000000000 refs/heads/feat/HT-2/deleted 0000000000000000000000000000000000000000'
invalid_ref='refs/heads/feature/HT-2/add_habit 1111111111111111111111111111111111111111 refs/heads/feature/HT-2/add_habit 2222222222222222222222222222222222222222'

assert_success 'pre-push skips tags and deletions' run_pre_push "$valid_ref
$tag_ref
$deleted_ref"
assert_failure 'pre-push rejects invalid branch' run_pre_push "$valid_ref
$tag_ref
$deleted_ref
$invalid_ref"
assert_success 'pre-push hook accepts valid branch' run_pre_push_hook "$valid_ref"
assert_failure 'pre-push hook rejects invalid branch' run_pre_push_hook "$invalid_ref"

mkdir -p "$git_repository"
git -C "$git_repository" init -q
git -C "$git_repository" config user.name 'Git Convention Test'
git -C "$git_repository" config user.email 'git-conventions@example.invalid'
git -C "$git_repository" symbolic-ref HEAD refs/heads/feat/HT-2/test_hooks
printf '%s\n' 'base' > "$git_repository/file.txt"
git -C "$git_repository" add file.txt
git -C "$git_repository" commit -qm 'chore(HT-2): initialize test repository'
base_commit=$(git -C "$git_repository" rev-parse HEAD)
head_ref='HEAD 1111111111111111111111111111111111111111 refs/heads/feat/HT-2/test_hooks 2222222222222222222222222222222222222222'
assert_success 'pre-push validates HEAD on a valid branch' run_pre_push_from_repository "$head_ref"
git -C "$git_repository" branch -m dev
assert_success 'pre-push validates HEAD on protected dev branch' run_pre_push_from_repository "$head_ref"
git -C "$git_repository" branch -m work
assert_failure 'pre-push validates HEAD on an invalid branch' run_pre_push_from_repository "$head_ref"
printf '%s\n' 'valid' >> "$git_repository/file.txt"
git -C "$git_repository" add file.txt
git -C "$git_repository" commit -qm 'test(HT-2): exercise commit range'
valid_head=$(git -C "$git_repository" rev-parse HEAD)
assert_success 'commit range accepts valid commits' run_commit_range "$base_commit" "$valid_head"
printf '%s\n' 'invalid' >> "$git_repository/file.txt"
git -C "$git_repository" add file.txt
git -C "$git_repository" commit -qm 'HT-2: legacy message'
invalid_head=$(git -C "$git_repository" rev-parse HEAD)
assert_failure 'commit range rejects invalid commit' run_commit_range "$base_commit" "$invalid_head"

printf '\n%s passed, %s failed\n' "$passed" "$failed"
[ "$failed" -eq 0 ]
