package Dao;

import Model.Court;
import jakarta.persistence.TypedQuery;

public class CourtDao extends GenericDao<Court>{
    public CourtDao() {
        super();
    }
    public Court findByName(String name, long id) {
        TypedQuery<Court> courtTypedQuery = entityManager.createQuery("select c from Court c where c.name = :name and c.venue.id = :id", Court.class);
        courtTypedQuery.setParameter("name", name);
        courtTypedQuery.setParameter("id", id);
        return courtTypedQuery.getResultStream().findFirst().orElse(null);
    }
}
