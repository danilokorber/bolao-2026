package io.easyware.bolao.services;

import io.easyware.bolao.dto.RouteVisitRequestDTO;
import io.easyware.bolao.entities.AppUser;
import io.easyware.bolao.entities.RouteVisit;
import io.easyware.bolao.repositories.AppUserRepository;
import io.easyware.bolao.repositories.RouteVisitRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;

import java.util.UUID;

@ApplicationScoped
public class RouteVisitService {

    @Inject
    RouteVisitRepository routeVisitRepository;

    @Inject
    AppUserRepository appUserRepository;

    @Transactional
    public void record(UUID userId, RouteVisitRequestDTO request) {
        AppUser user = appUserRepository.findById(userId);
        if (user == null) {
            throw new NotFoundException("Current user not registered");
        }

        RouteVisit visit = RouteVisit.builder()
                .user(user)
                .username(user.getName())
                .sessionId(request.getSessionId())
                .path(request.getPath())
                .screenWidth(request.getScreenWidth())
                .screenHeight(request.getScreenHeight())
                .viewportWidth(request.getViewportWidth())
                .viewportHeight(request.getViewportHeight())
                .devicePixelRatio(request.getDevicePixelRatio())
                .browserName(request.getBrowserName())
                .browserVersion(request.getBrowserVersion())
                .osName(request.getOsName())
                .language(request.getLanguage())
                .timezone(request.getTimezone())
                .referrer(request.getReferrer())
                .userAgent(request.getUserAgent())
                .build();

        routeVisitRepository.persist(visit);
    }
}
