package com.mindconnect.patient.infrastructure.adapter.persistence.mapper;

import com.mindconnect.catalog.infrastructure.adapter.persistence.entity.CityMunicipalityEntity;
import com.mindconnect.catalog.infrastructure.adapter.persistence.entity.DocumentTypeEntity;
import com.mindconnect.catalog.infrastructure.adapter.persistence.entity.GenderEntity;
import com.mindconnect.patient.domain.model.Patient;
import com.mindconnect.patient.infrastructure.adapter.persistence.entity.PatientEntity;
import com.mindconnect.professional.infrastructure.adapter.persistence.entity.ProfessionalEntity;
import org.springframework.stereotype.Component;

/**
 * Mapper Hexagonal: Convierte bidireccionalmente entre el modelo de Dominio Puro
 * y la entidad JPA de Infraestructura (Persistence).
 */
@Component
public class PatientPersistenceMapper {

    public Patient toDomain(PatientEntity entity) {
        if (entity == null) return null;

        return Patient.builder()
            .id(entity.getId())
            .documentTypeId(entity.getDocumentType() != null ? entity.getDocumentType().getId() : null)
            .documentNumber(entity.getDocumentNumber())
            .firstName(entity.getFirstName())
            .middleName(entity.getMiddleName())
            .lastName(entity.getLastName())
            .secondLastName(entity.getSecondLastName())
            .birthDate(entity.getBirthDate())
            .biologicalSexId(entity.getBiologicalSex() != null ? entity.getBiologicalSex().getId() : null)
            .genderIdentityId(entity.getGenderIdentity() != null ? entity.getGenderIdentity().getId() : null)
            .email(entity.getEmail())
            .phone(entity.getPhone())
            .address(entity.getAddress())
            .active(entity.getActive())
            .cityId(entity.getCity() != null ? entity.getCity().getId() : null)
            .createdBy(entity.getCreatedBy() != null ? entity.getCreatedBy().getId() : null)
            .updatedBy(entity.getUpdatedBy() != null ? entity.getUpdatedBy().getId() : null)
            .createdAt(entity.getCreatedAt())
            .updatedAt(entity.getUpdatedAt())
            .build();
    }

    public PatientEntity toEntity(Patient domain) {
        if (domain == null) return null;

        return PatientEntity.builder()
            .id(domain.getId())
            .documentType(domain.getDocumentTypeId() != null ? DocumentTypeEntity.builder().id(domain.getDocumentTypeId()).build() : null)
            .documentNumber(domain.getDocumentNumber())
            .firstName(domain.getFirstName())
            .middleName(domain.getMiddleName())
            .lastName(domain.getLastName())
            .secondLastName(domain.getSecondLastName())
            .birthDate(domain.getBirthDate())
            .biologicalSex(domain.getBiologicalSexId() != null ? GenderEntity.builder().id(domain.getBiologicalSexId()).build() : null)
            .genderIdentity(domain.getGenderIdentityId() != null ? GenderEntity.builder().id(domain.getGenderIdentityId()).build() : null)
            .email(domain.getEmail())
            .phone(domain.getPhone())
            .address(domain.getAddress())
            .active(domain.getActive() != null ? domain.getActive() : true)
            .city(domain.getCityId() != null ? CityMunicipalityEntity.builder().id(domain.getCityId()).build() : null)
            .createdBy(domain.getCreatedBy() != null ? ProfessionalEntity.builder().id(domain.getCreatedBy()).build() : null)
            .updatedBy(domain.getUpdatedBy() != null ? ProfessionalEntity.builder().id(domain.getUpdatedBy()).build() : null)
            .createdAt(domain.getCreatedAt())
            .updatedAt(domain.getUpdatedAt())
            .build();
    }
}
