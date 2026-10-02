-- =============================================================================
-- MIGRACIÓN FLYWAY: OLA 1 - TABLAS CATÁLOGO / INDEPENDIENTES (CERO DEPENDENCIAS FK)
-- Archivo: V1__ola_1_catalogos_independientes.sql
-- Motor: PostgreSQL 13+ (Soporte nativo UUID v4 gen_random_uuid())
-- =============================================================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- -----------------------------------------------------------------------------
-- 1. countries (Catálogo de países)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS countries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_country VARCHAR(50) NOT NULL UNIQUE,
    code_country VARCHAR(10) NOT NULL UNIQUE,
    description VARCHAR(100),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    telephone_prefix VARCHAR(5),
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

-- -----------------------------------------------------------------------------
-- 2. genders (Catálogo de géneros / identidades de género)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS genders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    description VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

-- -----------------------------------------------------------------------------
-- 3. document_types (Tipos de documento de identidad)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS document_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

-- -----------------------------------------------------------------------------
-- 4. relationship_types (Tipos de parentesco / relación con contacto de emergencia)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS relationship_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    description VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

-- -----------------------------------------------------------------------------
-- 5. professional_types (Tipos de profesionales: psicólogo, psiquiatra, etc.)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS professional_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(40) NOT NULL UNIQUE,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

-- -----------------------------------------------------------------------------
-- 6. studies (Catálogo de titulaciones / estudios)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS studies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(40) NOT NULL UNIQUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

-- -----------------------------------------------------------------------------
-- 7. priorities (Prioridades de conversación: Alta, Media, Baja, etc.)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS priorities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_priority VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

-- -----------------------------------------------------------------------------
-- 8. conversations_statuses (Estados de conversación)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS conversations_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_status VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

-- -----------------------------------------------------------------------------
-- 9. sender_types (Tipos de emisor de mensajes: Paciente, Profesional, Sistema, IA)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS sender_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_type VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

-- -----------------------------------------------------------------------------
-- 10. message_types (Tipos de contenido de mensaje: Texto, Audio, Imagen, etc.)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS message_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_type VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

-- -----------------------------------------------------------------------------
-- 11. ai_runs_statuses (Estados de ejecución de corridas de IA)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS ai_runs_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_status VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

-- -----------------------------------------------------------------------------
-- 12. escalations_statuses (Estados de escalamiento de chat a profesional)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS escalations_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_status VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

-- -----------------------------------------------------------------------------
-- 13. clinical_record_statusses (Estados de historias clínicas)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS clinical_record_statusses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

-- -----------------------------------------------------------------------------
-- 14. encounter_types (Tipos de encuentro / consulta)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS encounter_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL UNIQUE,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

-- -----------------------------------------------------------------------------
-- 15. encounter_modalities (Modalidades de encuentro: Presencial, Telemedicina, etc.)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS encounter_modalities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL UNIQUE,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

-- -----------------------------------------------------------------------------
-- 16. encounter_statusses (Estados del encuentro: Programado, En curso, Finalizado)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS encounter_statusses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL UNIQUE,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

-- -----------------------------------------------------------------------------
-- 17. risk_levels (Niveles de riesgo clínico: Bajo, Medio, Alto, Crítico)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS risk_levels (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    severity INTEGER NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

-- -----------------------------------------------------------------------------
-- 18. treatment_statusses (Estados de planes de tratamiento)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS treatment_statusses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL UNIQUE,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

-- -----------------------------------------------------------------------------
-- 19. treatment_goal_statusses (Estados de metas terapéuticas)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS treatment_goal_statusses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL UNIQUE,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

-- -----------------------------------------------------------------------------
-- 20. medication_routes (Vías de administración de medicamentos)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS medication_routes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

-- -----------------------------------------------------------------------------
-- 21. assessment_types (Tipos de evaluación diagnóstica / psicológica)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS assessment_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    description TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

-- -----------------------------------------------------------------------------
-- 22. consent_types (Tipos de consentimientos informados)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS consent_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    description TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

-- -----------------------------------------------------------------------------
-- 23. diagnostic_systems (Sistemas de clasificación diagnóstica: CIE-10, DSM-5, etc.)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS diagnostic_systems (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    version VARCHAR(20),
    description TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);
