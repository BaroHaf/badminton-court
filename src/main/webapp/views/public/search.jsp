<%@ page import="Model.Venue" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
            <form action="<%=request.getContextPath()%>/search" method="get" class="container my-4">
                <form action="<%=request.getContextPath()%>/search" method="get" class="container my-4">
                    <div class="row g-3">
                        <!-- Tên hoặc địa chỉ -->
                        <div class="col-md-6">
                            <label for="searchQuery" class="form-label">Tìm theo tên hoặc địa chỉ</label>
                            <input type="text" id="searchQuery" name="searchQuery" class="form-control" />
                        </div>

                        <!-- Giá từ -->
                        <div class="col-md-3">
                            <label for="priceFrom" class="form-label">Giá từ (VNĐ/h)</label>
                            <input type="number" step="0.01" id="priceFrom" name="priceFrom" class="form-control" />
                        </div>

                        <!-- Giá đến -->
                        <div class="col-md-3">
                            <label for="priceTo" class="form-label">Giá đến (VNĐ/h)</label>
                            <input type="number" step="0.01" id="priceTo" name="priceTo" class="form-control" />
                        </div>
                    </div>

                    <div class="row g-3 mt-1">
                        <!-- Giờ mở cửa -->
                        <div class="col-md-3">
                            <label for="openTime" class="form-label">Giờ mở cửa sớm nhất</label>
                            <input type="time" id="openTime" name="openTime" class="form-control" />
                        </div>

                        <!-- Giờ đóng cửa -->
                        <div class="col-md-3">
                            <label for="closeTime" class="form-label">Giờ đóng cửa muộn nhất</label>
                            <input type="time" id="closeTime" name="closeTime" class="form-control" />
                        </div>

                        <!-- Nút tìm kiếm -->
                        <div class="col-md-6 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary w-100">Tìm kiếm</button>
                        </div>
                    </div>
                </form>
            </form>

        </div>
        <div class="row">
            <% List<Venue> venues = (List<Venue>) request.getAttribute("venues");%>
            <h2 class="text-center mb-4">Kết quả tìm kiếm</h2>
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