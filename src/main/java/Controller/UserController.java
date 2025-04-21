package Controller;

import Dao.UserDao;
import Model.Constant.Rank;
import Model.Constant.Role;
import Model.User;
import Util.Config;
import Util.Mail;
import Util.UploadImage;
import Util.Util;
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
                if (BCrypt.checkpw(password, user.getPassword())) {
                    if (!user.isVerified()) {
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
            } else if (!Util.isPasswordValid(password)){
                req.getSession().setAttribute("warning", "Mật khẩu phải có tối thiểu 8 kí tự và 1 kí tự đặc biệt.");
                resp.sendRedirect(req.getContextPath() + "/register");
            } else if (!Util.isUsernameValid(username)){
                req.getSession().setAttribute("warning", "Username không được chứa kí tự đặc biệt hoặc số.");
                resp.sendRedirect(req.getContextPath() + "/register");
            } else {
                String token = UUID.randomUUID().toString() + System.currentTimeMillis();
                password = BCrypt.hashpw(password, BCrypt.gensalt());
                Role role = Role.CUSTOMER;
                User user = new User(email, username, password, phone, role, "uploads/default-avatar.png", false, false, token, Rank.BRONZE);
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
    public static class LogoutServlet extends HttpServlet {
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
            if (user != null) {
                user.setUsername(username);
                user.setEmail(email);
                user.setPhone(phone);
                user.setVerified(verified);
                user.setBlocked(blocked);
                user.setRole(role);
                if (!password.isEmpty()) {
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
    public static class UserProfile extends HttpServlet {
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
            String oldPassword = req.getParameter("oldPassword");
            User user = (User) req.getSession().getAttribute("user");
            user = new UserDao().getById(user.getId());
            boolean check = true;
            boolean hasChanges = false;
            if (!user.getUsername().equals(username)) {
                if (new UserDao().findByUsername(username) != null) {
                    req.getSession().setAttribute("warning", "Username đã được sử dụng.");
                    check = false;
                }else if(!Util.isUsernameValid(username)){
                    req.getSession().setAttribute("warning", "Username phải dài hơn 8 kí tự và không chứa kí tự đặc biệt");
                    check = false;
                } else {
                    user.setUsername(username);
                    hasChanges=true;
                }
            }
            if (!user.getEmail().equals(email)) {
                if (!Util.isEmailValid(email)) {
                    req.getSession().setAttribute("warning", "Email không đúng định dạng Gmail.");
                    check = false;
                } else if (new UserDao().findByEmail(email) != null) {
                    req.getSession().setAttribute("warning", "Email đã được sử dụng.");
                    check = false;
                } else {
                    user.setEmail(email);
                    req.getSession().setAttribute("success", "Thành công cập nhật gmail.");
                    hasChanges = true;
                }
            }

            if ((oldPassword != null && !oldPassword.isEmpty()) || (password != null && !password.isEmpty())) {
                if (oldPassword == null || password == null || oldPassword.isEmpty() || password.isEmpty()) {
                    req.getSession().setAttribute("warning", "Không được để trống mật khẩu cũ hoặc mới.");
                    check = false;
                } else if (!BCrypt.checkpw(oldPassword, user.getPassword())) {
                    req.getSession().setAttribute("warning", "Mật khẩu cũ không khớp.");
                    check = false;
                } else if (oldPassword.equals(password)) {
                    req.getSession().setAttribute("warning", "Password không được trùng với password cũ.");
                    check = false;
                } else if (!Util.isPasswordValid(password)) {
                    req.getSession().setAttribute("warning", "Password mới phải có ít nhất 8 kí tự và một kí tự đặc biệt");
                    check = false;
                } else {
                    user.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
                    req.getSession().setAttribute("success", "Thành công cập nhật password.");
                    hasChanges = true;
                }
            }

            if (!user.getPhone().equals(phone)) {
                if (new UserDao().findByPhone(phone) != null) {
                    req.getSession().setAttribute("warning", "Số điện thoại đang được sử dụng.");
                    check = false;
                }else if(Util.isPhoneValid(user.getPhone())){
                    req.getSession().setAttribute("warning", "Số điện thoại không hợp lệ.");
                    check = false;
                } else {
                    user.setPhone(phone);
                    hasChanges = true;
                    req.getSession().setAttribute("success", "Thành công cập nhật số điện thoại.");
                }
            }

            if (check) {
                if (hasChanges) {
                    new UserDao().update(user);
                    req.getSession().setAttribute("user", user);
                    req.getSession().setAttribute("success", "Cập nhật thành công.");
                    resp.sendRedirect(req.getContextPath() + "/user/profile");
                } else {
                    req.getSession().setAttribute("warning", "Không có thông tin nào được thay đổi.");
                    resp.sendRedirect(req.getContextPath() + "/user/profile");
                }
            }else{
                resp.sendRedirect(req.getContextPath() + "/user/profile");
            }
        }
    }

    @WebServlet("/admin/create-user")
    public static class AdminCreatUser extends HttpServlet {
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String username = req.getParameter("username");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String password = req.getParameter("password");
            boolean verified = Boolean.parseBoolean(req.getParameter("verified"));
            boolean blocked = Boolean.parseBoolean(req.getParameter("blocked"));
            Rank rank = Rank.valueOf(req.getParameter("rank"));
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
                User user = new User(email, username, password, "uploads/default-avatar.png", phone, verified, blocked, role, rank);
                new UserDao().save(user);
                req.getSession().setAttribute("success", "Tạo tài khoản thành công.");
                resp.sendRedirect(req.getContextPath() + "/admin/users");
            }
        }
    }

    @WebServlet("/user/avatar")
    @MultipartConfig
    public static class UserAvatar extends HttpServlet {
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
            try {
                String filename = UploadImage.saveImage(req, "avatar");
                User user = (User) req.getSession().getAttribute("user");
                user.setAvatar(filename);
                new UserDao().update(user);
                req.getSession().setAttribute("user", user);
            } catch (ServletException e){
                e.printStackTrace();
                req.getSession().setAttribute("warning", "File tải lên phải là 1 ảnh");
            }
            resp.sendRedirect(req.getHeader("referer"));
        }
    }

    @WebServlet("/forgot-password")
    public static class ForgotPassword extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("/views/public/forgot-password.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String email = req.getParameter("email");
            User user = new UserDao().findByEmail(email);
            if (user != null) {
                String uuid = UUID.randomUUID().toString();
                user.setToken(uuid);
                new UserDao().update(user);
                // send mail
                ExecutorService executorService = Executors.newSingleThreadExecutor();
                executorService.submit(() -> {
                    try {
                        String url = Config.app_url + req.getContextPath() + "/reset-password?token=" + uuid;
                        String html = "Vui lòng nhấn vào <a href='url'>đây</a> để lấy lại mật khẩu của bạn.".replace("url", url);
                        Mail.send(email, "Lấy lại mật khẩu", html);
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                });
                executorService.shutdown();
                // end send mail
            }
            req.getSession().setAttribute("success", "Vui lòng kiểm tra email");
            resp.sendRedirect(req.getHeader("referer"));
        }
    }

    @WebServlet("/reset-password")
    public static class ResetPassword extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("/views/public/reset-password.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String token = req.getParameter("token");
            User user = new UserDao().findByToken(token);
            if (user != null) {
                String password = req.getParameter("password");
                String re_password = req.getParameter("re_password");
                if (password.equals(re_password) && !password.isEmpty()) {
                    user.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
                    new UserDao().update(user);
                    req.getSession().setAttribute("success", "Đặt lại mật khẩu thành công.");
                    resp.sendRedirect(req.getContextPath() + "/login");
                } else {
                    req.getSession().setAttribute("warning", "Mật khẩu không khớp.");
                    resp.sendRedirect(req.getHeader("referer"));
                }
            } else {
                req.getSession().setAttribute("warning", "Token không tồn tại.");
                resp.sendRedirect(req.getHeader("referer"));
            }
        }
    }
}
