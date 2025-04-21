<%@ page import="java.util.List" %>
<%@ page import="Model.Venue" %>
<%@ page import="Dao.VenueDao" %>
<%@ page import="Model.User" %>
<%@ page import="Model.Constant.Role" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Venue> venues = new VenueDao().getAll();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@include file="../include/head.jsp" %>
    <title>Trang chủ</title>
</head>
<body>
<!-- ======= Header ======= -->
<%@include file="../include/header.jsp" %>
<!-- ======= Sidebar ======= -->
<%@include file="../include/sidebar.jsp" %>

<main id="main" class="main">

    <!-- ======= Role Checking ======= -->
    <%
        User currentUser = (User) session.getAttribute("user");
        boolean isAdminOrOwner = false;
        boolean showHomeSection = true;

        if (currentUser != null && currentUser.getRole() != null) {
            Role role = currentUser.getRole();
            if (role == Role.ADMIN || role == Role.COURT_OWNER) {
                isAdminOrOwner = true;
                showHomeSection = false;
            }
        }
    %>

    <% if (isAdminOrOwner) { %>
    <!-- ======= Dashboard Title ======= -->
    <div class="pagetitle">
        <h1>Dashboard</h1>
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="<%=request.getContextPath()%>/">Home</a>
                </li>
                <li class="breadcrumb-item active">Trang chủ</li>
            </ol>
        </nav>
    </div>
    <% } %>

    <% if (showHomeSection) { %>
    <!-- ======= Welcome Section (Trang chủ) ======= -->
    <section style="background-color: #eef7ff; padding: 40px 0; margin-bottom: 40px; border-radius: 12px;">
        <div style="text-align: center;">
            <h2 style="font-size: 32px; font-weight: bold; margin-bottom: 10px;">
                Chào mừng bạn đến với Website Đặt Sân Cầu Lông!
            </h2>
            <p style="font-size: 18px; color: #555;">
                Hệ thống giúp bạn tìm kiếm và đặt sân nhanh chóng, tiện lợi và chính xác.
            </p>
        </div>
    </section>
    <% } %>

    <!-- ======= Venue List Section ======= -->
    <section class="section dashboard">
        <div class="row">
            <h2 style="text-align: center; font-size: 28px; font-weight: bold; color: #2c3e50; margin-bottom: 30px; border-bottom: 2px solid #007bff; display: inline-block; padding-bottom: 6px;">
                Danh Sách Cơ Sở Cầu Lông
            </h2>

            <% for (int i = 0; i < venues.size(); i++) { %>
            <% if (!venues.get(i).isDeleted()) { %>
            <div class="col-4" style="padding: 15px;">
                <div class="card h-100" style="border-radius: 15px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); transition: 0.3s;">
                    <img
                            src="<%= venues.get(i).getImage() %>"
                            class="card-img-top"
                            alt="Hình ảnh sân"
                            style="width: 100%; height: 200px; object-fit: cover; border-top-left-radius: 15px; border-top-right-radius: 15px;"
                    />
                    <div class="card-body">
                        <h5 class="card-title" style="font-weight: bold;"><%= venues.get(i).getName() %></h5>
                        <p class="card-text"><strong>Địa chỉ:</strong> <%= venues.get(i).getAddress() %></p>
                        <p class="card-text"><strong>Giờ mở cửa:</strong> <%= venues.get(i).getOpenTime() %> - <%= venues.get(i).getCloseTime() %></p>
                        <p class="card-text"><strong>Chủ sân:</strong> <%= venues.get(i).getOwner().getUsername() %></p>
                        <a
                                href="<%=request.getContextPath()%>/venue-detail?id=<%= venues.get(i).getId() %>&from=&to="
                                class="btn btn-primary"
                                style="width: 100%; border-radius: 10px;"
                        >
                            Xem chi tiết
                        </a>
                    </div>
                </div>
            </div>
            <% } %>
            <% } %>
        </div>
    </section>

    <!-- ======= Contact Section ======= -->
    <section style="margin-top: 60px; padding: 40px; background-color: #f8f9fa; border-radius: 12px;">
        <h3 style="text-align: center; margin-bottom: 20px;">Liên hệ với chúng tôi</h3>
        <p style="text-align: center; font-size: 16px; color: #555;">
            📧 Email: support@badminweb.vn | ☎️ Hotline: 1900 1234 <br/>
            Địa chỉ: 123 Nguyễn Văn Linh, Đà Nẵng
        </p>
    </section>

</main>

<!-- ======= Footer ======= -->
<%@include file="../include/footer.jsp" %>

<a href="#" class="back-to-top d-flex align-items-center justify-content-center">
    <i class="bi bi-arrow-up-short"></i>
</a>

<%@include file="../include/js.jsp" %>
</body>
</html>
