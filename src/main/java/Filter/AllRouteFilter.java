package Filter;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebFilter("/*")
public class AllRouteFilter implements Filter{
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        if (request.getSession().getAttribute("success") != null){
            String success = (String) request.getSession().getAttribute("success");
            request.setAttribute("success", success);
            request.getSession().removeAttribute("success");
        }
        if (request.getSession().getAttribute("warning") != null){
            String warning = (String) request.getSession().getAttribute("warning");
            request.setAttribute("warning", warning);
            request.getSession().removeAttribute("warning");
        }
        filterChain.doFilter(request, response);
    }
}
