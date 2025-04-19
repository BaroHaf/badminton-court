<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="Model.Venue" %>
<%@ page import="Model.Court" %>
<%@ page import="java.util.List" %>
<%
    Venue venue = (Venue) request.getAttribute("venue");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
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
                <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/">Trang chủ</a></li>
                <li class="breadcrumb-item active">Quản lý sân cầu</li>
            </ol>
        </nav>
    </div>
    <!-- End Page Title -->

    <section class="section dashboard">
        <div class="row">
            <!-- Venue Edit Form (Left side - 5 columns) -->
            <div class="col-5">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        Edit Venue
                    </div>
                    <div class="card-body">
                        <form action="<%=request.getContextPath()%>/court-owner/detail" method="post"
                              enctype="multipart/form-data">
                            <input type="hidden" name="id" value="<%= venue.getId() %>">

                            <div class="col-12">
                                <label for="yourUsername" class="form-label">Tên sân cầu</label>
                                <div class="input-group has-validation">
                                    <input type="text" name="name" class="form-control" id="yourUsername" required
                                           value="<%=venue.getName()%>">
                                    <div class="invalid-feedback">Nhập tên sân cầu.</div>
                                </div>
                            </div>

                            <div class="col-12">
                                <label for="address" class="form-label">Địa chỉ</label>
                                <div class="input-group has-validation">
                                    <input type="text" name="address" class="form-control" id="address" required
                                           value="<%=venue.getAddress()%>">
                                    <div class="invalid-feedback">Nhập tên sân cầu.</div>
                                </div>
                            </div>

                            <div class="col-12">
                                <label for="openTime" class="form-label">Giờ mở cửa</label>
                                <div class="input-group has-validation">
                                    <input type="time" name="openTime" class="form-control" id="openTime" required
                                           value="<%=venue.getOpenTime()%>">
                                    <div class="invalid-feedback">Nhập tên sân cầu.</div>
                                </div>
                            </div>

                            <div class="col-12">
                                <label for="closeTime" class="form-label">Giờ đóng cửa</label>
                                <div class="input-group has-validation">
                                    <input type="time" name="closeTime" class="form-control" id="closeTime" required
                                           value="<%=venue.getCloseTime()%>">
                                    <div class="invalid-feedback">Nhập tên sân cầu.</div>
                                </div>
                            </div>
                            <a href="<%=request.getContextPath()%>/<%=venue.getImage()%>" target="_blank"
                               class="btn btn-primary m-1">
                                Xem ảnh
                            </a>
                            <div class="col-12">
                                <label for="image" class="form-label">Hình ảnh</label>
                                <div class="input-group has-validation">
                                    <input type="file" accept="image/*" name="image" class="form-control" id="image">
                                    <div class="invalid-feedback">Ảnh cho sân cầu.</div>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-success w-100 m-1">Cập nhật sân</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Courts List (Right side - 7 columns) -->
            <div class="col-7">
                <div class="card">
                    <div class="card-header bg-info text-white">
                        Courts List
                    </div>
                    <button type="button" data-bs-toggle="modal" data-bs-target="#createCourt"
                            class="btn btn-success w-25 m-1">Thêm sân
                    </button>
                    <div class="card-body">
                        <table class="table table-bordered table-striped">
                            <thead class="table-dark">
                            <tr>
                                <th>#</th>
                                <th>Tên</th>
                                <th>Giá sân 1 giờ</th>
                                <th>Sẵn dùng</th>
                                <th>Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                List<Court> courts = venue.getCourts();
                                if (courts != null && !courts.isEmpty()) {
                                    int index = 1;
                                    for (Court court : courts) {
                            %>
                            <% if (!court.isDeleted()) {%>
                            <tr>
                                <td><%= index++ %>
                                </td>
                                <td><%= court.getName() %>
                                </td>
                                <td><%= court.getPricePerHour() %> VND</td>
                                <td>
                                    <a href="<%=request.getContextPath()%>/court-owner/court?court_id=<%= court.getId() %>">
                                        <button type="submit"
                                                class="btn btn-sm w-100 <%= court.isAvailable() ? "btn-success" : "btn-danger" %>">
                                            <%= court.isAvailable() ? "Có" : "Không" %>
                                        </button>
                                    </a>
                                </td>
                                <td class="col-2">
                                    <button onclick="$('#updateCourtId').val(<%=court.getId()%>); $('#updateCourtName').val('<%=court.getName()%>');$('#updateCourtPrice').val(<%=court.getPricePerHour()%>)"
                                            class="btn btn-warning btn-sm m-1 w-100" data-bs-toggle="modal"
                                            data-bs-target="#updateCourt">Cập nhật
                                    </button>
                                    <button onclick="$('#deleteCourtId').val(<%=court.getId()%>)"
                                            class="btn btn-danger m-1 btn-sm w-100" data-bs-toggle="modal"
                                            data-bs-target="#deleteCourt">Xóa
                                    </button>
                                </td>
                            </tr>
                            <% }%>
                            <%
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="5" class="text-center">Hiện chưa có sân nào.</td>
                            </tr>
                            <%
                                }
                            %>
                            </tbody>
                        </table>
                    </div>
                    <div class="modal fade" id="createCourt" tabindex="-1">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <form action="<%=request.getContextPath()%>/court-owner/court" method="post">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Thêm sân cầu</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                aria-label="Close"></button>
                                    </div>
                                    <input type="hidden" value="<%=venue.getId()%>" name="venueId">
                                    <div class="modal-body">
                                        <div class="col-12">
                                            <label for="name" class="form-label">Số sân</label>
                                            <input type="text" name="name" class="form-control" id="name" required>
                                            <div class="invalid-feedback">Nhập số sân!</div>
                                        </div>

                                        <div class="col-12">
                                            <label for="pricePerHour" class="form-label">Giá sân</label>
                                            <input type="number" name="pricePerHour" class="form-control"
                                                   id="pricePerHour" required>
                                            <div class="invalid-feedback">Nhập giá sân!</div>
                                        </div>

                                        <div class="col-12">
                                            <label for="isAvailable" class="form-label">Khả dụng</label>
                                            <select name="isAvailable" class="form-control" id="isAvailable" required>
                                                <option value="true" selected>Có</option>
                                                <option value="false">Không</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng
                                        </button>
                                        <button type="submit" class="btn btn-primary">Tạo</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="modal fade" id="deleteCourt" tabindex="-1">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <form action="<%=request.getContextPath()%>/court-owner/delete-court" method="get">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Xóa sân cầu</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                aria-label="Close"></button>
                                    </div>
                                    <input type="hidden" id="deleteCourtId" name="deleteCourtId">
                                    <div class="modal-body">
                                        <h3>Bạn có chắc muốn xóa sân này không?</h3>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng
                                        </button>
                                        <button type="submit" class="btn btn-primary">Xóa</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="modal fade" id="updateCourt" tabindex="-1">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <form action="<%=request.getContextPath()%>/court-owner/update-court" method="post">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Cập nhật sân cầu</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                aria-label="Close"></button>
                                    </div>
                                    <input type="hidden" id="updateCourtId" name="updateCourtId">
                                    <div class="modal-body">
                                        <div class="col-12">
                                            <label for="updateCourtName" class="form-label">Số sân</label>
                                            <input type="text" name="name" class="form-control" id="updateCourtName"
                                                   required>
                                            <div class="invalid-feedback">Nhập số sân!</div>
                                        </div>

                                        <div class="col-12">
                                            <label for="updateCourtPrice" class="form-label">Giá sân</label>
                                            <input type="number" name="pricePerHour" class="form-control"
                                                   id="updateCourtPrice" required>
                                            <div class="invalid-feedback">Nhập giá sân!</div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng
                                        </button>
                                        <button type="submit" class="btn btn-primary">Cập nhật</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
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
</body>

</html>