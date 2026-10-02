package com.mindconnect.patient.infrastructure.adapter.persistence.repository;

import com.mindconnect.patient.infrastructure.adapter.persistence.entity.PatientEntity;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PatientJpaRepository extends JpaRepository<PatientEntity, UUID> {
    Optional<PatientEntity> findByEmail(String email);
    Optional<PatientEntity> findByDocumentTypeIdAndDocumentNumber(UUID documentTypeId, String documentNumber);
}
