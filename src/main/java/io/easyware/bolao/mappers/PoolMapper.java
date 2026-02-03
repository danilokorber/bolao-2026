package io.easyware.bolao.mappers;

import io.easyware.bolao.dto.PoolDTO;
import io.easyware.bolao.entities.Pool;
import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;

import java.util.List;

@Mapper(componentModel = MappingConstants.ComponentModel.JAKARTA)
public interface PoolMapper {

    PoolDTO toDTO(Pool entity);

    Pool toEntity(PoolDTO dto);

    List<PoolDTO> toDTOList(List<Pool> entities);

    List<Pool> toEntityList(List<PoolDTO> dtos);
}
