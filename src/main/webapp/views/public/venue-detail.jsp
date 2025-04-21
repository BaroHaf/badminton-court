<%@ page import="Model.Venue" %>
<%@ page import="Model.Review" %>
<%@ page import="Dao.ReviewDao" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.DayOfWeek" %>
<%@ page import="java.util.Map" %>
<%@ page import="Util.Util" %>
<%@ page import="Model.Booking" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% Venue venue = (Venue) request.getAttribute("venue"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="../include/head.jsp" %>
    <title>Chi tiết sân</title>
</head>
<body>
<!-- ======= Header ======= -->
<%@ include file="../include/header.jsp" %>
<!-- End Header -->

<!-- ======= Sidebar ======= -->
<%@ include file="../include/sidebar.jsp" %>
<!-- End Sidebar -->

<main id="main" class="main">
    <section class="section dashboard">
        <div class="row">
            <!-- Hình ảnh sân -->
            <div class="col-md-6">
                <img src="<%= venue.getImage() %>" class="img-fluid rounded" alt="Hình ảnh sân"
                     onerror="this.onerror=null; this.src='default.jpg';">
            </div>

            <!-- Thông tin sân và form đặt sân -->
            <div class="col-md-6">
                <h2><%= venue.getName() %></h2>
                <p><strong>Địa chỉ:</strong> <%= venue.getAddress() %></p>
                <p><strong>Giờ mở cửa:</strong> <%= venue.getOpenTime() %> - <%= venue.getCloseTime() %></p>
                <p><strong>Chủ sở hữu:</strong> <%= venue.getOwner().getUsername() %></p>
                <p><strong>Số lượng sân:</strong> <%= venue.getCourts().size() %></p>
                <p id="selected_court" class="mt-2 fw-bold">Sân đã chọn: </p>
                <p id="court_available" class="fw-bold">Có sẵn: </p>

                <form action="<%= request.getContextPath() %>/customer/book" method="post">
                    <!-- Chọn sân -->
                    <div class="col-12">
                        <label for="court_id" class="form-label">Chọn sân</label>
                        <div class="input-group has-validation">
                            <select onchange="test(this)" class="form-control" name="court_id" id="court_id">
                                <option selected disabled>Vui lòng chọn sân</option>
                                <% for (int i = 0; i < venue.getCourts().size(); i++) { %>
                                <% if (!venue.isDeleted()) { %>
                                <option isavailable="<%= venue.getCourts().get(i).isAvailable() %>"
                                        data-price="<%= venue.getCourts().get(i).getPricePerHour() %>"
                                        value="<%= venue.getCourts().get(i).getId() %>">
                                    Sân số <%= venue.getCourts().get(i).getName() %>
                                </option>
                                <% } %>
                                <% } %>
                            </select>
                        </div>
                    </div>

                    <!-- Giá và tạm tính -->
                    <div class="col-12 row">
                        <div class="col-6">
                            <label for="court_price">Giá 1 giờ</label>
                            <input class="form-control" type="text" name="court_price" id="court_price" disabled>
                        </div>
                        <div class="col-6">
                            <label for="temp_price">Tạm tính</label>
                            <input class="form-control" type="text" name="temp_price" id="temp_price" disabled>
                        </div>
                    </div>

                    <!-- Thời gian bắt đầu -->
                    <div class="col-12">
                        <label for="start_time" class="form-label">Bắt đầu thuê lúc</label>
                        <div class="input-group has-validation">
                            <input onchange="$('#end_time').val(this.value); chooseStartTime(this)"
                                   type="datetime-local" name="start_time" class="form-control" id="start_time"
                                   required>
                        </div>
                    </div>

                    <!-- Thời gian kết thúc -->
                    <div class="col-12">
                        <label for="end_time" class="form-label">Kết thúc thuê lúc</label>
                        <div class="input-group has-validation">
                            <input onchange="chooseEndTime(this)" type="datetime-local" name="end_time"
                                   class="form-control" id="end_time" required>
                        </div>
                    </div>

                    <!-- Mã giảm giá -->
                    <div class="col-12">
                        <label for="voucherCode" class="form-label">Mã giảm giá (nếu có)</label>
                        <div class="input-group has-validation">
                            <input type="text" name="voucherCode" class="form-control" id="voucherCode">
                        </div>
                    </div>

                    <!-- Nút đặt sân -->
                    <div class="col-12">
                        <button disabled id="submit_button" type="submit" class="btn btn-success w-100 m-1">
                            Đặt sân ngay
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Nút chuyển đổi Đánh giá và Lịch đặt -->
        <div class="mb-3">
            <button id="toggleReviews" class="btn btn-outline-primary me-2">Đánh giá</button>
            <button id="toggleBookings" class="btn btn-outline-secondary">Lịch đặt</button>
        </div>

        <!-- Phần hiển thị đánh giá -->
        <div class="row" id="reviewSection">
            <% List<Review> reviews = new ReviewDao().getReviewsByVenueId(venue.getId()); %>
            <% if (reviews.isEmpty()) { %>
            <div class="col-12 text-center">
                <p class="text-muted">Chưa có đánh giá nào.</p>
            </div>
            <% } else { %>
            <% for (Review review : reviews) { %>
            <div class="col-md-6 col-lg-4 mb-3">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <h5 class="card-title">
                            Đánh giá:
                            <span class="text-warning">
                                            <% for (int i = 0; i < review.getRate(); i++) { %>★<% } %>
                                            <% for (int i = review.getRate(); i < 5; i++) { %>☆<% } %>
                                        </span>
                        </h5>
                        <h6 class="text-primary">
                            <i class="bi bi-person"></i> <%= review.getBooking().getUser().getUsername() %>
                        </h6>
                        <p class="card-text"><%= review.getComment() %></p>
                        <p class="text-muted small">
                            <i class="bi bi-calendar"></i> Ngày đặt: <%= review.getBooking().getStartTime().toLocalDate() %>
                        </p>
                    </div>
                </div>
            </div>
            <% } %>
            <% } %>
        </div>

        <!-- Phần hiển thị lịch đặt -->
        <div class="row" id="bookingSection">
            <h3>Các lịch đã đặt</h3>
            <form action="<%= request.getContextPath() %>/venue-detail" method="get">
                <input type="hidden" name="id" value="<%= request.getParameter("id") %>">
                <input type="date" name="from" class="form-control w-25" id="from"
                       value="<%= request.getParameter("from") == null || request.getParameter("from").isEmpty() ?
                                      LocalDate.now().with(DayOfWeek.MONDAY).toString() :
                                      request.getParameter("from") %>">
                <input type="date" name="to" class="form-control w-25" id="to"
                       value="<%= request.getParameter("to") == null || request.getParameter("to").isEmpty() ?
                                      LocalDate.now().with(DayOfWeek.SUNDAY).toString() :
                                      request.getParameter("to") %>">
                <button type="submit" class="btn btn-success">Xem các lịch đã đặt</button>
            </form>

            <% List<Booking> bookings = (List<Booking>) request.getAttribute("bookings"); %>
            <% if (bookings != null && !bookings.isEmpty()) { %>
            <% for (Booking booking : bookings) { %>
            <p>
                Sân <%= booking.getCourt().getName() %>,
                từ <%= Util.formatLocalDateTime(booking.getStartTime()) %>
                đến <%= Util.formatLocalDateTime(booking.getEndTime()) %>
            </p>
            <% } %>
            <% } else { %>
            <p class="text-muted">Chưa có lịch đặt nào.</p>
            <% } %>
        </div>
    </section>
</main>
<!-- End #main -->

<!-- ======= Footer ======= -->
<%@ include file="../include/footer.jsp" %>
<!-- End Footer -->

<a href="#" class="back-to-top d-flex align-items-center justify-content-center">
    <i class="bi bi-arrow-up-short"></i>
</a>

<%@ include file="../include/js.jsp" %>
<script>
    // Logic chuyển đổi giữa Đánh giá và Lịch đặt
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

    // Mặc định hiển thị đánh giá nếu không có tham số from
    let check = <%= request.getParameter("from") == null || request.getParameter("from").isEmpty() ? "true" : "false" %>;
    if (check) {
        showReviews();
    } else {
        showBookings();
    }



    // Logic xử lý form đặt sân
    let court_id = 0;
    let court_price = 0;
    let startTime = null;
    let courtName = "";
    let endTime = null;
    let court_available = "";

    function test(selector) {
        court_id = parseInt(selector.value);
        const selectedOption = selector.options[selector.selectedIndex];
        courtName = selectedOption.textContent;
        court_price = parseInt(selectedOption.getAttribute('data-price'));
        court_available = selectedOption.getAttribute("isavailable");
        changeForm();
    }

    function changeForm() {
        if (court_id !== 0 && court_price !== 0) {
            const formattedPrice = court_price.toLocaleString('vi-VN') + ' VND';
            document.getElementById("court_available").textContent = "Có sẵn: " + (court_available ? "Có" : "Không");
            $("#court_price").val(formattedPrice);
            document.getElementById("selected_court").textContent = "Sân đã chọn: " + courtName;
        }
    }

    function isStep30Minutes(start, end) {
        const startDate = new Date(start);
        const endDate = new Date(end);
        const diffInMs = endDate - startDate;
        const diffInMinutes = diffInMs / (1000 * 60);
        return diffInMinutes % 30 === 0;
    }

    function getDecimalHours(start, end) {
        const startDate = new Date(start);
        const endDate = new Date(end);
        const diffInMs = endDate - startDate;
        return diffInMs / (1000 * 60 * 60);
    }

    function isStartBeforeEnd(start, end) {
        return new Date(start) < new Date(end);
    }

    function chooseStartTime(input) {
        startTime = new Date(input.value);
        if (endTime != null){
            if (!isStartBeforeEnd(startTime, endTime)) {
                toastr.warning("Giờ bắt đầu phải trước giờ kết thúc")
                $("#submit_button").prop('disabled', true);
            } else if (!isStep30Minutes(startTime, endTime)){
                toastr.warning("Khoảng cách giữa giờ bắt đầu và kết thúc cách nhau bội số 30p")
                $("#submit_button").prop('disabled', true);
            } else {
                getTempPrice();
                $("#submit_button").removeAttr('disabled');
            }
        }
    }
    function chooseEndTime(input) {
        endTime = new Date(input.value);
        if (!isStartBeforeEnd(startTime, endTime)) {
            toastr.warning("Giờ bắt đầu phải trước giờ kết thúc")
            $("#submit_button").prop('disabled', true);
        } else if (!isStep30Minutes(startTime, endTime)){
            toastr.warning("Khoảng cách giữa giờ bắt đầu và kết thúc cách nhau bội số 30p")
            $("#submit_button").prop('disabled', true);
        } else {
            getTempPrice();
            $("#submit_button").removeAttr('disabled');
        }
    }
    function debounce(callback, delay) {
        let timeoutId;
        return function(...args) {
            clearTimeout(timeoutId);
            timeoutId = setTimeout(() => {
                callback.apply(this, args);
            }, delay);
        };
    }

    //logic xử lí voucher
    async function getTempPrice() {
        const url = "<%=Config.app_url + request.getContextPath()%>/api/calculate-price-with-voucher?courtId="
            + court_id + "&hours=" + getDecimalHours(startTime, endTime) + "&voucherCode=" + $("#voucherCode").val();

        try {
            const response = await fetch(url);
            if (!response.ok) throw new Error("Không thể lấy dữ liệu từ API");

            const rawData = await response.json();
            const formattedPrice = Number(rawData).toLocaleString("vi-VN") + " VND";
            $("#temp_price").val(formattedPrice);
        } catch (error) {
            console.warn("Lỗi khi tính giá tạm tính:", error);
            toastr.warning("Voucher không tồn tại.")
        }

        console.log("fetch url: ", url);
    }

    const debouncedGetTempPrice = debounce(getTempPrice, 500);
    document.getElementById("voucherCode").addEventListener("input", debouncedGetTempPrice);

</script>
</body>
</html>