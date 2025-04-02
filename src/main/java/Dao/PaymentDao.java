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
}
