package Controller;

import Dao.BookingDao;
import Dao.SaleRecordDao;
import Model.Booking;
import Model.SaleRecord;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class RevenueController {
    @WebServlet("/court-owner/revenue")
    public static class RevenueServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String from = req.getParameter("from");
            String to = req.getParameter("to");
            List<Booking> bookings;
            List<SaleRecord> saleRecords;
            BookingDao bookingDao = new BookingDao();
            SaleRecordDao saleRecordDao = new SaleRecordDao();
            User owner = (User) req.getSession().getAttribute("user");
            if (from.isEmpty() && to.isEmpty()) {
                bookings = bookingDao.getAllByOwnerId(owner.getId());
                saleRecords = saleRecordDao.getSalesByOwnerId(owner.getId());
            } else if (from.isEmpty()) {
                LocalDate toDate = LocalDate.parse(to);
                LocalDateTime toDateTime = toDate.atTime(23, 59);
                bookings = bookingDao.getBookingsBefore(owner.getId(), toDateTime);
                saleRecords = saleRecordDao.getSalesBefore(owner.getId(), toDateTime);
            } else if (to.isEmpty()) {
                LocalDate fromDate = LocalDate.parse(from);
                LocalDateTime fromDateTime = fromDate.atStartOfDay();
                bookings = bookingDao.getBookingsAfter(owner.getId(), fromDateTime);
                saleRecords = saleRecordDao.getSalesAfter(owner.getId(), fromDateTime);
            } else {
                LocalDate fromDate = LocalDate.parse(from);
                LocalDate toDate = LocalDate.parse(to);
                LocalDateTime fromDateTime = fromDate.atStartOfDay();
                LocalDateTime toDateTime = toDate.atTime(23, 59);
                bookings = bookingDao.getBookingsBetween(owner.getId(), fromDateTime, toDateTime);
                saleRecords = saleRecordDao.getSalesBetween(owner.getId(), fromDateTime, toDateTime);
            }

            req.setAttribute("bookings", bookings);
            req.setAttribute("saleRecords", saleRecords);
            req.getRequestDispatcher("/views/court_owner/revenue.jsp").forward(req, resp);
        }
    }
}
