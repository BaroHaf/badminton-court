package Controller;

import Dao.BookingDao;
import Dao.CourtDao;
import Model.Booking;
import Model.Constant.BookingStatus;
import Model.Court;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;

public class BookingController {
    @WebServlet("/customer/book")
    public static class BookingServlet extends HttpServlet {
        public static boolean isStep30Minutes(LocalDateTime start, LocalDateTime end) {
            Duration duration = Duration.between(start, end);
            long minutes = duration.toMinutes();
            return minutes % 30 == 0;
        }
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            User user = (User) req.getSession().getAttribute("user");
            long court_id = Long.parseLong(req.getParameter("court_id"));
            Court court = new CourtDao().getById(court_id);
            LocalDateTime start_time = LocalDateTime.parse(req.getParameter("start_time"));
            LocalDateTime end_time = LocalDateTime.parse(req.getParameter("end_time"));
            boolean check = false;
            Booking booking = new Booking();
            if (court == null){
                req.getSession().setAttribute("warning", "Id sân cầu không hợp lệ.");
            } else if (court.getVenue().getOpenTime().isAfter(start_time.toLocalTime())){
                req.getSession().setAttribute("warning", "Giờ bắt đầu phải sau giờ mở cửa.");
            } else if (court.getVenue().getCloseTime().isBefore(end_time.toLocalTime())) {
                req.getSession().setAttribute("warning", "Giờ kết thúc phải trước giờ đóng cửa.");
            } else if (!new BookingDao().findWithCourtIdAndStartTimeAndEndTimeAndStatus(court_id, start_time, end_time).isEmpty()){
                req.getSession().setAttribute("warning", "Giờ này đã có người đặt.");
            } else if (start_time.isAfter(end_time)) {
                req.getSession().setAttribute("warning", "Giờ kết thúc phải sau giờ bắt đầu!");
            } else if (!start_time.toLocalDate().equals(end_time.toLocalDate())) {
                req.getSession().setAttribute("warning", "Thời gian bắt đầu và kết thúc phải trong cùng một ngày!");
            } else if (!isStep30Minutes(start_time, end_time)){
                req.getSession().setAttribute("warning", "Khoảng cách giữa giờ bắt đầu và kết thúc cách nhau bội số 30p!");
            } else if (start_time.isBefore(LocalDateTime.now())){
                req.getSession().setAttribute("warning", "Giờ bắt đầu phải sau thời điểm hiện tại.");
            } else {
                booking.setUser(user);
                booking.setCourt(court);
                booking.setCourtName(court.getName());
                booking.setVenueName(court.getVenue().getName());
                booking.setStartTime(start_time);
                booking.setEndTime(end_time);
                booking.setAmount(0);
                booking.setStatus(BookingStatus.PENDING);
                new BookingDao().save(booking);
                check = true;
            }
            if (check){
                resp.sendRedirect(req.getContextPath() + "/customer/payment?id=" + booking.getId() + "&voucherCode=" + req.getParameter("voucherCode"));
            } else {
                resp.sendRedirect(req.getHeader("referer"));
            }
        }
    }

    @WebServlet("/customer/bookings")
    public static class BookingsServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            User user = (User) req.getSession().getAttribute("user");
            List<Booking> bookings = new BookingDao().getAllByUserId(user.getId());
            req.setAttribute("bookings", bookings);
            req.getRequestDispatcher("/views/customer/bookings.jsp").forward(req, resp);
        }
    }

    @WebServlet("/customer/cancel-booking")
    public static class CancelBookingServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            long booking_id = Long.parseLong(req.getParameter("booking_id"));
            new BookingDao().changeStatusBooking(booking_id, BookingStatus.CANCELLED);
            resp.sendRedirect(req.getHeader("referer"));
        }
    }
}
