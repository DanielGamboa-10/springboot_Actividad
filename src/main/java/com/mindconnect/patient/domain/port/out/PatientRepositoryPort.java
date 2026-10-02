package com.mindconnect.patient.domain.port.out;

import com.mindconnect.patient.domain.model.Patient;
import java.util.Optional;
import java.util.UUID;

public interface PatientRepositoryPort {
    Patient save(Patient patient);
    Optional<Patient> findById(UUID id);
    Optional<Patient> findByEmail(String email);
    Optional<Patient> findByDocument(UUID documentTypeId, String documentNumber);
}
