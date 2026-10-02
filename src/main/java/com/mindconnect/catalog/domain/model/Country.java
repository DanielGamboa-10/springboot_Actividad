package com.mindconnect.catalog.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Entidad de Dominio puro para Country (DDD).
 * Libre de acoplamiento a frameworks de persistencia (JPA).
 */
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Country {
    private UUID id;
    private String nameCountry;
    private String codeCountry;
    private String description;
    private Boolean isActive;
    private String telephonePrefix;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
