<%@ page import="java.util.List" %>
<%@ page import="Model.Venue" %>
<%@ page import="Dao.VenueDao" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% List<Venue> venues = new VenueDao().getAll(); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <%@include file="../include/head.jsp" %>
    <title>Trang chủ</title>
</head>

<body>

<!-- ======= Header ======= -->
<%@include file="../include/header.jsp" %>
<!-- End Header -->

<!-- ======= Sidebar ======= -->
<%@include file="../include/sidebar.jsp" %>
<!-- End Sidebar-->

<main id="main" class="main">

    <!-- ======= Title ======= -->
    <div class="pagetitle">
        <h1>Dashboard</h1>
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/">Home</a></li>
                <li class="breadcrumb-item active">Trang chủ</li>
            </ol>
        </nav>
    </div>
    <!-- End Page Title -->

    <section class="section dashboard">
        <div class="row">

            <h2 class="text-center mb-4">Danh Sách Cơ Sở Cầu Lông</h2>
            <% for (int i = 0; i < venues.size(); i++) { %>
            <div class="col-4">
                <div class="card h-100">
                    <img src="<%=venues.get(i).getImage() %>" class="card-img-top" alt="Hình ảnh sân" style="width: 100%; height: 200px; object-fit: cover;">
                    <div class="card-body">
                        <h5 class="card-title"><%= venues.get(i).getName() %>
                        </h5>
                        <p class="card-text"><strong>Địa chỉ:</strong> <%= venues.get(i).getAddress() %>
                        </p>
                        <p class="card-text">
                            <strong>Giờ mở cửa:</strong> <%= venues.get(i).getOpenTime() %> - <%= venues.get(i).getCloseTime() %>
                        </p>
                        <p class="card-text">
                            <strong>Chủ sân:</strong> <%=venues.get(i).getOwner().getUsername()%>
                        </p>
                        <a href="<%=request.getContextPath()%>/venue-detail?id=<%= venues.get(i).getId() %>&from=&to=" class="btn btn-primary">Xem chi tiết</a>
                    </div>
                </div>
            </div>
            <% } %>

        </div>
    </section>

</main>
<!-- End #main -->

<!-- ======= Footer ======= -->
<%@include file="../include/footer.jsp" %>
<!-- End Footer -->

<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i
        class="bi bi-arrow-up-short"></i></a>

<%@include file="../include/js.jsp" %>

</body>

</html>