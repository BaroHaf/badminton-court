<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="Model.Venue" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  List<Venue> venues = (List<Venue>) request.getAttribute("venues");
  DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
%>
<!DOCTYPE html>
<html lang="en">

<head>
  <%@include file="../include/head.jsp"%>
  <title>Trang chủ</title>
</head>

<body>

<!-- ======= Header ======= -->
<%@include file="../include/header.jsp"%>
<!-- End Header -->

<!-- ======= Sidebar ======= -->
<%@include file="../include/sidebar.jsp"%>
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
      <div class="col-5">
        <form action="<%=request.getContextPath()%>/court-owner" method="post" enctype="multipart/form-data">

          <div class="col-12">
            <label for="yourUsername" class="form-label">Tên sân cầu</label>
            <div class="input-group has-validation">
              <input type="text" name="name" class="form-control" id="yourUsername" required>
              <div class="invalid-feedback">Nhập tên sân cầu.</div>
            </div>
          </div>

          <div class="col-12">
            <label for="address" class="form-label">Địa chỉ</label>
            <div class="input-group has-validation">
              <input type="text" name="address" class="form-control" id="address" required>
              <div class="invalid-feedback">Nhập địa chỉ sân cầu.</div>
            </div>
          </div>

          <div class="col-12">
            <label for="openTime" class="form-label">Giờ mở cửa</label>
            <div class="input-group has-validation">
              <input type="time" name="openTime" class="form-control" id="openTime" required>
              <div class="invalid-feedback">Nhập giờ mở cửa.</div>
            </div>
          </div>

          <div class="col-12">
            <label for="closeTime" class="form-label">Giờ đóng cửa</label>
            <div class="input-group has-validation">
              <input type="time" name="closeTime" class="form-control" id="closeTime" required>
              <div class="invalid-feedback">Nhập giờ đóng cửa.</div>
            </div>
          </div>

          <div class="col-12">
            <label for="image" class="form-label">Hình ảnh</label>
            <div class="input-group has-validation">
              <input type="file" accept="image/*" name="image" class="form-control" id="image" required>
              <div class="invalid-feedback">Ảnh cho sân cầu.</div>
            </div>
          </div>

          <div class="col-12">
            <button class="btn btn-primary w-100" type="submit">Thêm sân cầu</button>
          </div>

        </form>
      </div>
      <div class="col-7">
        <h2 class="text-center mb-4">Danh sách sân cầu</h2>
        <table class="table table-striped table-bordered">
          <thead class="table-dark">
          <tr>
            <th>#</th>
            <th>Tên sân</th>
            <th>Địa chỉ</th>
            <th>Ảnh</th>
            <th>Open Time</th>
            <th>Close Time</th>
            <th>Actions</th>
          </tr>
          </thead>
          <tbody>
          <%
            if (venues != null && !venues.isEmpty()) {
              int index = 1;
              for (Venue venue : venues) {
          %>
          <tr>
            <td><%= index++ %></td>
            <td><%= venue.getName() %></td>
            <td><%= venue.getAddress() %></td>
            <td>
              <% if (venue.getImage() != null && !venue.getImage().isEmpty()) { %>
              <img src="<%=request.getContextPath()%>/<%= venue.getImage() %>" alt="Venue Image" width="80">
              <% } else { %>
              No Image
              <% } %>
            </td>
            <td><%= venue.getOpenTime() != null ? venue.getOpenTime().format(timeFormatter) : "N/A" %></td>
            <td><%= venue.getCloseTime() != null ? venue.getCloseTime().format(timeFormatter) : "N/A" %></td>
            <td>
              <a href="<%=request.getContextPath()%>/court-owner/detail?id=<%= venue.getId() %>" class="btn btn-primary btn-sm">Chi tiết</a>
              <a href="deleteVenue?id=<%= venue.getId() %>" class="btn btn-danger btn-sm"
                 onclick="return confirm('Are you sure you want to delete this venue?');">Delete</a>
            </td>
          </tr>
          <%
            }
          } else {
          %>
          <tr>
            <td colspan="7" class="text-center">No venues available.</td>
          </tr>
          <%
            }
          %>
          </tbody>
        </table>
      </div>
    </div>
  </section>

</main>
<!-- End #main -->

<!-- ======= Footer ======= -->
<%@include file="../include/footer.jsp"%>
<!-- End Footer -->

<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>

<%@include file="../include/js.jsp"%>
</body>

</html>