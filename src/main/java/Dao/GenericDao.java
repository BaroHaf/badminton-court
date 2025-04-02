package Dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Persistence;
import java.lang.reflect.ParameterizedType;

import java.util.List;

public abstract class GenericDao<T> {
    private static final EntityManagerFactory ENTITY_MANAGER_FACTORY = Persistence.createEntityManagerFactory("badminton_court");

    private final Class<T> entityClass;
    protected EntityManager entityManager;

    @SuppressWarnings("unchecked")
    public GenericDao() {
        this.entityClass = (Class<T>) ((ParameterizedType) getClass().getGenericSuperclass()).getActualTypeArguments()[0];
        this.entityManager = ENTITY_MANAGER_FACTORY.createEntityManager(); // Use existing factory
    }

    public List<T> getAll() {
        return entityManager.createQuery("SELECT e FROM " + entityClass.getSimpleName() + " e", entityClass).getResultList();
    }

    public T getById(Long id) {
        return entityManager.find(entityClass, id);
    }

    public void save(T entity) {
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();
            entityManager.persist(entity);
            transaction.commit();
        } catch (Exception e) {
            transaction.rollback();
            e.printStackTrace();
        }
    }

    public void saveAll(List<T> entities) {
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();
            for (T entity : entities) {
                entityManager.persist(entity);
            }
            transaction.commit();
        } catch (Exception e) {
            transaction.rollback();
            e.printStackTrace();
        }
    }


    public void update(T entity) {
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();
            entityManager.merge(entity);
            transaction.commit();
        } catch (Exception e) {
            transaction.rollback();
            e.printStackTrace();
        }
    }

    public void updateAll(List<T> entities) {
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();
            for (T entity : entities) {
                entityManager.merge(entity);
            }
            transaction.commit();
        } catch (Exception e) {
            transaction.rollback();
            e.printStackTrace();
        }
    }

    public void delete(Long id) {
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();
            T entity = entityManager.find(entityClass, id);
            if (entity != null) {
                entityManager.remove(entity);
            }
            transaction.commit();
        } catch (Exception e) {
            transaction.rollback();
            e.printStackTrace();
        }
    }

    public void close() {
        entityManager.close();
    }
}
