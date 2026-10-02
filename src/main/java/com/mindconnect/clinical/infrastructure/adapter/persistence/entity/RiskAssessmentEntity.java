package com.mindconnect.clinical.infrastructure.adapter.persistence.entity;

import com.mindconnect.professional.infrastructure.adapter.persistence.entity.ProfessionalEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "risk_assessments")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RiskAssessmentEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id", columnDefinition = "uuid", updatable = false, nullable = false)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "encounter_id", nullable = false)
    private EncounterEntity encounter;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "risk_level_id", nullable = false)
    private RiskLevelEntity riskLevel;

    @Column(name = "suicidal_ideation", nullable = false)
    @Builder.Default
    private Boolean suicidalIdeation = false;

    @Column(name = "suicide_plan", nullable = false)
    @Builder.Default
    private Boolean suicidePlan = false;

    @Column(name = "suicide_intent", nullable = false)
    @Builder.Default
    private Boolean suicideIntent = false;

    @Column(name = "self_harm", nullable = false)
    @Builder.Default
    private Boolean selfHarm = false;

    @Column(name = "harm_to_others", nullable = false)
    @Builder.Default
    private Boolean harmToOthers = false;

    @Column(name = "risk_factors", columnDefinition = "TEXT")
    private String riskFactors;

    @Column(name = "protective_factors", columnDefinition = "TEXT")
    private String protectiveFactors;

    @Column(name = "clinical_actions", columnDefinition = "TEXT")
    private String clinicalActions;

    @Column(name = "observations", columnDefinition = "TEXT")
    private String observations;

    @Column(name = "assessed_at", nullable = false)
    private LocalDateTime assessedAt;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "assessed_by", nullable = false)
    private ProfessionalEntity assessedBy;
}
