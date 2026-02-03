package io.easyware.bolao.services;

import io.easyware.bolao.dto.UserPoolDTO;
import io.easyware.bolao.entities.UserPool;
import io.easyware.bolao.enums.UserPoolStatus;
import io.easyware.bolao.mappers.UserPoolMapper;
import io.easyware.bolao.repositories.AppUserRepository;
import io.easyware.bolao.repositories.PoolRepository;
import io.easyware.bolao.repositories.UserPoolRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;

import java.util.List;
import java.util.UUID;

@ApplicationScoped
public class UserPoolService {

    @Inject
    UserPoolRepository userPoolRepository;

    @Inject
    AppUserRepository appUserRepository;

    @Inject
    PoolRepository poolRepository;

    @Inject
    UserPoolMapper userPoolMapper;

    public List<UserPoolDTO> findAll() {
        return userPoolMapper.toDTOList(userPoolRepository.listAll());
    }

    public UserPoolDTO findById(UUID id) {
        UserPool userPool = userPoolRepository.findById(id);
        if (userPool == null) {
            throw new NotFoundException("UserPool not found with id: " + id);
        }
        return userPoolMapper.toDTO(userPool);
    }

    public List<UserPoolDTO> findByUser(UUID userId) {
        return userPoolMapper.toDTOList(userPoolRepository.findByUser(userId));
    }

    public List<UserPoolDTO> findByPool(UUID poolId) {
        return userPoolMapper.toDTOList(userPoolRepository.findByPool(poolId));
    }

    public UserPoolDTO findByUserAndPool(UUID userId, UUID poolId) {
        UserPool userPool = userPoolRepository.findByUserAndPool(userId, poolId);
        if (userPool == null) {
            throw new NotFoundException("UserPool not found for user: " + userId + " and pool: " + poolId);
        }
        return userPoolMapper.toDTO(userPool);
    }

    public List<UserPoolDTO> findByUserAndStatus(UUID userId, UserPoolStatus status) {
        return userPoolMapper.toDTOList(userPoolRepository.findByUserAndStatus(userId, status));
    }

    public List<UserPoolDTO> findByPoolAndStatus(UUID poolId, UserPoolStatus status) {
        return userPoolMapper.toDTOList(userPoolRepository.findByPoolAndStatus(poolId, status));
    }

    public long countActiveMembers(UUID poolId) {
        return userPoolRepository.countActiveMembers(poolId);
    }

    @Transactional
    public UserPoolDTO create(UserPoolDTO userPoolDTO) {
        UserPool userPool = userPoolMapper.toEntity(userPoolDTO);
        userPoolRepository.persist(userPool);
        return userPoolMapper.toDTO(userPool);
    }

    @Transactional
    public UserPoolDTO update(UUID id, UserPoolDTO userPoolDTO) {
        UserPool userPool = userPoolRepository.findById(id);
        if (userPool == null) {
            throw new NotFoundException("UserPool not found with id: " + id);
        }
        userPool.setStatus(userPoolDTO.getStatus());

        if (userPoolDTO.getUserId() != null) {
            userPool.setUser(appUserRepository.findById(userPoolDTO.getUserId()));
        }
        if (userPoolDTO.getPoolId() != null) {
            userPool.setPool(poolRepository.findById(userPoolDTO.getPoolId()));
        }

        return userPoolMapper.toDTO(userPool);
    }

    @Transactional
    public void delete(UUID id) {
        if (!userPoolRepository.deleteById(id)) {
            throw new NotFoundException("UserPool not found with id: " + id);
        }
    }
}
