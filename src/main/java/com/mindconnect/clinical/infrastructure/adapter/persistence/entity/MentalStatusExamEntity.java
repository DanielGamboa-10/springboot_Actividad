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
import org.hibernate.annotations.CreationTimestamp;

@Entity
@Table(name = "mental_status_exams")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MentalStatusExamEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id", columnDefinition = "uuid", updatable = false, nullable = false)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "encounter_id", nullable = false)
    private EncounterEntity encounter;

    @Column(name = "appearance", columnDefinition = "TEXT")
    private String appearance;

    @Column(name = "behavior", columnDefinition = "TEXT")
    private String behavior;

    @Column(name = "attitude", columnDefinition = "TEXT")
    private String attitude;

    @Column(name = "consciousness", columnDefinition = "TEXT")
    private String consciousness;

    @Column(name = "orientation", columnDefinition = "TEXT")
    private String orientation;

    @Column(name = "attention", columnDefinition = "TEXT")
    private String attention;

    @Column(name = "memory", columnDefinition = "TEXT")
    private String memory;

    @Column(name = "speech", columnDefinition = "TEXT")
    private String speech;

    @Column(name = "mood", columnDefinition = "TEXT")
    private String mood;

    @Column(name = "affect", columnDefinition = "TEXT")
    private String affect;

    @Column(name = "thought_process", columnDefinition = "TEXT")
    private String thoughtProcess;

    @Column(name = "thought_content", columnDefinition = "TEXT")
    private String thoughtContent;

    @Column(name = "perception", columnDefinition = "TEXT")
    private String perception;

    @Column(name = "judgment", columnDefinition = "TEXT")
    private String judgment;

    @Column(name = "insight", columnDefinition = "TEXT")
    private String insight;

    @Column(name = "psychomotor_activity", columnDefinition = "TEXT")
    private String psychomotorActivity;

    @Column(name = "observations", columnDefinition = "TEXT")
    private String observations;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "created_by", nullable = false)
    private ProfessionalEntity createdBy;
}
