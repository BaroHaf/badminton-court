package Controller;

import Dao.ProductDao;
import Dao.SaleRecordDao;
import Model.Product;
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

public class SaleRecordController {
    @WebServlet("/court-owner/sale-record")
    public static class SaleRecordServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            User user = (User) req.getSession().getAttribute("user");
            LocalDate today = LocalDate.now();
            LocalDateTime startOfDay = today.atStartOfDay();
            LocalDateTime endOfDay = today.atTime(23, 59, 59);
            List<SaleRecord> saleRecords = new SaleRecordDao().getSalesBetween(user.getId(), startOfDay, endOfDay);
            List<Product> products = new ProductDao().findAllByUserIdAndDeletedFalse(user.getId());
            req.setAttribute("products", products);
            req.setAttribute("saleRecords", saleRecords);
            req.setAttribute("startOfDay", startOfDay);
            req.setAttribute("endOfDay", endOfDay);
            req.getRequestDispatcher("/views/court_owner/sale-record.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            User user = (User) req.getSession().getAttribute("user");
            int quantity = Integer.parseInt(req.getParameter("quantity"));
            long product_id = Long.parseLong(req.getParameter("product_id"));
            Product product = new ProductDao().getById(product_id);
            if (product != null) {
                SaleRecord saleRecord = new SaleRecord(product, quantity, product.getPrice(), product.getPrice() * quantity, user);
                new SaleRecordDao().save(saleRecord);
            } else {
                req.getSession().setAttribute("warning", "Sản phẩm không tồn tại.");
            }
            resp.sendRedirect(req.getContextPath() + "/court-owner/sale-record");
        }
    }

    @WebServlet("/court-owner/sale-record/delete")
    public static class SaleRecordDeleteServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            long sale_record_id = Long.parseLong(req.getParameter("sale_record_id"));
            new SaleRecordDao().delete(sale_record_id);
            resp.sendRedirect(req.getContextPath() + "/court-owner/sale-record");
        }
    }
}
