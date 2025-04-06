package Dao;

import Model.Product;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class ProductDao extends GenericDao<Product> {
    public ProductDao() {
        super();
    }
    public List<Product> findAllByUserId(long userId) {
        TypedQuery<Product> query = entityManager.createQuery("select p from Product p where p.owner.id = :userId", Product.class);
        query.setParameter("userId", userId);
        return query.getResultList();
    }
}
