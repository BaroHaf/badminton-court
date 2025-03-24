package Dao;

import Model.Venue;
import jakarta.persistence.TypedQuery;

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
}
