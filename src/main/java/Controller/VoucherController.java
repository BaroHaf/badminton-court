package Controller;

import Dao.CourtDao;
import Dao.VoucherDao;
import Model.Constant.Rank;
import Model.Constant.VoucherType;
import Model.Court;
import Model.Voucher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;

public class VoucherController {
    @WebServlet("/admin/voucher")
    public static class CourtOwnerVoucherController extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("/views/admin/vouchers.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String code = req.getParameter("code");
            VoucherType type = VoucherType.valueOf(req.getParameter("type"));
            int discount = Integer.parseInt(req.getParameter("discount"));
            LocalDate startDate = LocalDate.parse(req.getParameter("startDate"));
            LocalDate endDate = LocalDate.parse(req.getParameter("endDate"));
            if (endDate.isBefore(startDate)){
                req.getSession().setAttribute("warning", "Ngày kết thúc phải sau ngày bắt đầu");
            } else {
                Rank forRank = Rank.valueOf(req.getParameter("forRank"));
                Voucher voucher = new Voucher(code, type, discount, startDate, endDate, false, forRank);
                new VoucherDao().save(voucher);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/voucher");
        }
    }

    @WebServlet("/admin/voucher/update")
    public static class UpdateVoucherController extends HttpServlet {
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            long id = Long.parseLong(req.getParameter("id"));
            String code = req.getParameter("code");
            VoucherType type = VoucherType.valueOf(req.getParameter("type"));
            int discount = Integer.parseInt(req.getParameter("discount"));
            boolean disabled = "on".equals(req.getParameter("disabled"));
            LocalDate startDate = LocalDate.parse(req.getParameter("startDate"));
            LocalDate endDate = LocalDate.parse(req.getParameter("endDate"));
            Voucher voucher = new VoucherDao().getById(id);
            voucher.setCode(code);
            voucher.setType(type);
            voucher.setDiscount(discount);
            voucher.setStartDate(startDate);
            voucher.setEndDate(endDate);
            voucher.setDisabled(disabled);
            new VoucherDao().update(voucher);
            resp.sendRedirect(req.getContextPath() + "/admin/voucher");
        }
    }
    @WebServlet("/api/calculate-price-with-voucher")
    public static class CalculatePriceWithVoucher extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String voucherCode = req.getParameter("voucherCode");
            long courtId = Long.parseLong(req.getParameter("courtId"));
            float hours = Float.parseFloat(req.getParameter("hours"));
            Court court = new CourtDao().getById(courtId);
            Voucher voucher = new VoucherDao().findByCodeNotDisableAndValidTime(voucherCode);
            System.out.println(voucher);
            long amount = (long) (hours * court.getPricePerHour());
            if (voucher != null){
                amount = voucher.calculateDiscountdisplay(amount);
            }
            resp.getWriter().print(amount);
        }
    }
}
