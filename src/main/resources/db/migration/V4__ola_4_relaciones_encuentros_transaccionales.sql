-- =============================================================================
-- MIGRACIÓN FLYWAY: OLA 4 - RELACIONES INTERMEDIAS, ENCUENTROS Y TRANSACCIONALES
-- Archivo: V4__ola_4_relaciones_encuentros_transaccionales.sql
-- Motor: PostgreSQL 13+ (Soporte nativo UUID v4 gen_random_uuid())
-- Dependencias: Olas 1, 2 y 3
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 30. phone_contacts (Teléfonos de los contactos de pacientes)
-- Depende de: contacts
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS phone_contacts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contact_id UUID NOT NULL,
    phone VARCHAR(30) NOT NULL,
    notes TEXT,
    CONSTRAINT fk_phone_contacts_contact FOREIGN KEY (contact_id) 
        REFERENCES contacts(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_phone_contacts_contact ON phone_contacts(contact_id);

-- -----------------------------------------------------------------------------
-- 31. email_contacts (Correos electrónicos de los contactos de pacientes)
-- Depende de: contacts
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS email_contacts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contact_id UUID NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    notes TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    CONSTRAINT fk_email_contacts_contact FOREIGN KEY (contact_id) 
        REFERENCES contacts(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_email_contacts_contact ON email_contacts(contact_id);

-- -----------------------------------------------------------------------------
-- 32. patient_contacts (Relación n:m paciente y sus contactos / acudientes)
-- Depende de: patients, contacts, relationship_types
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS patient_contacts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contact_id UUID NOT NULL,
    patient_id UUID NOT NULL,
    is_primary_contact BOOLEAN NOT NULL DEFAULT FALSE,
    is_emergency_contact BOOLEAN NOT NULL DEFAULT FALSE,
    relationship_type_id UUID NOT NULL,
    CONSTRAINT fk_patient_contacts_contact FOREIGN KEY (contact_id) 
        REFERENCES contacts(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_patient_contacts_patient FOREIGN KEY (patient_id) 
        REFERENCES patients(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_patient_contacts_rel_type FOREIGN KEY (relationship_type_id) 
        REFERENCES relationship_types(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_patient_contacts UNIQUE (patient_id, contact_id)
);

CREATE INDEX IF NOT EXISTS idx_patient_contacts_patient ON patient_contacts(patient_id);
CREATE INDEX IF NOT EXISTS idx_patient_contacts_contact ON patient_contacts(contact_id);
CREATE INDEX IF NOT EXISTS idx_patient_contacts_rel_type ON patient_contacts(relationship_type_id);

-- -----------------------------------------------------------------------------
-- 33. patient_allergies (Alergias registradas del paciente)
-- Depende de: patients, professionals
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS patient_allergies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID NOT NULL,
    substance VARCHAR(200) NOT NULL,
    reaction TEXT,
    severity VARCHAR(20),
    active BOOLEAN NOT NULL DEFAULT TRUE,
    recorded_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    recorded_by UUID,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    CONSTRAINT fk_patient_allergies_patient FOREIGN KEY (patient_id) 
        REFERENCES patients(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_patient_allergies_recorded_by FOREIGN KEY (recorded_by) 
        REFERENCES professionals(id) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_patient_allergies_patient ON patient_allergies(patient_id);
CREATE INDEX IF NOT EXISTS idx_patient_allergies_recorded_by ON patient_allergies(recorded_by);

-- -----------------------------------------------------------------------------
-- 34. professional_studies (Estudios y acreditaciones del profesional)
-- Depende de: studies, professionals, countries
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS professional_studies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    study_id UUID NOT NULL,
    professional_id UUID NOT NULL,
    title VARCHAR(100) NOT NULL,
    university VARCHAR(100) NOT NULL,
    is_valid BOOLEAN NOT NULL DEFAULT TRUE,
    resolution_number VARCHAR(60),
    country_id UUID,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    CONSTRAINT fk_prof_studies_study FOREIGN KEY (study_id) 
        REFERENCES studies(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_prof_studies_prof FOREIGN KEY (professional_id) 
        REFERENCES professionals(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_prof_studies_country FOREIGN KEY (country_id) 
        REFERENCES countries(id) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_prof_studies_prof ON professional_studies(professional_id);
CREATE INDEX IF NOT EXISTS idx_prof_studies_study ON professional_studies(study_id);

-- -----------------------------------------------------------------------------
-- 35. encounters (Encuentros clínicos / consultas / sesiones)
-- Depende de: clinical_records, professionals, encounter_types, encounter_modalities, encounter_statusses
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS encounters (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    clinical_record_id UUID NOT NULL,
    professional_id UUID NOT NULL,
    encounter_type_id UUID NOT NULL,
    started_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ended_at TIMESTAMP WITHOUT TIME ZONE,
    reason_for_visit TEXT,
    current_condition TEXT,
    modality_id UUID NOT NULL,
    status_id UUID NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    updated_by UUID,
    CONSTRAINT fk_encounters_record FOREIGN KEY (clinical_record_id) 
        REFERENCES clinical_records(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_encounters_prof FOREIGN KEY (professional_id) 
        REFERENCES professionals(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_encounters_type FOREIGN KEY (encounter_type_id) 
        REFERENCES encounter_types(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_encounters_modality FOREIGN KEY (modality_id) 
        REFERENCES encounter_modalities(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_encounters_status FOREIGN KEY (status_id) 
        REFERENCES encounter_statusses(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_encounters_created_by FOREIGN KEY (created_by) 
        REFERENCES professionals(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_encounters_updated_by FOREIGN KEY (updated_by) 
        REFERENCES professionals(id) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_encounters_record ON encounters(clinical_record_id);
CREATE INDEX IF NOT EXISTS idx_encounters_prof ON encounters(professional_id);
CREATE INDEX IF NOT EXISTS idx_encounters_status ON encounters(status_id);

-- -----------------------------------------------------------------------------
-- 36. clinical_notes (Notas y evolución clínica de la sesión)
-- Depende de: encounters, professionals
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS clinical_notes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    encounter_id UUID NOT NULL,
    professional_id UUID NOT NULL,
    subjective TEXT,
    objective TEXT,
    assessment TEXT,
    plan TEXT,
    additional_notes TEXT,
    signed_at TIMESTAMP WITHOUT TIME ZONE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    CONSTRAINT fk_clinical_notes_encounter FOREIGN KEY (encounter_id) 
        REFERENCES encounters(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_clinical_notes_prof FOREIGN KEY (professional_id) 
        REFERENCES professionals(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_clinical_notes_encounter ON clinical_notes(encounter_id);
CREATE INDEX IF NOT EXISTS idx_clinical_notes_prof ON clinical_notes(professional_id);

-- -----------------------------------------------------------------------------
-- 37. mental_status_exams (Exámenes del estado mental - MSE)
-- Depende de: encounters, professionals
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS mental_status_exams (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    encounter_id UUID NOT NULL,
    appearance TEXT,
    behavior TEXT,
    attitude TEXT,
    consciousness TEXT,
    orientation TEXT,
    attention TEXT,
    memory TEXT,
    speech TEXT,
    mood TEXT,
    affect TEXT,
    thought_process TEXT,
    thought_content TEXT,
    perception TEXT,
    judgment TEXT,
    insight TEXT,
    psychomotor_activity TEXT,
    observations TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID NOT NULL,
    CONSTRAINT fk_mse_encounter FOREIGN KEY (encounter_id) 
        REFERENCES encounters(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_mse_created_by FOREIGN KEY (created_by) 
        REFERENCES professionals(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_mse_encounter ON mental_status_exams(encounter_id);
CREATE INDEX IF NOT EXISTS idx_mse_created_by ON mental_status_exams(created_by);

-- -----------------------------------------------------------------------------
-- 38. risk_assessments (Evaluaciones de riesgo: suicidio, autolesión, violencia)
-- Depende de: encounters, risk_levels, professionals
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS risk_assessments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    encounter_id UUID NOT NULL,
    risk_level_id UUID NOT NULL,
    suicidal_ideation BOOLEAN NOT NULL DEFAULT FALSE,
    suicide_plan BOOLEAN NOT NULL DEFAULT FALSE,
    suicide_intent BOOLEAN NOT NULL DEFAULT FALSE,
    self_harm BOOLEAN NOT NULL DEFAULT FALSE,
    harm_to_others BOOLEAN NOT NULL DEFAULT FALSE,
    risk_factors TEXT,
    protective_factors TEXT,
    clinical_actions TEXT,
    observations TEXT,
    assessed_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    assessed_by UUID NOT NULL,
    CONSTRAINT fk_risk_assessments_encounter FOREIGN KEY (encounter_id) 
        REFERENCES encounters(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_risk_assessments_level FOREIGN KEY (risk_level_id) 
        REFERENCES risk_levels(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_risk_assessments_assessed_by FOREIGN KEY (assessed_by) 
        REFERENCES professionals(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_risk_assessments_encounter ON risk_assessments(encounter_id);
CREATE INDEX IF NOT EXISTS idx_risk_assessments_level ON risk_assessments(risk_level_id);

-- -----------------------------------------------------------------------------
-- 39. treatment_plans (Planes de tratamiento psicoterapéutico)
-- Depende de: encounters, professionals, treatment_statusses
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS treatment_plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    encounter_id UUID NOT NULL,
    professional_id UUID NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE,
    treatment_status_id UUID NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    CONSTRAINT fk_treatment_plans_encounter FOREIGN KEY (encounter_id) 
        REFERENCES encounters(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_treatment_plans_prof FOREIGN KEY (professional_id) 
        REFERENCES professionals(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_treatment_plans_status FOREIGN KEY (treatment_status_id) 
        REFERENCES treatment_statusses(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_treatment_plans_encounter ON treatment_plans(encounter_id);
CREATE INDEX IF NOT EXISTS idx_treatment_plans_prof ON treatment_plans(professional_id);
CREATE INDEX IF NOT EXISTS idx_treatment_plans_status ON treatment_plans(treatment_status_id);

-- -----------------------------------------------------------------------------
-- 40. treatment_goals (Metas y objetivos del plan de tratamiento)
-- Depende de: treatment_plans, treatment_goal_statusses
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS treatment_goals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    treatment_plan_id UUID NOT NULL,
    description TEXT NOT NULL,
    target_date DATE,
    completed_at TIMESTAMP WITHOUT TIME ZONE,
    notes TEXT,
    treatment_goal_id UUID NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    CONSTRAINT fk_treatment_goals_plan FOREIGN KEY (treatment_plan_id) 
        REFERENCES treatment_plans(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_treatment_goals_status FOREIGN KEY (treatment_goal_id) 
        REFERENCES treatment_goal_statusses(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_treatment_goals_plan ON treatment_goals(treatment_plan_id);
CREATE INDEX IF NOT EXISTS idx_treatment_goals_status ON treatment_goals(treatment_goal_id);
