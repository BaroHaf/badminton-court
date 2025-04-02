<%@ page import="Model.Venue" %>
<%@ page import="Model.Review" %>
<%@ page import="Dao.ReviewDao" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% Venue venue = (Venue) request.getAttribute("venue");%>
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
                <li class="breadcrumb-item active">Chi tiết sân</li>
            </ol>
        </nav>
    </div>
    <!-- End Page Title -->

    <section class="section dashboard">
        <div class="row">
            <div class="col-md-6">
                <img src="<%= venue.getImage() %>" class="img-fluid rounded" alt="Hình ảnh sân"
                     onerror="this.onerror=null;this.src='default.jpg';">
            </div>
            <div class="col-md-6">
                <h2><%= venue.getName() %></h2>
                <p><strong>Địa chỉ:</strong> <%= venue.getAddress() %></p>
                <p><strong>Giờ mở cửa:</strong> <%= venue.getOpenTime() %> - <%= venue.getCloseTime() %></p>
                <p><strong>Chủ sở hữu:</strong> <%= venue.getOwner().getUsername() %></p>
                <p><strong>Số lượng sân:</strong> <%= venue.getCourts().size()%></p>
                <form action="<%=request.getContextPath()%>/customer/book" method="post">
                    <div class="col-12">
                        <label for="court_id" class="form-label">Chọn sân</label>
                        <div class="input-group has-validation">
                            <select class="form-control" name="court_id" id="court_id">
                                <% for (int i = 0; i < venue.getCourts().size(); i++) { %>
                                    <% if (venue.getCourts().get(i).isAvailable()){%>
                                        <option selected value="<%=venue.getCourts().get(i).getId()%>">Sân số <%=venue.getCourts().get(i).getName()%></option>
                                    <%}%>
                                <% } %>
                            </select>
                        </div>

                        <div class="col-12">
                            <label for="start_time" class="form-label">Bắt đầu thuê lúc</label>
                            <div class="input-group has-validation">
                                <input onchange="$('#end_time').val(this.value)" type="datetime-local" name="start_time" class="form-control" id="start_time" required>
                            </div>
                        </div>

                        <div class="col-12">
                            <label for="end_time" class="form-label">Kết thúc thuê lúc</label>
                            <div class="input-group has-validation">
                                <input type="datetime-local" name="end_time" class="form-control" id="end_time" required>
                            </div>
                        </div>

                        <div class="col-12">
                            <button type="submit" class="btn btn-success w-100 m-1">
                                Đặt sân ngay
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        <div class="row">
            <%
                List<Review> reviews = new ReviewDao().getReviewsByVenueId(venue.getId());
                if (reviews.isEmpty()) {
            %>
            <div class="col-12 text-center">
                <p class="text-muted">Chưa có đánh giá nào.</p>
            </div>
            <% } else {
                for (Review review : reviews) {
            %>
            <div class="col-md-6 col-lg-4 mb-3">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <h5 class="card-title">
                            Đánh giá:
                            <span class="text-warning">
                            <% for (int i = 0; i < review.getRate(); i++) { %>
                                ★
                            <% } %>
                            <% for (int i = review.getRate(); i < 5; i++) { %>
                                ☆
                            <% } %>
                        </span>
                        </h5>
                        <h6 class="text-primary"><i class="bi bi-person"></i> <%= review.getBooking().getUser().getUsername() %></h6>
                        <p class="card-text"><%= review.getComment() %></p>
                        <p class="text-muted small">
                            <i class="bi bi-calendar"></i> Ngày đặt: <%= review.getBooking().getStartTime().toLocalDate() %>
                        </p>
                    </div>
                </div>
            </div>
            <% } } %>
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