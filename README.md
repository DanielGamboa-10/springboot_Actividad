# MindConnect - Backend

Plataforma de telepsicología, gestión de historias clínicas y servicios de inteligencia artificial desarrollada con **Spring Boot 3.3.4**, **PostgreSQL** y **Java 21**, siguiendo **Arquitectura Hexagonal (Puertos y Adaptadores)** y **Domain-Driven Design (DDD)**.

---

## 📊 Arquitectura de Base de Datos (52 Tablas)

El modelo de datos se gestiona exclusivamente mediante **Flyway** (`validate` activado en JPA), estructurado en 5 olas de migración para garantizar integridad referencial sin bloqueos de claves foráneas:

1. **Ola 1 - Catálogos Independientes (23 tablas):** `countries`, `genders`, `document_types`, `relationship_types`, `professional_types`, `studies`, `priorities`, `conversations_statuses`, `sender_types`, `message_types`, `ai_runs_statuses`, `escalations_statuses`, `clinical_record_statusses`, `encounter_types`, `encounter_modalities`, `encounter_statusses`, `risk_levels`, `treatment_statusses`, `treatment_goal_statusses`, `medication_routes`, `assessment_types`, `consent_types`, `diagnostic_systems`.
2. **Ola 2 - Jerarquía Geográfica (2 tablas):** `state_regions`, `city_municipalities`.
3. **Ola 3 - Entidades Nucleares y Personas (4 tablas):** `professionals`, `contacts`, `patients`, `clinical_records`.
4. **Ola 4 - Encuentros, Transacciones y Relaciones Clínicas (11 tablas):** `phone_contacts`, `email_contacts`, `patient_contacts`, `patient_allergies`, `professional_studies`, `encounters`, `clinical_notes`, `mental_status_exams`, `risk_assessments`, `treatment_plans`, `treatment_goals`.
5. **Ola 5 - Módulo de Mensajería e Inteligencia Artificial (12 tablas):** `provider_models_ai`, `ai_models`, `chat_conversations`, `chat_conversation_ai_settings`, `chat_participants`, `chat_messages` (JSONB), `chat_ai_runs`, `chat_ai_run_metrics`, `chat_ai_run_errors`, `chat_escalations`, `chat_escalation_assignments`, `chat_escalation_status_history`.

---

## 🏛️ Estructura del Proyecto (Arquitectura Hexagonal + DDD)

```text
src/main/java/com/mindconnect/
├── MindConnectApplication.java
├── catalog/
│   ├── domain/model/
│   └── infrastructure/adapter/persistence/entity/
├── professional/
│   ├── domain/model/ & domain/port/out/
│   └── infrastructure/adapter/persistence/ (entity, repository, mapper, adapter)
├── patient/
│   ├── domain/model/ & domain/port/out/
│   └── infrastructure/adapter/persistence/ (entity, repository, mapper, adapter)
├── clinical/
│   └── infrastructure/adapter/persistence/entity/
└── chat/
    └── infrastructure/adapter/persistence/entity/
```

---

## 🚀 Ejecución Local

### Prerrequisitos
- JDK 21+
- PostgreSQL en puerto 5432 con base de datos `mindconnect_db`

### Compilar y Validar:
```bash
./mvnw clean test-compile
```

### Iniciar la Aplicación:
```bash
./mvnw spring-boot:run
```
*(En Windows PowerShell: `.\mvnw.cmd spring-boot:run`)*
