package Dao;

import Model.Court;
import Model.Venue;
import Util.Util;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import jakarta.persistence.criteria.*;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class VenueDao extends GenericDao<Venue>{
    public VenueDao() {
        super();
    }
    public List<Venue> getAllVenuesAndCourtsByUserId(long user_id) {
        TypedQuery<Venue> query = entityManager.createQuery("select v from Venue v where v.owner.id = :user_id", Venue.class);
        query.setParameter("user_id", user_id);
        return query.getResultList();
    }
    public Venue getVenueByUserIdAndVenueId(long user_id, long venue_id) {
        TypedQuery<Venue> query = entityManager.createQuery("select v from Venue v left join fetch v.courts where v.owner.id = :user_id and v.id = : venue_id", Venue.class);
        query.setParameter("user_id", user_id);
        query.setParameter("venue_id", venue_id);
        return query.getResultStream().findFirst().orElse(null);
    }
    public List<Venue> searchVenues(String query, Double priceFrom, Double priceTo, LocalTime openTime, LocalTime closeTime) {
        CriteriaBuilder cb = entityManager.getCriteriaBuilder();
        CriteriaQuery<Venue> cq = cb.createQuery(Venue.class);
        Root<Venue> root = cq.from(Venue.class);
        Join<Venue, Court> courtJoin = root.join("courts", JoinType.LEFT);

        List<Predicate> predicates = new ArrayList<>();
        predicates.add(cb.isFalse(root.get("deleted")));
        if (query != null && !query.trim().isEmpty()) {
            String likeQuery = "%" + Util.removeAccents(query.trim().toLowerCase()) + "%";
            predicates.add(cb.or(
                    cb.like(cb.lower(root.get("normalizedName")), likeQuery),
                    cb.like(cb.lower(root.get("normalizedAddress")), likeQuery)
            ));
        }

        if (priceFrom != null) {
            predicates.add(cb.ge(courtJoin.get("pricePerHour"), priceFrom));
        }

        if (priceTo != null) {
            predicates.add(cb.le(courtJoin.get("pricePerHour"), priceTo));
        }

        if (openTime != null) {
            predicates.add(cb.lessThanOrEqualTo(root.get("openTime"), openTime));
        }

        if (closeTime != null) {
            predicates.add(cb.greaterThanOrEqualTo(root.get("closeTime"), closeTime));
        }

        cq.select(root).where(cb.and(predicates.toArray(new Predicate[0]))).distinct(true);

        return entityManager.createQuery(cq).getResultList();
    }
}
