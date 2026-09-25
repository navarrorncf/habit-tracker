#!/bin/sh

set -u

commit_header_pattern='^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)\((HT-[0-9]+|HT-X)\): [^[:space:]].*$'
branch_pattern='^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)/(HT-[0-9]+|HT-X)/[a-z0-9_-]+$'
protected_branch_pattern='^(dev|main)$'

fail() {
    printf '%s\n' "error: $*" >&2
    return 1
}

validate_commit_header() {
    header=$1

    if printf '%s\n' "$header" | grep -E -q "$commit_header_pattern"; then
        return 0
    fi

    fail "invalid commit header: $header"
    printf '%s\n' 'expected: <type>(HT-<number>|HT-X): <description>' >&2
    printf '%s\n' 'allowed types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert' >&2
    return 1
}

validate_commit_message_file() {
    message_file=$1

    if [ ! -f "$message_file" ]; then
        fail "commit message file not found: $message_file"
        return 1
    fi

    first_line=$(sed -n '1p' "$message_file")
    validate_commit_header "$first_line"
}

validate_branch() {
    branch=$1

    if printf '%s\n' "$branch" | grep -E -q "$protected_branch_pattern"; then
        return 0
    fi

    if printf '%s\n' "$branch" | grep -E -q "$branch_pattern"; then
        return 0
    fi

    fail "invalid branch name: $branch"
    printf '%s\n' 'expected: <type>/HT-<number>|HT-X/<lowercase-slug>' >&2
    printf '%s\n' 'allowed types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert' >&2
    return 1
}

validate_commit() {
    commit=$1

    if ! git rev-parse --verify "$commit^{commit}" >/dev/null 2>&1; then
        fail "commit not found: $commit"
        return 1
    fi

    first_line=$(git show -s --format='%s' "$commit")
    if ! validate_commit_header "$first_line"; then
        printf '%s\n' "commit: $commit" >&2
        return 1
    fi
}

validate_commit_range() {
    base=$1
    head=$2

    if ! git rev-parse --verify "$base^{commit}" >/dev/null 2>&1; then
        fail "base commit not found: $base"
        return 1
    fi

    if ! git rev-parse --verify "$head^{commit}" >/dev/null 2>&1; then
        fail "head commit not found: $head"
        return 1
    fi

    commits=$(git rev-list "$base..$head")
    for commit in $commits; do
        if ! validate_commit "$commit"; then
            return 1
        fi
    done
}

validate_pre_push() {
    result=0

    while IFS=' ' read -r local_ref local_oid remote_ref remote_oid; do
        local_ref=${local_ref:-}
        local_oid=${local_oid:-}

        case "$local_ref" in
            refs/tags/*)
                continue
                ;;
            refs/heads/*)
                branch=${local_ref#refs/heads/}
                ;;
            HEAD)
                branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || true)
                if [ -z "$branch" ]; then
                    fail 'unable to determine the current branch for pushed HEAD'
                    result=1
                    continue
                fi
                ;;
            *)
                continue
                ;;
        esac

        case "$local_oid" in
            0000000000000000000000000000000000000000)
                continue
                ;;
        esac

        if ! validate_branch "$branch"; then
            result=1
        fi
    done

    return "$result"
}

usage() {
    printf '%s\n' "usage: $0 commit-message <message-file>" >&2
    printf '%s\n' "       $0 branch <branch-name>" >&2
    printf '%s\n' "       $0 pre-push" >&2
    printf '%s\n' "       $0 commit-range <base> <head>" >&2
}

command=${1:-}
case "$command" in
    commit-message)
        if [ "$#" -ne 2 ]; then
            usage
            exit 2
        fi
        validate_commit_message_file "$2"
        ;;
    branch)
        if [ "$#" -ne 2 ]; then
            usage
            exit 2
        fi
        validate_branch "$2"
        ;;
    pre-push)
        if [ "$#" -ne 1 ]; then
            usage
            exit 2
        fi
        validate_pre_push
        ;;
    commit-range)
        if [ "$#" -ne 3 ]; then
            usage
            exit 2
        fi
        validate_commit_range "$2" "$3"
        ;;
    *)
        usage
        exit 2
        ;;
esac
