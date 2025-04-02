package Dao;

import Model.Voucher;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

public class VoucherDao extends GenericDao<Voucher>{
    public VoucherDao() {
        super();
    }
    public Voucher findByCodeNotDisable(String code){
        TypedQuery<Voucher> voucherTypedQuery = entityManager.createQuery("select v from Voucher v where v.code = :code and v.disabled = false", Voucher.class);
        voucherTypedQuery.setParameter("code", code);
        try {
            return voucherTypedQuery.getSingleResult();
        } catch (NoResultException e){
            return null;
        }
    }
}
