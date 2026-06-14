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

    @Scheduled(every = "1d",
            identity = "odds-update-scheduler")
    public void scheduleOddsUpdate() {

        log.info("Scheduling Odds Update Schedule");
        if (enabled) oddsService.printAllEventsWithMatchingMatches();
    }
}
