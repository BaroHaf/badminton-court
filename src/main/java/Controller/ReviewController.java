package Controller;

import Dao.BookingDao;
import Dao.ReviewDao;
import Model.Booking;
import Model.Review;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class ReviewController {
    @WebServlet("/customer/review")
    public static class CustomerReviewServlet extends HttpServlet {
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            long booking_id = Long.parseLong(req.getParameter("booking_id"));
            User user = (User) req.getSession().getAttribute("user");
            Booking booking = new BookingDao().getByIdAndUserId(booking_id, user.getId());
            if (booking == null) {
                req.getSession().setAttribute("warning", "Booking id không tồn tại.");
            } else {
                int rate = Integer.parseInt(req.getParameter("rate"));
                if (rate <= 5 && rate >= 0){
                    String comment = req.getParameter("comment");
                    Review review = new Review(booking, rate, comment);
                    new ReviewDao().save(review);
                    req.getSession().setAttribute("success", "Đánh giá thành công.");
                } else {
                    req.getSession().setAttribute("warning", "Số sao chỉ được trong khoảng 0 đến 5");
                }
            }
            resp.sendRedirect(req.getHeader("referer"));
        }
    }
}
