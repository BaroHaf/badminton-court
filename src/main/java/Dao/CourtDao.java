package Dao;

import Model.Court;
import jakarta.persistence.TypedQuery;

public class CourtDao extends GenericDao<Court>{
    public CourtDao() {
        super();
    }
    public Court findByName(String name) {
        TypedQuery<Court> courtTypedQuery = entityManager.createQuery("select c from Court c where c.name = :name", Court.class);
        courtTypedQuery.setParameter("name", name);
        return courtTypedQuery.getResultStream().findFirst().orElse(null);
    }
}
