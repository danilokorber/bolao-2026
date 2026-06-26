package io.easyware.bolao.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RouteVisitRequestDTO {

    @NotBlank
    private String sessionId;

    @NotBlank
    private String path;

    private Integer screenWidth;

    private Integer screenHeight;

    private Integer viewportWidth;

    private Integer viewportHeight;

    private Double devicePixelRatio;

    private String browserName;

    private String browserVersion;

    private String osName;

    private String language;

    private String timezone;

    private String referrer;

    private String userAgent;
}
