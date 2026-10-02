-- =============================================================================
-- MIGRACIÓN FLYWAY: OLA 2 - TABLAS GEOGRÁFICAS Y DEPENDENCIAS DIRECTAS
-- Archivo: V2__ola_2_geografia_dependencias_directas.sql
-- Motor: PostgreSQL 13+ (Soporte nativo UUID v4 gen_random_uuid())
-- Dependencias: countries (creada en V1)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 24. state_regions (Departamentos / Estados / Regiones)
-- Depende de: countries(id)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS state_regions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_region VARCHAR(50) NOT NULL,
    code_region VARCHAR(10) NOT NULL,
    description VARCHAR(100),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    country_id UUID NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    CONSTRAINT fk_state_regions_country FOREIGN KEY (country_id) 
        REFERENCES countries(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_state_regions_code_country UNIQUE (code_region, country_id)
);

CREATE INDEX IF NOT EXISTS idx_state_regions_country_id ON state_regions(country_id);

-- -----------------------------------------------------------------------------
-- 25. city_municipalities (Ciudades / Municipios)
-- Depende de: state_regions(id)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS city_municipalities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_city VARCHAR(50) NOT NULL,
    code_citi VARCHAR(10) NOT NULL,
    description VARCHAR(100),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    region_id UUID NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    CONSTRAINT fk_city_municipalities_region FOREIGN KEY (region_id) 
        REFERENCES state_regions(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_city_municipalities_code_region UNIQUE (code_citi, region_id)
);

CREATE INDEX IF NOT EXISTS idx_city_municipalities_region_id ON city_municipalities(region_id);
