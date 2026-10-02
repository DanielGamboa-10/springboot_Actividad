package com.mindconnect.professional.infrastructure.adapter.persistence;

import com.mindconnect.professional.domain.model.Professional;
import com.mindconnect.professional.domain.port.out.ProfessionalRepositoryPort;
import com.mindconnect.professional.infrastructure.adapter.persistence.entity.ProfessionalEntity;
import com.mindconnect.professional.infrastructure.adapter.persistence.mapper.ProfessionalPersistenceMapper;
import com.mindconnect.professional.infrastructure.adapter.persistence.repository.ProfessionalJpaRepository;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

/**
 * Adaptador de Persistencia Hexagonal para Professional.
 */
@Component
@RequiredArgsConstructor
public class ProfessionalPersistenceAdapter implements ProfessionalRepositoryPort {

    private final ProfessionalJpaRepository professionalJpaRepository;
    private final ProfessionalPersistenceMapper professionalPersistenceMapper;

    @Override
    public Professional save(Professional professional) {
        ProfessionalEntity entity = professionalPersistenceMapper.toEntity(professional);
        ProfessionalEntity saved = professionalJpaRepository.save(entity);
        return professionalPersistenceMapper.toDomain(saved);
    }

    @Override
    public Optional<Professional> findById(UUID id) {
        return professionalJpaRepository.findById(id)
            .map(professionalPersistenceMapper::toDomain);
    }

    @Override
    public Optional<Professional> findByLicenseNumber(String licenseNumber) {
        return professionalJpaRepository.findByLicenseNumber(licenseNumber)
            .map(professionalPersistenceMapper::toDomain);
    }

    @Override
    public boolean existsByLicenseNumber(String licenseNumber) {
        return professionalJpaRepository.existsByLicenseNumber(licenseNumber);
    }
}
