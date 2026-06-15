package io.easyware.bolao.services;

import io.easyware.bolao.dto.AppUserDTO;
import io.easyware.bolao.dto.FavoriteToggleResponseDTO;
import io.easyware.bolao.dto.PagedResponse;
import io.easyware.bolao.entities.AppUser;
import io.easyware.bolao.entities.AppUserFavorite;
import io.easyware.bolao.mappers.AppUserMapper;
import io.easyware.bolao.repositories.AppUserRepository;
import io.easyware.bolao.repositories.AppUserFavoriteRepository;
import io.quarkus.hibernate.orm.panache.PanacheQuery;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.BadRequestException;
import jakarta.ws.rs.NotFoundException;

import java.util.List;
import java.util.UUID;

/**
 * Service layer for {@link AppUser} operations.
 */
@ApplicationScoped
public class AppUserService {

    @Inject
    AppUserRepository appUserRepository;

    @Inject
    AppUserMapper appUserMapper;

    @Inject
    AppUserFavoriteRepository appUserFavoriteRepository;

    /**
     * Lists all registered users.
     *
     * @return all users as DTOs
     */
    public List<AppUserDTO> findAll() {
        return appUserMapper.toDTOList(appUserRepository.listAll());
    }

    public PagedResponse<AppUserDTO> findAll(int page, int size) {
        PanacheQuery<AppUser> query = appUserRepository.findAll();
        query.page(page, size);
        long totalElements = query.count();
        List<AppUserDTO> content = appUserMapper.toDTOList(query.list());
        return new PagedResponse<>(content, page, size, totalElements);
    }

    /**
     * Finds a user by internal UUID.
     *
     * @param id the user's UUID
     * @return the matching user DTO
     * @throws NotFoundException if no user exists with the given id
     */
    public AppUserDTO findById(UUID id) {
        AppUser user = appUserRepository.findById(id);
        if (user == null) {
            throw new NotFoundException("User not found with id: " + id);
        }
        return appUserMapper.toDTO(user);
    }

    /**
     * Finds a user by their Keycloak subject identifier.
     *
     * @param keycloakId the Keycloak subject id
     * @return the matching user DTO
     * @throws NotFoundException if no user exists with the given keycloakId
     */
    public AppUserDTO findByKeycloakId(String keycloakId) {
        AppUser user = appUserRepository.findByKeycloakId(keycloakId);
        if (user == null) {
            throw new NotFoundException("User not found with Keycloak ID: " + keycloakId);
        }
        return appUserMapper.toDTO(user);
    }

    /**
     * Finds a user by email address.
     *
     * @param email the user's email
     * @return the matching user DTO
     * @throws NotFoundException if no user exists with the given email
     */
    public AppUserDTO findByEmail(String email) {
        AppUser user = appUserRepository.findByEmail(email);
        if (user == null) {
            throw new NotFoundException("User not found with email: " + email);
        }
        return appUserMapper.toDTO(user);
    }

    /**
     * Lists all active users.
     *
     * @return active users as DTOs
     */
    public List<AppUserDTO> findActiveUsers() {
        return appUserMapper.toDTOList(appUserRepository.findActiveUsers());
    }

    /**
     * Result of a find-or-create operation, carrying both the user DTO
     * and a flag indicating whether the user was newly created.
     */
    public record CreateResult(AppUserDTO user, boolean created) {}

    /**
     * Finds an existing user by {@code keycloakId} or creates a new one.
     * <p>
     * If a user with the given {@code keycloakId} already exists, it is
     * returned as-is (no fields are updated). Otherwise a new user is
     * persisted with the supplied data.
     *
     * @param userDTO the user data (keycloakId, name, email are required)
     * @return a {@link CreateResult} with the user and whether it was newly created
     * @throws BadRequestException if keycloakId, name, or email is missing
     */
    @Transactional
    public CreateResult findOrCreate(AppUserDTO userDTO) {
        if (userDTO.getKeycloakId() == null || userDTO.getKeycloakId().isBlank()) {
            throw new BadRequestException("keycloakId is required");
        }
        if (userDTO.getName() == null || userDTO.getName().isBlank()) {
            throw new BadRequestException("name is required");
        }
        if (userDTO.getEmail() == null || userDTO.getEmail().isBlank()) {
            throw new BadRequestException("email is required");
        }

        AppUser existing = appUserRepository.findByKeycloakId(userDTO.getKeycloakId());
        if (existing != null) {
            return new CreateResult(appUserMapper.toDTO(existing), false);
        }

        AppUser user = appUserMapper.toEntity(userDTO);
        if (user.getActive() == null) {
            user.setActive(true);
        }
        if (user.getCreatedAt() == null) {
            user.setCreatedAt(java.time.LocalDateTime.now());
        }
        appUserRepository.persist(user);
        return new CreateResult(appUserMapper.toDTO(user), true);
    }

    /**
     * Updates an existing user's mutable fields (name, email, active).
     *
     * @param id      the user's UUID
     * @param userDTO the new field values
     * @return the updated user DTO
     * @throws NotFoundException if no user exists with the given id
     */
    @Transactional
    public AppUserDTO update(UUID id, AppUserDTO userDTO) {
        AppUser user = appUserRepository.findById(id);
        if (user == null) {
            throw new NotFoundException("User not found with id: " + id);
        }
        user.setName(userDTO.getName());
        user.setEmail(userDTO.getEmail());
        user.setActive(userDTO.getActive());
        return appUserMapper.toDTO(user);
    }

    /**
     * Deletes a user by UUID.
     *
     * @param id the user's UUID
     * @throws NotFoundException if no user exists with the given id
     */
    @Transactional
    public void delete(UUID id) {
        if (!appUserRepository.deleteById(id)) {
            throw new NotFoundException("User not found with id: " + id);
        }
    }

    @Transactional
    public FavoriteToggleResponseDTO toggleFavorite(String currentUserIdentifier, UUID favoriteUserId) {
        AppUser user = appUserRepository.findByKeycloakId(currentUserIdentifier);
        if (user == null) {
            user = appUserRepository.findByEmail(currentUserIdentifier);
        }
        if (user == null) {
            throw new NotFoundException("User not found for authenticated principal: " + currentUserIdentifier);
        }

        UUID userId = user.getId();
        AppUser favoriteUser = appUserRepository.findById(favoriteUserId);
        if (favoriteUser == null) {
            throw new NotFoundException("Favorite user not found with id: " + favoriteUserId);
        }

        AppUserFavorite existing = appUserFavoriteRepository.findByUserIdAndFavoriteId(userId, favoriteUserId);
        boolean isFavorite;
        if (existing != null) {
            appUserFavoriteRepository.delete(existing);
            isFavorite = false;
        } else {
            appUserFavoriteRepository.persist(AppUserFavorite.builder()
                    .userId(userId)
                    .favoriteId(favoriteUserId)
                    .build());
            isFavorite = true;
        }

        return FavoriteToggleResponseDTO.builder()
                .userId(userId)
                .favoriteUserId(favoriteUserId)
                .isFavorite(isFavorite)
                .build();
    }
}
