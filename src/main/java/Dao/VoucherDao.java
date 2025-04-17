package Dao;

import Model.Voucher;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.time.LocalDate;

public class VoucherDao extends GenericDao<Voucher>{
    public VoucherDao() {
        super();
    }
    public Voucher findByCodeNotDisableAndValidTime(String code){
        LocalDate localDate = LocalDate.now();
        TypedQuery<Voucher> voucherTypedQuery = entityManager.createQuery("select v from Voucher v where v.code = :code and v.disabled = false and v.startDate <= :localDate and v.endDate >= :localDate", Voucher.class);
        voucherTypedQuery.setParameter("code", code);
        voucherTypedQuery.setParameter("localDate", localDate);
        try {
            return voucherTypedQuery.getSingleResult();
        } catch (NoResultException e){
            return null;
        }
    }
}
