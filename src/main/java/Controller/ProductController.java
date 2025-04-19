package Controller;

import Dao.ProductDao;
import Model.Product;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class ProductController {
    @WebServlet("/court-owner/products")
    public static class ProductsServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            User user = (User) req.getSession().getAttribute("user");
            List<Product> products = new ProductDao().findAllByUserIdAndDeletedFalse(user.getId());
            req.setAttribute("products", products);
            req.getRequestDispatcher("/views/court_owner/products.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            User user = (User) req.getSession().getAttribute("user");
            String name = req.getParameter("name");
            double price = Double.parseDouble(req.getParameter("price"));
            if (price < 0){
                req.getSession().setAttribute("warning", "Giá không được thấp hơn 0.");
            }
            Product product = new Product(name, price, user, false);
            new ProductDao().save(product);
            resp.sendRedirect(req.getContextPath() + "/court-owner/products");
        }
    }

    @WebServlet("/court-owner/update-product")
    public static class UpdateProductServlet extends HttpServlet {
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            User user = (User) req.getSession().getAttribute("user");
            String name = req.getParameter("name");
            double price = Double.parseDouble(req.getParameter("price"));
            long id = Long.parseLong(req.getParameter("id"));
            Product product = new Product(name, price, user, false);
            product.setId(id);
            new ProductDao().update(product);
            resp.sendRedirect(req.getContextPath() + "/court-owner/products");
        }
    }
    @WebServlet("/court-owner/delete-product")
    public static class DeleteProductServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            long id = Long.parseLong(req.getParameter("id"));
            User owner = (User) req.getSession().getAttribute("user");
            ProductDao productDao = new ProductDao();
            Product product = productDao.findByIdAndUserId(id, owner.getId());
            product.setDeleted(true);
            productDao.update(product);
            resp.sendRedirect(req.getContextPath() + "/court-owner/products");
        }
    }
}
