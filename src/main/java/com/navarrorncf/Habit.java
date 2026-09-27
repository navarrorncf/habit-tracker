package com.navarrorncf;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;

@Entity
public class Habit extends PanacheEntity {
  @Column(nullable = false, length = 255)
  public String name;
}
