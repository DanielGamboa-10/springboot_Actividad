package com.mindconnect.professional.infrastructure.adapter.persistence.mapper;

import com.mindconnect.catalog.infrastructure.adapter.persistence.entity.CityMunicipalityEntity;
import com.mindconnect.catalog.infrastructure.adapter.persistence.entity.DocumentTypeEntity;
import com.mindconnect.catalog.infrastructure.adapter.persistence.entity.ProfessionalTypeEntity;
import com.mindconnect.professional.domain.model.Professional;
import com.mindconnect.professional.infrastructure.adapter.persistence.entity.ProfessionalEntity;
import org.springframework.stereotype.Component;

/**
 * Mapper Hexagonal: Convierte bidireccionalmente entre el modelo de Dominio Puro
 * de Professional y su entidad JPA de Infraestructura.
 */
@Component
public class ProfessionalPersistenceMapper {

    public Professional toDomain(ProfessionalEntity entity) {
        if (entity == null) return null;

        return Professional.builder()
            .id(entity.getId())
            .documentTypeId(entity.getDocumentType() != null ? entity.getDocumentType().getId() : null)
            .documentNumber(entity.getDocumentNumber())
            .firstName(entity.getFirstName())
            .lastName(entity.getLastName())
            .professionalTypeId(entity.getProfessionalType() != null ? entity.getProfessionalType().getId() : null)
            .licenseNumber(entity.getLicenseNumber())
            .active(entity.getActive())
            .cityId(entity.getCity() != null ? entity.getCity().getId() : null)
            .createdAt(entity.getCreatedAt())
            .updatedAt(entity.getUpdatedAt())
            .build();
    }

    public ProfessionalEntity toEntity(Professional domain) {
        if (domain == null) return null;

        return ProfessionalEntity.builder()
            .id(domain.getId())
            .documentType(domain.getDocumentTypeId() != null ? DocumentTypeEntity.builder().id(domain.getDocumentTypeId()).build() : null)
            .documentNumber(domain.getDocumentNumber())
            .firstName(domain.getFirstName())
            .lastName(domain.getLastName())
            .professionalType(domain.getProfessionalTypeId() != null ? ProfessionalTypeEntity.builder().id(domain.getProfessionalTypeId()).build() : null)
            .licenseNumber(domain.getLicenseNumber())
            .active(domain.getActive() != null ? domain.getActive() : true)
            .city(domain.getCityId() != null ? CityMunicipalityEntity.builder().id(domain.getCityId()).build() : null)
            .createdAt(domain.getCreatedAt())
            .updatedAt(domain.getUpdatedAt())
            .build();
    }
}
