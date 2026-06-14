package io.easyware.bolao.schedules;

import io.easyware.bolao.services.OddsService;
import io.quarkus.scheduler.Scheduled;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import lombok.extern.java.Log;

@ApplicationScoped
@Log
public class OddUpdateScheduler {

    @Inject
    OddsService oddsService;

    @Scheduled(every = "1h",
            identity = "odds-update-scheduler")
    public void scheduleOddsUpdate() {
        log.info("Scheduling Odds Update Schedule");
        oddsService.printAllEventsWithMatchingMatches();
    }
}
