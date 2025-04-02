<%@ page import="Model.Constant.Role" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% User side_bar_user = (User) request.getSession().getAttribute("user");%>
<aside id="sidebar" class="sidebar">

    <ul class="sidebar-nav" id="sidebar-nav">
        <li class="nav-item">
            <a class="nav-link" href="<%=request.getContextPath()%>/">
                <i class="bi bi-grid"></i>
                <span>Trang chủ</span>
            </a>
        </li>
        <% if (side_bar_user != null) {%>
            <li class="nav-item">
                <a class="nav-link " href="<%=request.getContextPath()%>/user/profile">
                    <i class="bi bi-grid"></i>
                    <span>Trang cá nhân</span>
                </a>
            </li>
            <% if (side_bar_user.getRole() == Role.ADMIN) {%>
                <li class="nav-heading">Quản trị viên</li>
                <li class="nav-item">
                    <a class="nav-link " href="<%=request.getContextPath()%>/admin/users">
                        <i class="bi bi-grid"></i>
                        <span>Quản lý người dùng</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link " href="<%=request.getContextPath()%>/admin/voucher">
                        <i class="bi bi-grid"></i>
                        <span>Quản lý voucher</span>
                    </a>
                </li>
            <% } else if (side_bar_user.getRole() == Role.CUSTOMER) { %>
                <li class="nav-heading">Khách hàng</li>
                <li class="nav-item">
                    <a class="nav-link " href="<%=request.getContextPath()%>/customer/bookings">
                        <i class="bi bi-grid"></i>
                        <span>Danh sách bookings</span>
                    </a>
                </li>
            <% } else { %>
                <li class="nav-heading">Chủ sân</li>
                <li class="nav-item">
                    <a class="nav-link " href="<%=request.getContextPath()%>/court-owner">
                        <i class="bi bi-grid"></i>
                        <span>Quản lý sân cầu</span>
                    </a>
                </li>
            <% } %>
        <% } %>
    </ul>
</aside>
