package com.mindconnect.chat.infrastructure.adapter.persistence.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

@Entity
@Table(name = "ai_models")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AiModelEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id", columnDefinition = "uuid", updatable = false, nullable = false)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "provider_model_id", nullable = false)
    private ProviderModelAiEntity providerModel;

    @Column(name = "name_model", length = 100, nullable = false)
    private String nameModel;

    @Column(name = "model_key", length = 120, nullable = false, unique = true)
    private String modelKey;

    @Column(name = "input_token_price", precision = 12, scale = 8, nullable = false)
    @Builder.Default
    private BigDecimal inputTokenPrice = BigDecimal.ZERO;

    @Column(name = "output_token_price", precision = 12, scale = 8, nullable = false)
    @Builder.Default
    private BigDecimal outputTokenPrice = BigDecimal.ZERO;

    @Column(name = "max_tokens")
    private Integer maxTokens;

    @Column(name = "context_window")
    private Integer contextWindow;

    @Column(name = "is_active", nullable = false)
    @Builder.Default
    private Boolean isActive = true;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
