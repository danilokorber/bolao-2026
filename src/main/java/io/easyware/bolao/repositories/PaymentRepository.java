package io.easyware.bolao.repositories;

import io.easyware.bolao.entities.Payment;
import io.easyware.bolao.enums.PaymentStatus;
import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;
import java.util.UUID;

@ApplicationScoped
public class PaymentRepository implements PanacheRepositoryBase<Payment, UUID> {

    public List<Payment> findByUser(UUID userId) {
        return list("user.id", userId);
    }

    public List<Payment> findByPool(UUID poolId) {
        return list("pool.id", poolId);
    }

    public List<Payment> findByUserAndPool(UUID userId, UUID poolId) {
        return list("user.id = ?1 and pool.id = ?2", userId, poolId);
    }

    public List<Payment> findByStatus(PaymentStatus status) {
        return list("status", status);
    }

    public Payment findByTransactionId(String transactionId) {
        return find("transactionId", transactionId).firstResult();
    }

    public List<Payment> findPendingByPool(UUID poolId) {
        return list("pool.id = ?1 and status = ?2", poolId, PaymentStatus.PENDING);
    }
}
