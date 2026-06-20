package io.easyware.bolao.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

/**
 * Request payload for resolving a knockout-phase slot placeholder to a real team.
 * <p>
 * Knockout matches initially reference placeholder team rows (e.g. "Winner Group A")
 * via synthetic fifa codes such as {@code WGA}. Once the real qualifier is known,
 * this request re-points every match FK using that slot to the existing real team row
 * (looked up by its real fifa code, e.g. {@code MEX}).
 */
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ResolveSlotRequest {

    /**
     * Synthetic fifa code of the placeholder slot to resolve (e.g. {@code WGA}, {@code RGB}, {@code W73}).
     */
    @NotBlank
    private String slotCode;

    /**
     * Real fifa code of the team that qualified into the slot (e.g. {@code MEX}).
     */
    @NotBlank
    private String fifaCode;
}
