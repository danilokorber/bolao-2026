package io.easyware.bolao.services;

import io.easyware.bolao.dto.AppUserDTO;
import io.easyware.bolao.entities.AppUser;
import io.easyware.bolao.mappers.AppUserMapper;
import io.easyware.bolao.repositories.AppUserRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;

import java.util.List;
import java.util.UUID;

@ApplicationScoped
public class AppUserService {

    @Inject
    AppUserRepository appUserRepository;

    @Inject
    AppUserMapper appUserMapper;

    public List<AppUserDTO> findAll() {
        return appUserMapper.toDTOList(appUserRepository.listAll());
    }

    public AppUserDTO findById(UUID id) {
        AppUser user = appUserRepository.findById(id);
        if (user == null) {
            throw new NotFoundException("User not found with id: " + id);
        }
        return appUserMapper.toDTO(user);
    }

    public AppUserDTO findByKeycloakId(String keycloakId) {
        AppUser user = appUserRepository.findByKeycloakId(keycloakId);
        if (user == null) {
            throw new NotFoundException("User not found with Keycloak ID: " + keycloakId);
        }
        return appUserMapper.toDTO(user);
    }

    public AppUserDTO findByEmail(String email) {
        AppUser user = appUserRepository.findByEmail(email);
        if (user == null) {
            throw new NotFoundException("User not found with email: " + email);
        }
        return appUserMapper.toDTO(user);
    }

    public List<AppUserDTO> findActiveUsers() {
        return appUserMapper.toDTOList(appUserRepository.findActiveUsers());
    }

    @Transactional
    public AppUserDTO create(AppUserDTO userDTO) {
        AppUser user = appUserMapper.toEntity(userDTO);
        appUserRepository.persist(user);
        return appUserMapper.toDTO(user);
    }

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

    @Transactional
    public void delete(UUID id) {
        if (!appUserRepository.deleteById(id)) {
            throw new NotFoundException("User not found with id: " + id);
        }
    }
}
