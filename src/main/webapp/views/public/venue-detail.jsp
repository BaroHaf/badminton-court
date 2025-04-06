<%@ page import="Model.Venue" %>
<%@ page import="Model.Review" %>
<%@ page import="Dao.ReviewDao" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.DayOfWeek" %>
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
                <h2><%= venue.getName() %>
                </h2>
                <p><strong>Địa chỉ:</strong> <%= venue.getAddress() %>
                </p>
                <p><strong>Giờ mở cửa:</strong> <%= venue.getOpenTime() %> - <%= venue.getCloseTime() %>
                </p>
                <p><strong>Chủ sở hữu:</strong> <%= venue.getOwner().getUsername() %>
                </p>
                <p><strong>Số lượng sân:</strong> <%= venue.getCourts().size()%>
                </p>
                <form action="<%=request.getContextPath()%>/customer/book" method="post">
                    <div class="col-12">
                        <label for="court_id" class="form-label">Chọn sân</label>
                        <div class="input-group has-validation">
                            <select class="form-control" name="court_id" id="court_id">
                                <% for (int i = 0; i < venue.getCourts().size(); i++) { %>
                                <% if (venue.getCourts().get(i).isAvailable()) {%>
                                <option selected value="<%=venue.getCourts().get(i).getId()%>">Sân
                                    số <%=venue.getCourts().get(i).getName()%>
                                </option>
                                <%}%>
                                <% } %>
                            </select>
                        </div>

                        <div class="col-12">
                            <label for="start_time" class="form-label">Bắt đầu thuê lúc</label>
                            <div class="input-group has-validation">
                                <input onchange="$('#end_time').val(this.value)" type="datetime-local" name="start_time"
                                       class="form-control" id="start_time" required>
                            </div>
                        </div>

                        <div class="col-12">
                            <label for="end_time" class="form-label">Kết thúc thuê lúc</label>
                            <div class="input-group has-validation">
                                <input type="datetime-local" name="end_time" class="form-control" id="end_time"
                                       required>
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
        <div class="mb-3">
            <button id="toggleReviews" class="btn btn-outline-primary me-2">Đánh giá</button>
            <button id="toggleBookings" class="btn btn-outline-secondary">Lịch đặt</button>
        </div>

        <div class="row" id="reviewSection">
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
                        <h6 class="text-primary"><i
                                class="bi bi-person"></i> <%= review.getBooking().getUser().getUsername() %>
                        </h6>
                        <p class="card-text"><%= review.getComment() %>
                        </p>
                        <p class="text-muted small">
                            <i class="bi bi-calendar"></i> Ngày
                            đặt: <%= review.getBooking().getStartTime().toLocalDate() %>
                        </p>
                    </div>
                </div>
            </div>
            <% }
            } %>
        </div>
        <div class="row" id="bookingSection">
            <h3>các lịch đã đặt</h3>
            <form action="<%=request.getContextPath()%>/venue-detail" method="get">
                <input type="hidden" name="id" value="<%=request.getParameter("id")%>">
                <input type="date" name="from" class="form-control w-25" id="from" value="<%=request.getParameter("from").isEmpty() ? LocalDate.now().with(DayOfWeek.MONDAY) : request.getParameter("from") %>">
                <input type="date" name="to" class="form-control w-25" id="to" value="<%=request.getParameter("to").isEmpty() ? LocalDate.now().with(DayOfWeek.SUNDAY) : request.getParameter("to") %>">
                <button type="submit" class="btn btn-success">Xem các lịch đã đặt</button>
            </form>
            <% List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");%>
            <% for (int i = 0; i < bookings.size(); i++) { %>
                <p>Sân <%=bookings.get(i).getCourt().getName()%>, từ <%=bookings.get(i).getStartTime()%> đến <%=bookings.get(i).getEndTime()%></p>
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
<script>
    const btnReviews = document.getElementById("toggleReviews");
    const btnBookings = document.getElementById("toggleBookings");
    const reviewSection = document.getElementById("reviewSection");
    const bookingSection = document.getElementById("bookingSection");

    function showReviews() {
        reviewSection.style.display = 'flex';
        bookingSection.style.display = 'none';
        btnReviews.classList.remove('btn-outline-primary');
        btnReviews.classList.add('btn-primary');
        btnBookings.classList.remove('btn-secondary');
        btnBookings.classList.add('btn-outline-secondary');
    }

    function showBookings() {
        reviewSection.style.display = 'none';
        bookingSection.style.display = 'block';
        btnBookings.classList.remove('btn-outline-secondary');
        btnBookings.classList.add('btn-secondary');
        btnReviews.classList.remove('btn-primary');
        btnReviews.classList.add('btn-outline-primary');
    }

    btnReviews.addEventListener('click', showReviews);
    btnBookings.addEventListener('click', showBookings);

    // Mặc định hiển thị đánh giá
    let check = <%=request.getParameter("from").isEmpty()%>
    if (check) {
        showReviews();
    } else {
        showBookings()
    }
</script>

</body>

</html>