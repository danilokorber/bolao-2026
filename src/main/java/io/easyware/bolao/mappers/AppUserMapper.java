package io.easyware.bolao.mappers;

import io.easyware.bolao.dto.AppUserDTO;
import io.easyware.bolao.entities.AppUser;
import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;

import java.util.List;

@Mapper(componentModel = MappingConstants.ComponentModel.JAKARTA)
public interface AppUserMapper {

    AppUserDTO toDTO(AppUser entity);

    AppUser toEntity(AppUserDTO dto);

    List<AppUserDTO> toDTOList(List<AppUser> entities);

    List<AppUser> toEntityList(List<AppUserDTO> dtos);
}
