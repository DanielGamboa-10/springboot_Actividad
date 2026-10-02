package com.mindconnect.professional.domain.port.out;

import com.mindconnect.professional.domain.model.Professional;
import java.util.Optional;
import java.util.UUID;

public interface ProfessionalRepositoryPort {
    Professional save(Professional professional);
    Optional<Professional> findById(UUID id);
    Optional<Professional> findByLicenseNumber(String licenseNumber);
    boolean existsByLicenseNumber(String licenseNumber);
}
