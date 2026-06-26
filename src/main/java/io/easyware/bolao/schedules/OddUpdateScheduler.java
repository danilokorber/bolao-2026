package io.easyware.bolao.schedules;

import io.easyware.bolao.services.OddsService;
import io.quarkus.scheduler.Scheduled;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import lombok.extern.java.Log;
import org.eclipse.microprofile.config.inject.ConfigProperty;

@ApplicationScoped
@Log
public class OddUpdateScheduler {

    @Inject
    OddsService oddsService;

    @ConfigProperty(name = "the-odds-api.enabled", defaultValue = "false")
    boolean enabled;

    @Scheduled(cron = "${bolao.schedules.odds.schedule:0 0 12 * * ?}",
            timeZone = "${bolao.schedules.odds.timezone:GMT}",
            identity = "odds-update-scheduler")
    public void scheduleOddsUpdate() {
        if (!enabled) {
            log.fine("Odds update scheduler is disabled");
            return;
        }

        log.info("Running daily odds update");
        oddsService.updateOddsForAllMatches();
    }
}
