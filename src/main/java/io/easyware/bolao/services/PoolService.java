package io.easyware.bolao.services;

import io.easyware.bolao.dto.PoolDTO;
import io.easyware.bolao.entities.Pool;
import io.easyware.bolao.mappers.PoolMapper;
import io.easyware.bolao.repositories.PoolRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;

import java.util.List;
import java.util.UUID;

@ApplicationScoped
public class PoolService {

    @Inject
    PoolRepository poolRepository;

    @Inject
    PoolMapper poolMapper;

    public List<PoolDTO> findAll() {
        return poolMapper.toDTOList(poolRepository.listAll());
    }

    public PoolDTO findById(UUID id) {
        Pool pool = poolRepository.findById(id);
        if (pool == null) {
            throw new NotFoundException("Pool not found with id: " + id);
        }
        return poolMapper.toDTO(pool);
    }

    public PoolDTO findByInviteCode(String inviteCode) {
        Pool pool = poolRepository.findByInviteCode(inviteCode);
        if (pool == null) {
            throw new NotFoundException("Pool not found with invite code: " + inviteCode);
        }
        return poolMapper.toDTO(pool);
    }

    public List<PoolDTO> findActivePools() {
        return poolMapper.toDTOList(poolRepository.findActivePools());
    }

    public List<PoolDTO> findByCreatedAtDesc() {
        return poolMapper.toDTOList(poolRepository.findByCreatedAtDesc());
    }

    @Transactional
    public PoolDTO create(PoolDTO poolDTO) {
        Pool pool = poolMapper.toEntity(poolDTO);
        poolRepository.persist(pool);
        return poolMapper.toDTO(pool);
    }

    @Transactional
    public PoolDTO update(UUID id, PoolDTO poolDTO) {
        Pool pool = poolRepository.findById(id);
        if (pool == null) {
            throw new NotFoundException("Pool not found with id: " + id);
        }
        pool.setName(poolDTO.getName());
        pool.setDescription(poolDTO.getDescription());
        pool.setEntryFee(poolDTO.getEntryFee());
        pool.setCurrency(poolDTO.getCurrency());
        pool.setIsActive(poolDTO.getIsActive());
        pool.setInviteCode(poolDTO.getInviteCode());
        return poolMapper.toDTO(pool);
    }

    @Transactional
    public void delete(UUID id) {
        if (!poolRepository.deleteById(id)) {
            throw new NotFoundException("Pool not found with id: " + id);
        }
    }
}
