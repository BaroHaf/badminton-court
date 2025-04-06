<%@ page import="Model.SaleRecord" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
List<SaleRecord> saleRecords = (List<SaleRecord>) request.getAttribute("saleRecords");
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
                <li class="breadcrumb-item active"></li>
            </ol>
        </nav>
    </div>
    <!-- End Page Title -->

    <section class="section dashboard">
        <div class="row">
            <form method="get" class="row g-3 align-items-end mb-4">
                <div class="col-auto">
                    <label for="from" class="form-label">Từ ngày</label>
                    <input type="date" class="form-control" id="from" name="from" value="<%= request.getParameter("from") != null ? request.getParameter("from") : "" %>">
                </div>
                <div class="col-auto">
                    <label for="to" class="form-label">Đến ngày</label>
                    <input type="date" class="form-control" id="to" name="to" value="<%= request.getParameter("to") != null ? request.getParameter("to") : "" %>">
                </div>
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary">Lọc</button>
                </div>
            </form>
            <div class="row mb-4">
                <div class="col-md-6">
                    <div class="card text-bg-success">
                        <div class="card-body">
                            <h5 class="card-title">Tổng doanh thu từ đặt sân</h5>
                            <p class="card-text fs-4 fw-bold">
                                <%= bookings.stream().mapToDouble(b -> b.getAmount()).sum() %> VND
                            </p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card text-bg-info">
                        <div class="card-body">
                            <h5 class="card-title">Tổng doanh thu từ bán hàng</h5>
                            <p class="card-text fs-4 fw-bold">
                                <%= saleRecords.stream().mapToDouble(r -> r.getTotal()).sum() %> VND
                            </p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="mb-3">
                <button id="toggleBooking" class="btn btn-outline-success me-2">Chi tiết đặt sân</button>
                <button id="toggleSales" class="btn btn-outline-info">Chi tiết bán hàng</button>
            </div>

            <h4 class="mt-4">Chi tiết đặt sân</h4>
            <div id="bookingTable">
                <table class="table table-bordered table-hover">
                    <thead>
                    <tr>
                        <th>Sân</th>
                        <th>Ngày giờ bắt đầu</th>
                        <th>Ngày giờ kết thúc</th>
                        <th>Tổng tiền</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Booking b : bookings) { %>
                    <tr>
                        <td><%= b.getCourt().getName() %></td>
                        <td><%= b.getStartTime() %></td>
                        <td><%= b.getEndTime() %></td>
                        <td><%= b.getAmount() %> VND</td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>

            <h4 class="mt-5">Chi tiết bán hàng</h4>
            <div id="salesTable">
                <table class="table table-bordered table-hover">
                    <thead>
                    <tr>
                        <th>Sản phẩm</th>
                        <th>Số lượng</th>
                        <th>Giá</th>
                        <th>Tổng cộng</th>
                        <th>Ngày tạo</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (SaleRecord s : saleRecords) { %>
                    <tr>
                        <td><%= s.getProduct().getName() %></td>
                        <td><%= s.getQuantity() %></td>
                        <td><%= s.getPrice() %> VND</td>
                        <td><%= s.getTotal() %> VND</td>
                        <td><%= s.getCreatedAt() %></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
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
    const bookingBtn = document.getElementById('toggleBooking');
    const salesBtn = document.getElementById('toggleSales');
    const bookingTable = document.getElementById('bookingTable');
    const salesTable = document.getElementById('salesTable');

    function showBooking() {
        bookingTable.style.display = 'block';
        salesTable.style.display = 'none';
        bookingBtn.classList.remove('btn-outline-success');
        bookingBtn.classList.add('btn-success');
        salesBtn.classList.remove('btn-info');
        salesBtn.classList.add('btn-outline-info');
    }

    function showSales() {
        bookingTable.style.display = 'none';
        salesTable.style.display = 'block';
        salesBtn.classList.remove('btn-outline-info');
        salesBtn.classList.add('btn-info');
        bookingBtn.classList.remove('btn-success');
        bookingBtn.classList.add('btn-outline-success');
    }

    bookingBtn.addEventListener('click', showBooking);
    salesBtn.addEventListener('click', showSales);

    // Default view: show booking, hide sales
    showBooking();
</script>


</body>

</html>