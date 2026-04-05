package io.easyware.bolao.mappers;

import io.easyware.bolao.dto.MatchDTO;
import io.easyware.bolao.entities.Match;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;

import java.util.List;

@Mapper(componentModel = MappingConstants.ComponentModel.JAKARTA, uses = {TeamMapper.class})
public interface MatchMapper {

    @Mapping(source = "homeTeam.id", target = "homeTeamId")
    @Mapping(source = "awayTeam.id", target = "awayTeamId")
    @Mapping(source = "winner.id", target = "winnerId")
    @Mapping(target = "userBet", ignore = true)
    MatchDTO toDTO(Match entity);

    @Mapping(source = "homeTeamId", target = "homeTeam.id")
    @Mapping(source = "awayTeamId", target = "awayTeam.id")
    @Mapping(source = "winnerId", target = "winner.id")
    Match toEntity(MatchDTO dto);

    List<MatchDTO> toDTOList(List<Match> entities);

    List<Match> toEntityList(List<MatchDTO> dtos);
}
