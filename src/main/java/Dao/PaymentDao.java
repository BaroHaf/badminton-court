package Dao;

import Model.Payment;
import jakarta.persistence.TypedQuery;

public class PaymentDao extends GenericDao<Payment>{
    public PaymentDao() {
        super();
    }
    public Payment findByOrderInfo(String orderInfo){
        TypedQuery<Payment> query = entityManager.createQuery("select p from Payment p where p.orderInfo = :orderInfo", Payment.class);
        query.setParameter("orderInfo", orderInfo);
        return query.getSingleResult();
    }
    public long getAmountPaidByUserId(long userId){
        TypedQuery<Long> query = entityManager.createQuery("select sum(p.amount) from Payment p where p.booking.user.id = :userId and p.transactionStatus = 'SUCCESS'", Long.class);
        query.setParameter("userId", userId);
        return query.getSingleResult();
    }
}
