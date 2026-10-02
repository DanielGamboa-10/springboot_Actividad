package com.mindconnect.professional.infrastructure.adapter.persistence.repository;

import com.mindconnect.professional.infrastructure.adapter.persistence.entity.ProfessionalEntity;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProfessionalJpaRepository extends JpaRepository<ProfessionalEntity, UUID> {
    Optional<ProfessionalEntity> findByLicenseNumber(String licenseNumber);
    boolean existsByLicenseNumber(String licenseNumber);
}
