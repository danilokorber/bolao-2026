package io.easyware.bolao.mappers;

import io.easyware.bolao.dto.TeamDTO;
import io.easyware.bolao.entities.Team;
import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;

import java.util.List;

@Mapper(componentModel = MappingConstants.ComponentModel.JAKARTA)
public interface TeamMapper {

    TeamDTO toDTO(Team entity);

    Team toEntity(TeamDTO dto);

    List<TeamDTO> toDTOList(List<Team> entities);

    List<Team> toEntityList(List<TeamDTO> dtos);
}
