package io.easyware.bolao.mappers;

import io.easyware.bolao.dto.BetDTO;
import io.easyware.bolao.entities.Bet;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;

import java.util.List;

@Mapper(componentModel = MappingConstants.ComponentModel.JAKARTA, uses = {AppUserMapper.class, MatchMapper.class, TeamMapper.class})
public interface BetMapper {

    @Mapping(source = "user.id", target = "userId")
    @Mapping(source = "match.id", target = "matchId")
    @Mapping(source = "winnerBet.id", target = "winnerBetId")
    BetDTO toDTO(Bet entity);

    @Mapping(source = "userId", target = "user.id")
    @Mapping(source = "matchId", target = "match.id")
    @Mapping(source = "winnerBetId", target = "winnerBet.id")
    Bet toEntity(BetDTO dto);

    List<BetDTO> toDTOList(List<Bet> entities);

    List<Bet> toEntityList(List<BetDTO> dtos);
}
