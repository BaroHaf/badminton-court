package Filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class LoginFilter implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        if (request.getSession().getAttribute("user") == null) {
            request.getSession().setAttribute("warning", "Vui lòng đăng nhập.");
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            filterChain.doFilter(request, response);
        }
    }
}
