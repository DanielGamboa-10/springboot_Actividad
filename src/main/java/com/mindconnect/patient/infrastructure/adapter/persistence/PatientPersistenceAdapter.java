package com.mindconnect.patient.infrastructure.adapter.persistence;

import com.mindconnect.patient.domain.model.Patient;
import com.mindconnect.patient.domain.port.out.PatientRepositoryPort;
import com.mindconnect.patient.infrastructure.adapter.persistence.entity.PatientEntity;
import com.mindconnect.patient.infrastructure.adapter.persistence.mapper.PatientPersistenceMapper;
import com.mindconnect.patient.infrastructure.adapter.persistence.repository.PatientJpaRepository;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

/**
 * Adaptador de Persistencia Hexagonal (Secondary / Driven Adapter).
 * Implementa el puerto de salida del dominio PatientRepositoryPort.
 */
@Component
@RequiredArgsConstructor
public class PatientPersistenceAdapter implements PatientRepositoryPort {

    private final PatientJpaRepository patientJpaRepository;
    private final PatientPersistenceMapper patientPersistenceMapper;

    @Override
    public Patient save(Patient patient) {
        PatientEntity entity = patientPersistenceMapper.toEntity(patient);
        PatientEntity saved = patientJpaRepository.save(entity);
        return patientPersistenceMapper.toDomain(saved);
    }

    @Override
    public Optional<Patient> findById(UUID id) {
        return patientJpaRepository.findById(id)
            .map(patientPersistenceMapper::toDomain);
    }

    @Override
    public Optional<Patient> findByEmail(String email) {
        return patientJpaRepository.findByEmail(email)
            .map(patientPersistenceMapper::toDomain);
    }

    @Override
    public Optional<Patient> findByDocument(UUID documentTypeId, String documentNumber) {
        return patientJpaRepository.findByDocumentTypeIdAndDocumentNumber(documentTypeId, documentNumber)
            .map(patientPersistenceMapper::toDomain);
    }
}
