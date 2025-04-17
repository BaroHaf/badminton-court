<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
        <li class="breadcrumb-item active">Quản lý người dùng</li>
      </ol>
    </nav>
  </div>
  <!-- End Page Title -->

  <section class="section dashboard">
    <div class="row">
      <div class="col-6">
        <div class="card">
          <div class="card-header">
            <h1 class="card-title">Ảnh đại diện</h1>
          </div>
          <div class="card-body">
            <img src="<%=request.getContextPath()%>/<%=user.getAvatar()%>" alt="User avatar" style="width:100%; height: 500px; object-fit: contain;">
            <form action="<%=request.getContextPath()%>/user/avatar" method="post" enctype="multipart/form-data">
              <label for="avatar">Thay đổi ảnh đại diện</label>
              <input type="file" name="avatar" id="avatar" accept="image/*" required>
              <button class="btn btn-success w-100">Cập nhật</button>
            </form>
          </div>
        </div>
      </div>
      <div class="col-6">
        <div class="card">
          <div class="card-header">
            <h1 class="card-title">Thông tin cá nhân</h1>
          </div>
          <div class="card-body">
            <form action="<%=request.getContextPath()%>/user/profile" method="post">
              <div class="col-12">
                <label for="yourEmail" class="form-label">Email</label>
                <input type="email" name="email" class="form-control" id="yourEmail" required value="<%=user.getEmail()%>">
                <div class="invalid-feedback">Vui lòng nhập địa chỉ email hợp lệ!</div>
              </div>

              <div class="col-12">
                <label for="yourUsername" class="form-label">Username</label>
                <div class="input-group has-validation">
                  <input type="text" name="username" class="form-control" id="yourUsername" required value="<%=user.getUsername()%>">
                  <div class="invalid-feedback">Vui lòng chọn 1 username.</div>
                </div>
              </div>

              <div class="col-12">
                <label for="oldPassword" class="form-label">Mât khẩu cũ</label>
                <input type="password" name="oldPassword" class="form-control" id="oldPassword" value="">
                <div class="invalid-feedback">Vui lòng nhập mật khẩu!</div>
              </div>

              <div class="col-12">
                <label for="yourPassword" class="form-label">Mật khẩu mới</label>
                <input type="password" name="password" class="form-control" id="yourPassword" value="">
                <div class="invalid-feedback">Vui lòng nhập mật khẩu!</div>
              </div>

              <div class="col-12">
                <label for="yourPhone" class="form-label">Số điện thoại</label>
                <div class="input-group has-validation">
                  <input type="tel" name="phone" class="form-control" id="yourPhone" required value="<%=user.getPhone()%>">
                  <div class="invalid-feedback">Vui lòng nhập số điện thoại.</div>
                </div>
              </div>
              <div class="col-12 mt-2">
                <button class="btn btn-primary w-100" type="submit">Cập nhật</button>
              </div>
            </form>
          </div>
        </div>
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