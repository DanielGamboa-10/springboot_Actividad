package com.mindconnect.patient.domain.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Period;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Agregado Raíz de Dominio Puro para Paciente (DDD).
 */
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Patient {
    private UUID id;
    private UUID documentTypeId;
    private String documentNumber;
    private String firstName;
    private String middleName;
    private String lastName;
    private String secondLastName;
    private LocalDate birthDate;
    private UUID biologicalSexId;
    private UUID genderIdentityId;
    private String email;
    private String phone;
    private String address;
    private Boolean active;
    private UUID cityId;
    private UUID createdBy;
    private UUID updatedBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public int getAge() {
        return birthDate != null ? Period.between(birthDate, LocalDate.now()).getYears() : 0;
    }

    public String getFullName() {
        StringBuilder sb = new StringBuilder();
        if (firstName != null) sb.append(firstName).append(" ");
        if (middleName != null && !middleName.isBlank()) sb.append(middleName).append(" ");
        if (lastName != null) sb.append(lastName).append(" ");
        if (secondLastName != null && !secondLastName.isBlank()) sb.append(secondLastName);
        return sb.toString().trim();
    }
}
