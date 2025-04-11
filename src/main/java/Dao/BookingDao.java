package Dao;

import Model.Booking;
import Model.Constant.BookingStatus;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

public class BookingDao extends GenericDao<Booking>{
    public BookingDao() {
        super();
    }
    public List<Booking> findWithCourtIdAndStartTimeAndEndTimeAndStatus(long courtId, LocalDateTime startTime, LocalDateTime endTime) {
        TypedQuery<Booking> query = entityManager.createQuery("select b from Booking b where b.court.id = :courId and (b.startTime < :endTime and b.endTime > :startTime) and b.status = :status", Booking.class);
        query.setParameter("courId", courtId);
        query.setParameter("startTime", startTime);
        query.setParameter("endTime", endTime);
        query.setParameter("status", BookingStatus.CONFIRMED);
        return query.getResultList();
    }
    public List<Booking> getPendingBookingsByUserId(long userId) {
        TypedQuery<Booking> query= entityManager.createQuery("select b from Booking b where b.user.id = :userId and b.status = :status", Booking.class);
        query.setParameter("userId", userId);
        query.setParameter("status", BookingStatus.PENDING);
        return query.getResultList();
    }
    public List<Booking> getAllByUserId(long user_id){
        TypedQuery<Booking> query = entityManager.createQuery("select b from Booking b left join fetch b.review where b.user.id = :userId", Booking.class);
        query.setParameter("userId", user_id);
        return query.getResultList();
    }
    public void changeStatusBooking(long booking_id, BookingStatus bookingStatus){
        entityManager.getTransaction().begin();
        Query query = entityManager.createQuery("update Booking b set b.status = :status where b.id = :booking_id");
        query.setParameter("status", bookingStatus);
        query.setParameter("booking_id", booking_id);
        query.executeUpdate();
        entityManager.getTransaction().commit();
    }
    public List<Booking> getBookingsIn(long[] ids){
        List<Long> idList = Arrays.stream(ids).boxed().toList();
        TypedQuery<Booking> query = entityManager.createQuery("select b from Booking b left join fetch Court c on c.id = b.court.id where b.id in :ids", Booking.class);
        query.setParameter("ids", idList);
        return query.getResultList();
    }
    public Booking getByIdAndUserId(long booking_id, long user_id){
        TypedQuery<Booking> query = entityManager.createQuery("select b from Booking b where b.user.id = :user_id and b.id = :id", Booking.class);
        query.setParameter("user_id", user_id);
        query.setParameter("id", booking_id);
        return query.getSingleResult();
    }
    public List<Booking> getAllByOwnerId(long ownerId){
        TypedQuery<Booking> query = entityManager.createQuery("select b from Booking b where b.court.venue.owner.id = :ownerID", Booking.class);
        query.setParameter("ownerID", ownerId);
        return query.getResultList();
    }
    public List<Booking> getBookingsBefore(long ownerId, LocalDateTime to) {
        TypedQuery<Booking> query = entityManager.createQuery(
                "select b from Booking b where b.court.venue.owner.id = :ownerId and b.startTime <= :to",
                Booking.class
        );
        query.setParameter("ownerId", ownerId);
        query.setParameter("to", to);
        return query.getResultList();
    }
    public List<Booking> getBookingsAfter(long ownerId, LocalDateTime from) {
        TypedQuery<Booking> query = entityManager.createQuery(
                "select b from Booking b where b.court.venue.owner.id = :ownerId and b.startTime >= :from",
                Booking.class
        );
        query.setParameter("ownerId", ownerId);
        query.setParameter("from", from);
        return query.getResultList();
    }
    public List<Booking> getBookingsBetween(long ownerId, LocalDateTime from, LocalDateTime to) {
        TypedQuery<Booking> query = entityManager.createQuery(
                "select b from Booking b where b.court.venue.owner.id = :ownerId and b.startTime between :from and :to",
                Booking.class
        );
        query.setParameter("ownerId", ownerId);
        query.setParameter("from", from);
        query.setParameter("to", to);
        return query.getResultList();
    }
    public List<Booking> getConfirmedBookingIn(LocalDateTime start, LocalDateTime end){
        TypedQuery<Booking> query  = entityManager.createQuery("select b from Booking b join fetch b.court join fetch b.user where b.status = :status and b.startTime >= :start and b.endTime < :end order by b.startTime", Booking.class);
        query.setParameter("status", BookingStatus.CONFIRMED);
        query.setParameter("start", start);
        query.setParameter("end", end);
        return query.getResultList();
    }
}
