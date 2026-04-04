package io.easyware.bolao.mappers;

import io.easyware.bolao.dto.GroupWinnerBetDTO;
import io.easyware.bolao.entities.GroupWinnerBet;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;

import java.util.List;

@Mapper(componentModel = MappingConstants.ComponentModel.JAKARTA, uses = {AppUserMapper.class, TeamMapper.class})
public interface GroupWinnerBetMapper {

    @Mapping(source = "user.id", target = "userId")
    @Mapping(source = "firstPlaceTeam.id", target = "firstPlaceTeamId")
    @Mapping(source = "secondPlaceTeam.id", target = "secondPlaceTeamId")
    GroupWinnerBetDTO toDTO(GroupWinnerBet entity);

    @Mapping(source = "userId", target = "user.id")
    @Mapping(source = "firstPlaceTeamId", target = "firstPlaceTeam.id")
    @Mapping(source = "secondPlaceTeamId", target = "secondPlaceTeam.id")
    GroupWinnerBet toEntity(GroupWinnerBetDTO dto);

    List<GroupWinnerBetDTO> toDTOList(List<GroupWinnerBet> entities);

    List<GroupWinnerBet> toEntityList(List<GroupWinnerBetDTO> dtos);
}
