package com.mindconnect.professional.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Agregado / Entidad de Dominio Puro para Profesional de la Salud Mental (DDD).
 */
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Professional {
    private UUID id;
    private UUID documentTypeId;
    private String documentNumber;
    private String firstName;
    private String lastName;
    private UUID professionalTypeId;
    private String licenseNumber;
    private Boolean active;
    private UUID cityId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public String getFullName() {
        return (firstName != null ? firstName : "") + " " + (lastName != null ? lastName : "");
    }

    public void deactivate() {
        this.active = false;
        this.updatedAt = LocalDateTime.now();
    }
}
