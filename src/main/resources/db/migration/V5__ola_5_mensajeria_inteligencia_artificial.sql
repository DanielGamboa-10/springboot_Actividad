-- =============================================================================
-- MIGRACIÓN FLYWAY: OLA 5 - MÓDULO DE MENSAJERÍA E INTELIGENCIA ARTIFICIAL
-- Archivo: V5__ola_5_mensajeria_inteligencia_artificial.sql
-- Motor: PostgreSQL 13+ (Soporte nativo UUID v4 gen_random_uuid() y JSONB)
-- Dependencias: Olas 1, 3 (professionals, patients)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 41. provider_models_ai (Proveedores de servicios de IA: OpenAI, Anthropic, Google, etc.)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS provider_models_ai (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_provider_ai VARCHAR(100) NOT NULL UNIQUE,
    razon_social VARCHAR(150),
    sitio_web TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

-- -----------------------------------------------------------------------------
-- 42. ai_models (Modelos de lenguaje / IA disponibles)
-- Depende de: provider_models_ai
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS ai_models (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    provider_model_id UUID NOT NULL,
    name_model VARCHAR(100) NOT NULL,
    model_key VARCHAR(120) NOT NULL UNIQUE,
    input_token_price DECIMAL(12,8) NOT NULL DEFAULT 0.0,
    output_token_price DECIMAL(12,8) NOT NULL DEFAULT 0.0,
    max_tokens INTEGER,
    context_window INTEGER,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    CONSTRAINT fk_ai_models_provider FOREIGN KEY (provider_model_id) 
        REFERENCES provider_models_ai(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_ai_models_provider ON ai_models(provider_model_id);

-- -----------------------------------------------------------------------------
-- 43. chat_conversations (Conversaciones / Sesiones de chat)
-- Depende de: conversations_statuses, priorities, professionals (closed_by)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS chat_conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_status_id UUID NOT NULL,
    priority_id UUID NOT NULL,
    last_message_at TIMESTAMP WITHOUT TIME ZONE,
    closed BOOLEAN NOT NULL DEFAULT FALSE,
    closed_at TIMESTAMP WITHOUT TIME ZONE,
    closed_by UUID,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    CONSTRAINT fk_chat_conversations_status FOREIGN KEY (conversation_status_id) 
        REFERENCES conversations_statuses(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_chat_conversations_priority FOREIGN KEY (priority_id) 
        REFERENCES priorities(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_chat_conversations_closed_by FOREIGN KEY (closed_by) 
        REFERENCES professionals(id) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_chat_conversations_status ON chat_conversations(conversation_status_id);
CREATE INDEX IF NOT EXISTS idx_chat_conversations_priority ON chat_conversations(priority_id);
CREATE INDEX IF NOT EXISTS idx_chat_conversations_closed_by ON chat_conversations(closed_by);

-- -----------------------------------------------------------------------------
-- 44. chat_conversation_ai_settings (Configuración de IA por conversación)
-- Depende de: chat_conversations, ai_models
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS chat_conversation_ai_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL UNIQUE,
    ai_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    default_model_id UUID,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    CONSTRAINT fk_chat_ai_settings_conv FOREIGN KEY (conversation_id) 
        REFERENCES chat_conversations(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_chat_ai_settings_model FOREIGN KEY (default_model_id) 
        REFERENCES ai_models(id) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_chat_ai_settings_conv ON chat_conversation_ai_settings(conversation_id);

-- -----------------------------------------------------------------------------
-- 45. chat_participants (Participantes activos en una conversación)
-- Depende de: chat_conversations, sender_types, patients, professionals
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS chat_participants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL,
    participant_type_id UUID NOT NULL,
    patient_id UUID,
    professional_id UUID,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    CONSTRAINT fk_chat_participants_conv FOREIGN KEY (conversation_id) 
        REFERENCES chat_conversations(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_chat_participants_type FOREIGN KEY (participant_type_id) 
        REFERENCES sender_types(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_chat_participants_patient FOREIGN KEY (patient_id) 
        REFERENCES patients(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_chat_participants_prof FOREIGN KEY (professional_id) 
        REFERENCES professionals(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_chat_participants_conv ON chat_participants(conversation_id);
CREATE INDEX IF NOT EXISTS idx_chat_participants_patient ON chat_participants(patient_id);
CREATE INDEX IF NOT EXISTS idx_chat_participants_prof ON chat_participants(professional_id);

-- -----------------------------------------------------------------------------
-- 46. chat_messages (Mensajes intercambiados en el chat)
-- Depende de: chat_conversations, message_types, chat_participants
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS chat_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL,
    message_type_id UUID NOT NULL,
    participant_id UUID NOT NULL,
    content JSONB NOT NULL,
    metadata JSONB,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_chat_messages_conv FOREIGN KEY (conversation_id) 
        REFERENCES chat_conversations(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_chat_messages_type FOREIGN KEY (message_type_id) 
        REFERENCES message_types(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_chat_messages_part FOREIGN KEY (participant_id) 
        REFERENCES chat_participants(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_chat_messages_conv ON chat_messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_chat_messages_part ON chat_messages(participant_id);

-- -----------------------------------------------------------------------------
-- 47. chat_ai_runs (Ejecuciones / Invocaciones a agentes de IA)
-- Depende de: chat_conversations, chat_messages, ai_models, ai_runs_statuses
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS chat_ai_runs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL,
    message_id UUID,
    model_id UUID NOT NULL,
    ai_run_status_id UUID NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    CONSTRAINT fk_ai_runs_conv FOREIGN KEY (conversation_id) 
        REFERENCES chat_conversations(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_ai_runs_msg FOREIGN KEY (message_id) 
        REFERENCES chat_messages(id) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_ai_runs_model FOREIGN KEY (model_id) 
        REFERENCES ai_models(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_ai_runs_status FOREIGN KEY (ai_run_status_id) 
        REFERENCES ai_runs_statuses(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_ai_runs_conv ON chat_ai_runs(conversation_id);
CREATE INDEX IF NOT EXISTS idx_ai_runs_model ON chat_ai_runs(model_id);
CREATE INDEX IF NOT EXISTS idx_ai_runs_status ON chat_ai_runs(ai_run_status_id);

-- -----------------------------------------------------------------------------
-- 48. chat_ai_run_metrics (Métricas de consumo de tokens y costos por ejecución)
-- Depende de: chat_ai_runs
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS chat_ai_run_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ai_run_id UUID NOT NULL,
    prompt_tokens INTEGER NOT NULL DEFAULT 0,
    completion_tokens INTEGER NOT NULL DEFAULT 0,
    total_tokens INTEGER NOT NULL DEFAULT 0,
    cost DECIMAL(10,6) NOT NULL DEFAULT 0.0,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ai_run_metrics_run FOREIGN KEY (ai_run_id) 
        REFERENCES chat_ai_runs(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_ai_run_metrics_run ON chat_ai_run_metrics(ai_run_id);

-- -----------------------------------------------------------------------------
-- 49. chat_ai_run_errors (Bitácora de errores producidos en ejecuciones de IA)
-- Depende de: chat_ai_runs, provider_models_ai
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS chat_ai_run_errors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ai_run_id UUID NOT NULL,
    error_message TEXT NOT NULL,
    error_code VARCHAR(80),
    provider_error_id VARCHAR(120),
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ai_run_errors_run FOREIGN KEY (ai_run_id) 
        REFERENCES chat_ai_runs(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_ai_run_errors_run ON chat_ai_run_errors(ai_run_id);

-- -----------------------------------------------------------------------------
-- 50. chat_escalations (Escalamiento de alertas o emergencias en el chat)
-- Depende de: chat_conversations, escalations_statuses
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS chat_escalations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL,
    status_id UUID NOT NULL,
    from_ai BOOLEAN NOT NULL DEFAULT TRUE,
    reason TEXT NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_chat_escalations_conv FOREIGN KEY (conversation_id) 
        REFERENCES chat_conversations(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_chat_escalations_status FOREIGN KEY (status_id) 
        REFERENCES escalations_statuses(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_chat_escalations_conv ON chat_escalations(conversation_id);
CREATE INDEX IF NOT EXISTS idx_chat_escalations_status ON chat_escalations(status_id);

-- -----------------------------------------------------------------------------
-- 51. chat_escalation_assignments (Asignación de escalamiento a profesional)
-- Depende de: chat_escalations, professionals
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS chat_escalation_assignments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    escalation_id UUID NOT NULL,
    professional_id UUID NOT NULL,
    assigned_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_escalation_assignments_esc FOREIGN KEY (escalation_id) 
        REFERENCES chat_escalations(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_escalation_assignments_prof FOREIGN KEY (professional_id) 
        REFERENCES professionals(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_escalation_assign_esc ON chat_escalation_assignments(escalation_id);
CREATE INDEX IF NOT EXISTS idx_escalation_assign_prof ON chat_escalation_assignments(professional_id);

-- -----------------------------------------------------------------------------
-- 52. chat_escalation_status_history (Trazabilidad y auditoría de cambios de estado del escalamiento)
-- Depende de: chat_escalations, escalations_statuses
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS chat_escalation_status_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    escalation_id UUID NOT NULL,
    escalation_status_id UUID NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    changed_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_escalation_hist_esc FOREIGN KEY (escalation_id) 
        REFERENCES chat_escalations(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_escalation_hist_status FOREIGN KEY (escalation_status_id) 
        REFERENCES escalations_statuses(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_escalation_hist_esc ON chat_escalation_status_history(escalation_id);
CREATE INDEX IF NOT EXISTS idx_escalation_hist_status ON chat_escalation_status_history(escalation_status_id);
