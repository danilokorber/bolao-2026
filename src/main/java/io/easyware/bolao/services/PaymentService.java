package io.easyware.bolao.services;

import io.easyware.bolao.dto.PaymentDTO;
import io.easyware.bolao.dto.PagedResponse;
import io.easyware.bolao.entities.Payment;
import io.easyware.bolao.enums.PaymentStatus;
import io.easyware.bolao.mappers.PaymentMapper;
import io.easyware.bolao.repositories.AppUserRepository;
import io.easyware.bolao.repositories.PaymentRepository;
import io.easyware.bolao.repositories.PoolRepository;
import io.quarkus.hibernate.orm.panache.PanacheQuery;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;

import java.util.List;
import java.util.UUID;

@ApplicationScoped
public class PaymentService {

    @Inject
    PaymentRepository paymentRepository;

    @Inject
    AppUserRepository appUserRepository;

    @Inject
    PoolRepository poolRepository;

    @Inject
    PaymentMapper paymentMapper;

    public List<PaymentDTO> findAll() {
        return paymentMapper.toDTOList(paymentRepository.listAll());
    }

    public PagedResponse<PaymentDTO> findAll(int page, int size) {
        PanacheQuery<Payment> query = paymentRepository.findAll();
        query.page(page, size);
        long totalElements = query.count();
        List<PaymentDTO> content = paymentMapper.toDTOList(query.list());
        return new PagedResponse<>(content, page, size, totalElements);
    }

    public PaymentDTO findById(UUID id) {
        Payment payment = paymentRepository.findById(id);
        if (payment == null) {
            throw new NotFoundException("Payment not found with id: " + id);
        }
        return paymentMapper.toDTO(payment);
    }

    public List<PaymentDTO> findByUser(UUID userId) {
        return paymentMapper.toDTOList(paymentRepository.findByUser(userId));
    }

    public List<PaymentDTO> findByPool(UUID poolId) {
        return paymentMapper.toDTOList(paymentRepository.findByPool(poolId));
    }

    public List<PaymentDTO> findByUserAndPool(UUID userId, UUID poolId) {
        return paymentMapper.toDTOList(paymentRepository.findByUserAndPool(userId, poolId));
    }

    public List<PaymentDTO> findByStatus(PaymentStatus status) {
        return paymentMapper.toDTOList(paymentRepository.findByStatus(status));
    }

    public PaymentDTO findByTransactionId(String transactionId) {
        Payment payment = paymentRepository.findByTransactionId(transactionId);
        if (payment == null) {
            throw new NotFoundException("Payment not found with transaction ID: " + transactionId);
        }
        return paymentMapper.toDTO(payment);
    }

    public List<PaymentDTO> findPendingByPool(UUID poolId) {
        return paymentMapper.toDTOList(paymentRepository.findPendingByPool(poolId));
    }

    @Transactional
    public PaymentDTO create(PaymentDTO paymentDTO) {
        Payment payment = paymentMapper.toEntity(paymentDTO);
        paymentRepository.persist(payment);
        return paymentMapper.toDTO(payment);
    }

    @Transactional
    public PaymentDTO update(UUID id, PaymentDTO paymentDTO) {
        Payment payment = paymentRepository.findById(id);
        if (payment == null) {
            throw new NotFoundException("Payment not found with id: " + id);
        }
        payment.setAmount(paymentDTO.getAmount());
        payment.setCurrency(paymentDTO.getCurrency());
        payment.setPaymentMethod(paymentDTO.getPaymentMethod());
        payment.setStatus(paymentDTO.getStatus());
        payment.setTransactionId(paymentDTO.getTransactionId());
        payment.setPaidAt(paymentDTO.getPaidAt());
        payment.setConfirmedAt(paymentDTO.getConfirmedAt());

        if (paymentDTO.getUserId() != null) {
            payment.setUser(appUserRepository.findById(paymentDTO.getUserId()));
        }
        if (paymentDTO.getPoolId() != null) {
            payment.setPool(poolRepository.findById(paymentDTO.getPoolId()));
        }

        return paymentMapper.toDTO(payment);
    }

    @Transactional
    public void delete(UUID id) {
        if (!paymentRepository.deleteById(id)) {
            throw new NotFoundException("Payment not found with id: " + id);
        }
    }
}
