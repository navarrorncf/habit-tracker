package com.navarrorncf;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNotSame;

import io.quarkus.test.TestTransaction;
import io.quarkus.test.junit.QuarkusTest;
import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import org.flywaydb.core.Flyway;
import org.junit.jupiter.api.Test;

@QuarkusTest
class HabitTest {
  @Inject Flyway flyway;

  @Inject EntityManager entityManager;

  @Test
  void appliesBaselineMigrationAtStartup() {
    var currentMigration = flyway.info().current();

    assertNotNull(currentMigration);
    assertNotNull(currentMigration.getVersion());
    assertEquals("1.0.0", currentMigration.getVersion().getVersion());
    assertEquals("create habit table", currentMigration.getDescription());
  }

  @Test
  @TestTransaction
  void persistsHabitWithGeneratedId() {
    var habit = new Habit();
    habit.name = "Read";

    habit.persistAndFlush();

    assertNotNull(habit.id);

    entityManager.clear();
    Habit persistedHabit = Habit.findById(habit.id);
    assertNotNull(persistedHabit);
    assertNotSame(habit, persistedHabit);
    assertEquals("Read", persistedHabit.name);
  }
}
