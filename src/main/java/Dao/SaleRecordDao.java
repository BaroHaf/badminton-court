package Dao;

import Model.SaleRecord;
import jakarta.persistence.TypedQuery;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class SaleRecordDao extends GenericDao<SaleRecord> {
    public SaleRecordDao() {
        super();
    }
    public List<SaleRecord> getSalesByOwnerId(long ownerId) {
        TypedQuery<SaleRecord> query = entityManager.createQuery(
                "SELECT s FROM SaleRecord s WHERE s.owner.id = :ownerId",
                SaleRecord.class
        );
        query.setParameter("ownerId", ownerId);
        return query.getResultList();
    }
    public List<SaleRecord> getSalesBefore(long ownerId, LocalDateTime to) {
        TypedQuery<SaleRecord> query = entityManager.createQuery(
                "SELECT s FROM SaleRecord s WHERE s.owner.id = :ownerId AND s.createdAt <= :to",
                SaleRecord.class
        );
        query.setParameter("ownerId", ownerId);
        query.setParameter("to", Timestamp.valueOf(to));
        return query.getResultList();
    }
    public List<SaleRecord> getSalesAfter(long ownerId, LocalDateTime from) {
        TypedQuery<SaleRecord> query = entityManager.createQuery(
                "SELECT s FROM SaleRecord s WHERE s.owner.id = :ownerId AND s.createdAt >= :from",
                SaleRecord.class
        );
        query.setParameter("ownerId", ownerId);
        query.setParameter("from", Timestamp.valueOf(from));
        return query.getResultList();
    }

    public List<SaleRecord> getSalesBetween(long ownerId, LocalDateTime from, LocalDateTime to) {
        TypedQuery<SaleRecord> query = entityManager.createQuery(
                "SELECT s FROM SaleRecord s WHERE s.owner.id = :ownerId AND s.createdAt BETWEEN :from AND :to order by id desc",
                SaleRecord.class
        );
        query.setParameter("ownerId", ownerId);
        query.setParameter("from", Timestamp.valueOf(from));
        query.setParameter("to", Timestamp.valueOf(to));
        return query.getResultList();
    }


}
