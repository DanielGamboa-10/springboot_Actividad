-- =============================================================================
-- MIGRACIÓN FLYWAY: OLA 3 - ENTIDADES PRINCIPALES Y PERSONAS (NÚCLEO DDD)
-- Archivo: V3__ola_3_entidades_principales_personas.sql
-- Motor: PostgreSQL 13+ (Soporte nativo UUID v4 gen_random_uuid())
-- Dependencias: Olas 1 y 2
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 26. professionals (Profesionales de la salud mental)
-- Depende de: document_types, professional_types, city_municipalities
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS professionals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_type_id UUID NOT NULL,
    document_number VARCHAR(30) NOT NULL,
    first_name VARCHAR(60) NOT NULL,
    last_name VARCHAR(60) NOT NULL,
    professional_type UUID NOT NULL,
    license_number VARCHAR(100) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    city_id UUID,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    CONSTRAINT fk_professionals_doc_type FOREIGN KEY (document_type_id) 
        REFERENCES document_types(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_professionals_prof_type FOREIGN KEY (professional_type) 
        REFERENCES professional_types(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_professionals_city FOREIGN KEY (city_id) 
        REFERENCES city_municipalities(id) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT uq_professionals_document UNIQUE (document_type_id, document_number),
    CONSTRAINT uq_professionals_license UNIQUE (license_number)
);

CREATE INDEX IF NOT EXISTS idx_professionals_doc_type ON professionals(document_type_id);
CREATE INDEX IF NOT EXISTS idx_professionals_prof_type ON professionals(professional_type);
CREATE INDEX IF NOT EXISTS idx_professionals_city ON professionals(city_id);

-- -----------------------------------------------------------------------------
-- 27. contacts (Personas de contacto / red de apoyo de pacientes)
-- Depende de: city_municipalities, professionals (audit)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS contacts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name VARCHAR(200) NOT NULL,
    email VARCHAR(150),
    notes TEXT,
    city_id UUID,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    updated_by UUID,
    CONSTRAINT fk_contacts_city FOREIGN KEY (city_id) 
        REFERENCES city_municipalities(id) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_contacts_created_by FOREIGN KEY (created_by) 
        REFERENCES professionals(id) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_contacts_updated_by FOREIGN KEY (updated_by) 
        REFERENCES professionals(id) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_contacts_city ON contacts(city_id);
CREATE INDEX IF NOT EXISTS idx_contacts_created_by ON contacts(created_by);

-- -----------------------------------------------------------------------------
-- 28. patients (Pacientes del sistema)
-- Depende de: document_types, genders, city_municipalities, professionals (audit)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS patients (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_type_id UUID NOT NULL,
    document_number VARCHAR(30) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    second_last_name VARCHAR(50),
    birth_date DATE NOT NULL,
    biological_sex_id UUID NOT NULL,
    gender_identity UUID,
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(30),
    address VARCHAR(250),
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    updated_by UUID,
    city_id UUID,
    CONSTRAINT fk_patients_doc_type FOREIGN KEY (document_type_id) 
        REFERENCES document_types(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_patients_bio_sex FOREIGN KEY (biological_sex_id) 
        REFERENCES genders(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_patients_gender_ident FOREIGN KEY (gender_identity) 
        REFERENCES genders(id) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_patients_city FOREIGN KEY (city_id) 
        REFERENCES city_municipalities(id) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_patients_created_by FOREIGN KEY (created_by) 
        REFERENCES professionals(id) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_patients_updated_by FOREIGN KEY (updated_by) 
        REFERENCES professionals(id) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT uq_patients_document UNIQUE (document_type_id, document_number)
);

CREATE INDEX IF NOT EXISTS idx_patients_doc_type ON patients(document_type_id);
CREATE INDEX IF NOT EXISTS idx_patients_city ON patients(city_id);
CREATE INDEX IF NOT EXISTS idx_patients_created_by ON patients(created_by);

-- -----------------------------------------------------------------------------
-- 29. clinical_records (Historias clínicas de pacientes)
-- Depende de: patients, clinical_record_statusses, professionals (audit)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS clinical_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID NOT NULL,
    creation_date TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_number VARCHAR(50) NOT NULL UNIQUE,
    opened_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    closed_at TIMESTAMP WITHOUT TIME ZONE,
    status_id UUID NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID NOT NULL,
    CONSTRAINT fk_clinical_records_patient FOREIGN KEY (patient_id) 
        REFERENCES patients(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_clinical_records_status FOREIGN KEY (status_id) 
        REFERENCES clinical_record_statusses(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_clinical_records_created_by FOREIGN KEY (created_by) 
        REFERENCES professionals(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_clinical_records_patient ON clinical_records(patient_id);
CREATE INDEX IF NOT EXISTS idx_clinical_records_status ON clinical_records(status_id);
CREATE INDEX IF NOT EXISTS idx_clinical_records_created_by ON clinical_records(created_by);
