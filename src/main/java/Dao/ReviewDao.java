package Dao;

import Model.Review;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class ReviewDao extends GenericDao<Review> {
    public ReviewDao() {
        super();
    }
    public List<Review> getReviewsByVenueId(long venueId) {
        TypedQuery<Review> query = entityManager.createQuery(
                "SELECT r FROM Review r " +
                        "JOIN FETCH r.booking b " +
                        "JOIN FETCH b.court c " +
                        "WHERE c.id IN (SELECT c2.id FROM Court c2 WHERE c2.venue.id = :venueId)",
                Review.class
        );
        return query.setParameter("venueId", venueId).getResultList();
    }

}
