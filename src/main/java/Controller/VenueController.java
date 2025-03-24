package Controller;

import Dao.CourtDao;
import Dao.VenueDao;
import Model.Court;
import Model.User;
import Model.Venue;
import Util.UploadImage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalTime;
import java.util.List;

public class VenueController {
    @WebServlet("/court-owner")
    @MultipartConfig
    public static class VenueServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            User user = (User) req.getSession().getAttribute("user");
            List<Venue> venues = new VenueDao().getAllVenuesAndCourtsByUserId(user.getId());
            req.setAttribute("venues", venues);
            req.getRequestDispatcher("/views/court_owner/venue.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String name = req.getParameter("name");
            String address = req.getParameter("address");
            String openTime = req.getParameter("openTime");
            String closeTime = req.getParameter("closeTime");
            String image = UploadImage.saveImage(req, "image");
            User user = (User) req.getSession().getAttribute("user");
            Venue venue = new Venue(name, address, image, LocalTime.parse(openTime), LocalTime.parse(closeTime), user);
            new VenueDao().save(venue);
            req.getSession().setAttribute("success", "Thêm mới thành công.");
            resp.sendRedirect(req.getContextPath() + "/court-owner");
        }
    }
    @WebServlet("/court-owner/detail")
    @MultipartConfig
    public static class VenueDetailServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            int venueId = Integer.parseInt(req.getParameter("id"));
            User user = (User) req.getSession().getAttribute("user");
            Venue venue = new VenueDao().getVenueByUserIdAndVenueId(user.getId(), venueId);
            req.setAttribute("venue", venue);
            req.getRequestDispatcher("/views/court_owner/venue-detail.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            long id = Long.parseLong(req.getParameter("id"));
            Venue venue = new VenueDao().getById(id);
            if (venue == null) {
                req.getSession().setAttribute("warning", "Sân không tồn tại");
            } else {
                String name = req.getParameter("name");
                String address = req.getParameter("address");
                String openTime = req.getParameter("openTime");
                String closeTime = req.getParameter("closeTime");
                if (req.getPart("image") != null){
                    String image = UploadImage.saveImage(req, "image");
                    venue.setImage(image);
                }
                venue.setName(name);
                venue.setAddress(address);
                venue.setOpenTime(LocalTime.parse(openTime));
                venue.setCloseTime(LocalTime.parse(closeTime));
                new VenueDao().update(venue);
                req.getSession().setAttribute("success", "Cập nhật thành công");
            }
            resp.sendRedirect(req.getContextPath() + "/court-owner/detail?id=" + id);
        }
    }
    @WebServlet("/court-owner/court")
    public static class CourtServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String court_id = req.getParameter("court_id");
            Court court = new CourtDao().getById(Long.parseLong(court_id));
            if (court == null) {
                req.getSession().setAttribute("warning", "Sân không tồn tại");
            } else {
                court.setAvailable(!court.isAvailable());
                new CourtDao().update(court);
            }
            resp.sendRedirect(req.getHeader("Referer"));
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String name = req.getParameter("name");
            boolean isAvailable = Boolean.parseBoolean(req.getParameter("isAvailable"));
            double pricePerHour = Double.parseDouble(req.getParameter("pricePerHour"));
            long venueId = Long.parseLong(req.getParameter("venueId"));
            Venue venue = new VenueDao().getById(venueId);
            if (venue == null) {
                req.getSession().setAttribute("warning", "Sân không tồn tại");
            } else {
                Court check = new CourtDao().findByName(name);
                if (check != null){
                    req.getSession().setAttribute("warning", "Số sân đã tồn tại.");
                } else {
                    Court court = new Court();
                    court.setName(name);
                    court.setPricePerHour(pricePerHour);
                    court.setVenue(venue);
                    court.setAvailable(isAvailable);
                    new CourtDao().save(court);
                    req.getSession().setAttribute("success", "Thêm sân thành công.");
                }
            }
            resp.sendRedirect(req.getContextPath() + "/court-owner/detail?id=" + venueId);
        }
    }
}
