package io.easyware.bolao.mappers;

import io.easyware.bolao.dto.UserPoolDTO;
import io.easyware.bolao.entities.UserPool;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;

import java.util.List;

@Mapper(componentModel = MappingConstants.ComponentModel.JAKARTA, uses = {AppUserMapper.class, PoolMapper.class})
public interface UserPoolMapper {

    @Mapping(source = "user.id", target = "userId")
    @Mapping(source = "pool.id", target = "poolId")
    UserPoolDTO toDTO(UserPool entity);

    @Mapping(source = "userId", target = "user.id")
    @Mapping(source = "poolId", target = "pool.id")
    UserPool toEntity(UserPoolDTO dto);

    List<UserPoolDTO> toDTOList(List<UserPool> entities);

    List<UserPool> toEntityList(List<UserPoolDTO> dtos);
}
