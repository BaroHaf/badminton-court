<%@ page import="Model.User" %>
<%@ page import="Dao.BookingDao" %>
<%@ page import="Model.Booking" %>
<%@ page import="java.util.List" %>
<%@ page import="Util.Config" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% User user = (User) request.getSession().getAttribute("user");%>
<header id="header" class="header fixed-top d-flex align-items-center">

    <div class="d-flex align-items-center justify-content-between">
        <a href="<%=request.getContextPath()%>/" class="logo d-flex align-items-center">
            <img src="<%=request.getContextPath()%>/assets/img/apple-touch-icon.png" alt="">
            <span class="d-none d-lg-block"><%=Config.app_name%></span>
        </a>
        <i class="bi bi-list toggle-sidebar-btn"></i>
    </div><!-- End Logo -->

    <div class="search-bar">
        <form class="search-form d-flex align-items-center" method="get" action="<%=request.getContextPath()%>/search">
            <input type="text" name="searchQuery" placeholder="Search" title="Enter search keyword">
            <button type="submit" title="Search"><i class="bi bi-search"></i></button>
        </form>
    </div><!-- End Search Bar -->

    <nav class="header-nav ms-auto">
        <ul class="d-flex align-items-center">

            <li class="nav-item d-block d-lg-none">
                <a class="nav-link nav-icon search-bar-toggle " href="#">
                    <i class="bi bi-search"></i>
                </a>
            </li><!-- End Search Icon-->
            <% if (user == null) {%>

                <!-- End Notification Nav -->
                <li class="nav-item dropdown pe-3" style="width: 400px;">
                    <div class="row">
                        <a class="col-6" href="<%=request.getContextPath()%>/login">
                            <button style="width: 100%" class="btn btn-outline-success">Đăng nhập</button>
                        </a>
                        <a class="col-6" href="<%=request.getContextPath()%>/register">
                            <button style="width: 100%" class="btn btn-outline-success">Đăng kí</button>
                        </a>
                    </div>
                </li>
            <% } else {%>
                <img src="<%=request.getContextPath()%>/<%=user.getAvatar()%>" style="width: 40px;height: 40px;object-fit: cover" alt="Profile" class="rounded-circle">
                <span class="d-none d-md-block ps-2" style="margin-right: 10px"><%=user.getUsername()%> <%= user.getRole() == Role.CUSTOMER ? "(" + user.getRank() + ")" : "" %></span>
                <a href="<%=request.getContextPath()%>/logout" style="margin-right: 10px">
                    <button style="width: 100%; " class="btn btn-outline-success">Đăng xuất</button>
                </a>
            <% } %>
            <!-- End Profile Nav -->

        </ul>
    </nav><!-- End Icons Navigation -->

</header>