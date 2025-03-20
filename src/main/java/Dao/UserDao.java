package Dao;

import Model.User;
import jakarta.persistence.TypedQuery;

public class UserDao extends GenericDao<User>{
    public UserDao() {
        super();
    }
    public User findByUsername(String username) {
        try {
            TypedQuery<User> query = entityManager.createQuery("SELECT u FROM User u WHERE u.username = :username", User.class);
            query.setParameter("username", username);
            return query.getResultStream().findFirst().orElse(null);
        } finally {
            entityManager.close();
        }
    }

    public User findByEmail(String email) {
        try {
            TypedQuery<User> query = entityManager.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class);
            query.setParameter("email", email);
            return query.getResultStream().findFirst().orElse(null);
        } finally {
            entityManager.close();
        }
    }

    public User findByPhone(String phone) {
        try {
            TypedQuery<User> query = entityManager.createQuery("SELECT u FROM User u WHERE u.phone = :phone", User.class);
            query.setParameter("phone", phone);
            return query.getResultStream().findFirst().orElse(null);
        } finally {
            entityManager.close();
        }
    }
    public User findByToken(String token){
        try {
            TypedQuery<User> query = entityManager.createQuery("SELECT u FROM User u WHERE u.token = :token", User.class);
            query.setParameter("token", token);
            return query.getResultStream().findFirst().orElse(null);
        } finally {
            entityManager.close();
        }
    }
}
