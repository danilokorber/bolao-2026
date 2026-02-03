package io.easyware.bolao.mappers;

import io.easyware.bolao.dto.PaymentDTO;
import io.easyware.bolao.entities.Payment;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;

import java.util.List;

@Mapper(componentModel = MappingConstants.ComponentModel.JAKARTA, uses = {AppUserMapper.class, PoolMapper.class})
public interface PaymentMapper {

    @Mapping(source = "user.id", target = "userId")
    @Mapping(source = "pool.id", target = "poolId")
    PaymentDTO toDTO(Payment entity);

    @Mapping(source = "userId", target = "user.id")
    @Mapping(source = "poolId", target = "pool.id")
    Payment toEntity(PaymentDTO dto);

    List<PaymentDTO> toDTOList(List<Payment> entities);

    List<Payment> toEntityList(List<PaymentDTO> dtos);
}
