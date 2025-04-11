<%@ page import="java.util.List" %>
<%@ page import="Model.Constant.BookingStatus" %>
<%@ page import="Util.Util" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <%@include file="../include/head.jsp" %>
    <style>
        .rating {
            font-size: 2rem;
            cursor: pointer;
        }
        .star {
            color: gray;
        }
        .star.active {
            color: gold;
        }
    </style>
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
            <% List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");%>
            <div class="card-body">
                <h5 class="card-title">Danh sách booking của bạn</h5>
                <!-- Pills Tabs -->
                <ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">

                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="pills-profile-tab" data-bs-toggle="pill"
                                data-bs-target="#pills-profile" type="button" role="tab" aria-controls="pills-profile"
                                aria-selected="true" tabindex="-1">Đã thanh toán
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="pills-contact-tab" data-bs-toggle="pill"
                                data-bs-target="#pills-contact" type="button" role="tab" aria-controls="pills-contact"
                                aria-selected="false" tabindex="-1">Đã hủy
                        </button>
                    </li>
                </ul>
                <div class="tab-content pt-2" id="myTabContent">
                    <div class="tab-pane fade show active" id="pills-profile" role="tabpanel" aria-labelledby="profile-tab">
                        <table class="table table-striped table-bordered">
                        <thead class="table-dark">
                        <tr>
                            <th>#</th>
                            <th>Sân</th>
                            <th>Thời gian</th>
                            <th>Đánh giá</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% int index = 1; %>
                        <% for (Booking booking : bookings) { %>
                        <% if (booking.getStatus() == BookingStatus.CONFIRMED) { %>
                        <tr>
                            <td><%= index++ %>
                            </td>
                            <td><%= booking.getCourt().getName() %>, <%=booking.getCourt().getVenue().getName()%>
                            </td>
                            <td><%= Util.formatLocalDateTime(booking.getStartTime()) %> - <%= Util.formatLocalDateTime(booking.getEndTime()) %>
                                (<%=Util.calculateHourDifference(booking.getStartTime(), booking.getEndTime())%> giờ)
                            </td>
                            <td>
                                <% if (booking.getReview() == null){%>
                                    <button onclick="$('#booking_id').val(<%=booking.getId()%>)" class="btn btn-success w-100" data-bs-toggle="modal" data-bs-target="#addReviewModal">
                                        Viết đánh giá
                                    </button>
                                <% } else { %>
                                    <button class="btn btn-success w-100" disabled>
                                        Đã đánh giá
                                    </button>
                                <% } %>

                            </td>
                        </tr>
                        <% } %>
                        <% } %>
                        </tbody>
                        </table>
                    </div>
                    <div class="tab-pane fade" id="pills-contact" role="tabpanel" aria-labelledby="contact-tab">
                        <table class="table table-striped table-bordered">
                            <thead class="table-dark">
                            <tr>
                                <th>#</th>
                                <th>Sân</th>
                                <th>Thời gian</th>
                            </tr>
                            </thead>
                            <tbody>
                            <% index = 1; %>
                            <% for (Booking booking : bookings) { %>
                            <% if (booking.getStatus() != BookingStatus.CONFIRMED) { %>
                            <tr>
                                <td><%= index++ %>
                                </td>
                                <td><%= booking.getCourt().getName() %>, <%=booking.getCourt().getVenue().getName()%>
                                </td>
                                <td><%= Util.formatLocalDateTime(booking.getStartTime()) %> - <%= Util.formatLocalDateTime(booking.getEndTime()) %>
                                    (<%=Util.calculateHourDifference(booking.getStartTime(), booking.getEndTime())%> giờ)
                                </td>
                            </tr>
                            <% } %>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </div><!-- End Pills Tabs -->
            </div>
        </div>
    </section>
    <div class="modal fade" id="addReviewModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form action="<%=request.getContextPath()%>/customer/review" method="post">
                    <div class="modal-header">
                        <h5 class="modal-title">Viết đánh giá</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <input type="hidden" id="booking_id" name="booking_id">
                    <div class="modal-body">

                        <div class="col-12">
                            <label for="updateUsername" class="form-label">Bạn thấy sân cầu này thế nào?</label>
                            <div class="input-group has-validation">
                                <input type="text" name="comment" class="form-control" id="updateUsername" required>
                                <div class="invalid-feedback">Vui lòng viết đánh giá.</div>
                            </div>
                        </div>

                        <div id="ratingStars" class="rating">
                            <i class="bi bi-star" data-value="1"></i>
                            <i class="bi bi-star" data-value="2"></i>
                            <i class="bi bi-star" data-value="3"></i>
                            <i class="bi bi-star" data-value="4"></i>
                            <i class="bi bi-star" data-value="5"></i>
                        </div>
                        <input type="hidden" id="ratingValue" value="0" name="rate">
                        <script>
                            document.addEventListener("DOMContentLoaded", function () {
                                const stars = document.querySelectorAll("#ratingStars i");
                                const ratingInput = document.getElementById("ratingValue");

                                stars.forEach(star => {
                                    star.addEventListener("click", function () {
                                        let value = this.getAttribute("data-value");
                                        ratingInput.value = value;

                                        // Update star classes
                                        stars.forEach((s, index) => {
                                            if (index < value) {
                                                s.classList.replace("bi-star", "bi-star-fill");
                                                s.classList.add("active");
                                            } else {
                                                s.classList.replace("bi-star-fill", "bi-star");
                                                s.classList.remove("active");
                                            }
                                        });
                                    });
                                });
                            });
                        </script>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-primary">Đánh giá</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>
<!-- End #main -->

<!-- ======= Footer ======= -->
<%@include file="../include/footer.jsp" %>
<!-- End Footer -->

<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i
        class="bi bi-arrow-up-short"></i></a>

<%@include file="../include/js.jsp" %>

</body>
<script>
    let ids = [];
    let temp_amount = 0;

    function add2Form(id, amount) {
        ids.push(id);
        temp_amount += amount;
        $("#payment_btn").text("Thanh toán " + ids.length + " booking (" + temp_amount + " VND )")
        $('#ids').val(ids.join(','))
    }

    function removeFromForm(id, amount) {
        ids.splice(ids.indexOf(id), 1);
        temp_amount -= amount;
        if (ids.length === 0) {
            $("#payment_btn").text("Thanh toán")
        } else {
            $("#payment_btn").text("Thanh toán " + ids.length + " booking (" + temp_amount + " VND )")
        }
        $('#ids').val(ids.join(','))
    }

    function checkEmptyForm(e) {
        if (ids.length === 0) {
            e.preventDefault();
            toastr.warning("Bạn chưa chọn booking để thanh toán.")
        }
    }
</script>
</html>