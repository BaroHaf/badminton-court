package Controller;

import Dao.UserDao;
import Model.Constant.Role;
import Model.User;
import Util.Config;
import Util.Mail;
import Util.UploadImage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class UserController {
    @WebServlet("/login")
    public static class LoginServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("/views/public/login.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String password = req.getParameter("password");
            String username = req.getParameter("username");
            User user = new UserDao().findByUsername(username);
            if (user == null) {
                req.getSession().setAttribute("warning", "Tài khoản hoặc mật khẩu không đúng.");
                resp.sendRedirect(req.getContextPath() + "/login");
            } else {
                if (BCrypt.checkpw(password, user.getPassword())){
                    if (!user.isVerified()){
                        req.getSession().setAttribute("warning", "Tài khoản chưa được kích hoạt.");
                        resp.sendRedirect(req.getContextPath() + "/login");
                    } else {
                        req.getSession().setAttribute("user", user);
                        req.getSession().setAttribute("success", "Đăng nhập thành công.");
                        resp.sendRedirect(req.getContextPath() + "/");
                    }
                } else {
                    req.getSession().setAttribute("warning", "Tài khoản hoặc mật khẩu không đúng.");
                    resp.sendRedirect(req.getContextPath() + "/login");
                }
            }
        }
    }

    @WebServlet("/register")
    public static class RegisterServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("/views/public/register.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String username = req.getParameter("username");
            String password = req.getParameter("password");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            if (new UserDao().findByEmail(email) != null) {
                req.getSession().setAttribute("warning", "Email đang được sử dụng.");
                resp.sendRedirect(req.getContextPath() + "/register");
            } else if (new UserDao().findByPhone(phone) != null) {
                req.getSession().setAttribute("warning", "Số điện thoại đang được sử dụng.");
                resp.sendRedirect(req.getContextPath() + "/register");
            } else if (new UserDao().findByUsername(username) != null) {
                req.getSession().setAttribute("warning", "Username đang được sử dụng.");
                resp.sendRedirect(req.getContextPath() + "/register");
            } else {
                String token = UUID.randomUUID().toString() + System.currentTimeMillis();
                password = BCrypt.hashpw(password, BCrypt.gensalt());
                Role role = Role.valueOf(req.getParameter("role"));
                if (role == Role.ADMIN) {
                    role = Role.CUSTOMER;
                }
                User user = new User(email, username, password, phone, role, "uploads/default-avatar.png", false, false, token);
                new UserDao().save(user);
                // send mail
                ExecutorService executorService = Executors.newSingleThreadExecutor();
                executorService.submit(() -> {
                    try {
                        String url = Config.app_url + req.getContextPath() + "/verify-email?token=" + token;
                        String html = "Chúc mừng bạn đã đăng kí thành công, vui lòng nhấn vào <a href='url'>đây</a> để xác thực email của bạn.".replace("url", url);
                        Mail.send(email, "Đăng kí tài khoản", html);
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                });
                executorService.shutdown();
                // end send mail
                req.getSession().setAttribute("success", "Đăng kí thành công, vui lòng kiểm tra email.");
                resp.sendRedirect(req.getContextPath() + "/login");
            }
        }
    }

    @WebServlet("/verify-email")
    public static class VerifyServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String token = req.getParameter("token");
            User user = new UserDao().findByToken(token);
            if (user != null) {
                user.setToken(null);
                user.setVerified(true);
                new UserDao().update(user);
                req.getSession().setAttribute("success", "Kích hoạt tài khoản thành công.");
            } else {
                req.getSession().setAttribute("warning", "Token không tồn tại hoặc không hợp lệ");
            }
            resp.sendRedirect(req.getContextPath() + "/login");
        }
    }
    @WebServlet("/logout")
    public static class LogoutServlet extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getSession().invalidate();
            resp.sendRedirect(req.getContextPath() + "/");
        }
    }
    @WebServlet("/admin/users")
    public static class AdminUsersServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            List<User> users = new UserDao().getAll();
            req.setAttribute("users", users);
            req.getRequestDispatcher("/views/admin/users.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String username = req.getParameter("username");
            String password = req.getParameter("password");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            boolean verified = Boolean.parseBoolean(req.getParameter("verified"));
            boolean blocked = Boolean.parseBoolean(req.getParameter("blocked"));
            Role role = Role.valueOf(req.getParameter("role"));
            long id = Integer.parseInt(req.getParameter("id"));
            User user = new UserDao().getById(id);
            if (user != null){
                user.setUsername(username);
                user.setEmail(email);
                user.setPhone(phone);
                user.setVerified(verified);
                user.setBlocked(blocked);
                user.setRole(role);
                if (!password.isEmpty()){
                    user.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
                }
                new UserDao().update(user);
                req.getSession().setAttribute("success", "Cập nhật thành công.");
            } else {
                req.getSession().setAttribute("warning", "Tài khoản không tồn tại.");
            }
            resp.sendRedirect(req.getContextPath() + "/admin/users");
        }
    }

    @WebServlet("/user/profile")
    public static class UserProfile extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("/views/user/profile.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String username = req.getParameter("username");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String password = req.getParameter("password");
            User user = (User) req.getSession().getAttribute("user");
            if (!user.getUsername().equals(username)){
                if (new UserDao().findByUsername(username) != null){
                    req.getSession().setAttribute("warning", "Username đã được sử dụng.");
                } else {
                    user.setUsername(username);
                }
            }
            if (!user.getEmail().equals(email)){
                if (new UserDao().findByEmail(email) != null){
                    req.getSession().setAttribute("warning", "Email đã được sử dụng.");
                } else {
                    user.setEmail(email);
                }
            }
            if (!user.getPhone().equals(phone)){
                if (new UserDao().findByPhone(phone) != null){
                    req.getSession().setAttribute("warning", "Số điện thoại đang được sử dụng.");
                } else {
                    user.setPhone(phone);
                }
            }
            if (!password.isEmpty()){
                user.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
            }
            new UserDao().update(user);
            req.getSession().setAttribute("success", "Cập nhật thành công.");
            resp.sendRedirect(req.getContextPath() + "/user/profile");
        }
    }
    @WebServlet("/admin/create-user")
    public static class AdminCreatUser extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String username = req.getParameter("username");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String password = req.getParameter("password");
            boolean verified = Boolean.parseBoolean(req.getParameter("verified"));
            boolean blocked = Boolean.parseBoolean(req.getParameter("blocked"));
            Role role = Role.valueOf(req.getParameter("role"));
            if (new UserDao().findByEmail(email) != null) {
                req.getSession().setAttribute("warning", "Email đang được sử dụng.");
                resp.sendRedirect(req.getContextPath() + "/admin/create-user");
            } else if (new UserDao().findByPhone(phone) != null) {
                req.getSession().setAttribute("warning", "Số điện thoại đang được sử dụng.");
                resp.sendRedirect(req.getContextPath() + "/admin/create-user");
            } else if (new UserDao().findByUsername(username) != null) {
                req.getSession().setAttribute("warning", "Username đang được sử dụng.");
                resp.sendRedirect(req.getContextPath() + "/admin/create-user");
            } else {
                User user = new User(email, username, password, "uploads/default-avatar.png", phone, verified, blocked, role);
                new UserDao().save(user);
                req.getSession().setAttribute("success", "Tạo tài khoản thành công.");
                resp.sendRedirect(req.getContextPath() + "/admin/users");
            }
        }
    }

    @WebServlet("/user/avatar")
    @MultipartConfig
    public static class UserAvatar extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String filename = UploadImage.saveImage(req, "avatar");
            User user = (User) req.getSession().getAttribute("user");
            user.setAvatar(filename);
            new UserDao().update(user);
            req.getSession().setAttribute("user", user);
            resp.sendRedirect(req.getHeader("referer"));
        }
    }
}
