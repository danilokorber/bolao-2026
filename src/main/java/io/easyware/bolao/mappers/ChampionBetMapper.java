package io.easyware.bolao.mappers;

import io.easyware.bolao.dto.ChampionBetDTO;
import io.easyware.bolao.entities.ChampionBet;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;

import java.util.List;

@Mapper(componentModel = MappingConstants.ComponentModel.JAKARTA, uses = {AppUserMapper.class, TeamMapper.class})
public interface ChampionBetMapper {

    @Mapping(source = "user.id", target = "userId")
    @Mapping(source = "championTeam.id", target = "championTeamId")
    @Mapping(source = "runnerUpTeam.id", target = "runnerUpTeamId")
    @Mapping(source = "semifinalist1Team.id", target = "semifinalist1TeamId")
    @Mapping(source = "semifinalist2Team.id", target = "semifinalist2TeamId")
    @Mapping(source = "semifinalist3Team.id", target = "semifinalist3TeamId")
    @Mapping(source = "semifinalist4Team.id", target = "semifinalist4TeamId")
    ChampionBetDTO toDTO(ChampionBet entity);

    @Mapping(source = "userId", target = "user.id")
    @Mapping(source = "championTeamId", target = "championTeam.id")
    @Mapping(source = "runnerUpTeamId", target = "runnerUpTeam.id")
    @Mapping(source = "semifinalist1TeamId", target = "semifinalist1Team.id")
    @Mapping(source = "semifinalist2TeamId", target = "semifinalist2Team.id")
    @Mapping(source = "semifinalist3TeamId", target = "semifinalist3Team.id")
    @Mapping(source = "semifinalist4TeamId", target = "semifinalist4Team.id")
    ChampionBet toEntity(ChampionBetDTO dto);

    List<ChampionBetDTO> toDTOList(List<ChampionBet> entities);

    List<ChampionBet> toEntityList(List<ChampionBetDTO> dtos);
}
