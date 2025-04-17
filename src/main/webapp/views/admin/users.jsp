<%@ page import="java.util.List" %>
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
                <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/">Home</a></li>
                <li class="breadcrumb-item active">Dashboard</li>
            </ol>
        </nav>
    </div>
    <!-- End Page Title -->

    <section class="section dashboard">
        <div class="row">
            <div class="col-12">
                <h2 class="text-center" >Danh sách người dùng</h2>
                <button class="btn btn-success m-1" data-bs-toggle="modal" data-bs-target="#CreateModel">Thêm tài khoản mới</button>
                <table id="myTable" class="table table-striped table-bordered">
                    <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Điện thoại</th>
                        <th>Vai trò</th>
                        <th>Đã xác thực</th>
                        <th>Bị chặn</th>
                        <th>Avatar</th>
                        <th>Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        List<User> users = (List<User>) request.getAttribute("users");
                        if (users != null) {
                            for (User x : users) {
                    %>
                    <tr>
                        <td><%= x.getId() %></td>
                        <td><%= x.getUsername() %></td>
                        <td><%= x.getEmail() %></td>
                        <td><%= x.getPhone() %></td>
                        <td><%= x.getRole() %></td>
                        <td><%= x.isVerified() ? "✅ Yes" : "❌ No" %></td>
                        <td><%= x.isBlocked() ? "❌ Yes" : "✅ No" %></td>
                        <td>
                            <% if (x.getAvatar() != null && !x.getAvatar().isEmpty()) { %>
                            <img src="<%=request.getContextPath()%>/<%= x.getAvatar() %>" alt="Avatar" class="img-fluid rounded-circle" style="width: 50px; height: 50px;">
                            <% } else { %>
                            No Avatar
                            <% } %>
                        </td>
                        <td>
                            <button onclick="changeUpdateModalForm(<%=x.getId()%>, '<%=x.getEmail()%>', '<%=x.getUsername()%>', '<%=x.getPhone()%>', '<%=x.isVerified()%>', '<%=x.isBlocked()%>', '<%=x.getRole()%>')" type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#UpdateModel">
                                Cập nhật
                            </button>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="8" class="text-center">No users found.</td>
                    </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
                <div class="modal fade" id="UpdateModel" tabindex="-1">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <form action="<%=request.getContextPath()%>/admin/users" method="post">
                                <div class="modal-header">
                                    <h5 class="modal-title">Cập nhật tài khoản</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <input type="hidden" id="updateId" name="id">
                                <div class="modal-body">
                                    <div class="col-12">
                                        <label for="updateEmail" class="form-label">Email</label>
                                        <input type="email" name="email" class="form-control" id="updateEmail" required>
                                        <div class="invalid-feedback">Vui lòng nhập địa chỉ email hợp lệ!</div>
                                    </div>

                                    <div class="col-12">
                                        <label for="updateUsername" class="form-label">Username</label>
                                        <div class="input-group has-validation">
                                            <input type="text" name="username" class="form-control" id="updateUsername" required>
                                            <div class="invalid-feedback">Vui lòng chọn 1 username.</div>
                                        </div>
                                    </div>

                                    <div class="col-12">
                                        <label for="updatePassword" class="form-label">Password</label>
                                        <input type="password" name="password" class="form-control" id="updatePassword" value="">
                                        <div class="invalid-feedback">Vui lòng nhập mật khẩu!</div>
                                    </div>

                                    <div class="col-12">
                                        <label for="updatePhone" class="form-label">Số điện thoại</label>
                                        <div class="input-group has-validation">
                                            <input type="tel" name="phone" class="form-control" id="updatePhone" required>
                                            <div class="invalid-feedback">Vui lòng nhập số điện thoại.</div>
                                        </div>
                                    </div>

                                    <div class="col-12">
                                        <label for="updateVerified" class="form-label">Tình trạng xác thực</label>
                                        <div class="input-group has-validation">
                                            <select name="verified" id="updateVerified" class="form-control">
                                                <option value="true">Đã xác thực</option>
                                                <option value="false">Chưa xác thực</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="col-12">
                                        <label for="updateBlocked" class="form-label">Chặn vào hệ thống</label>
                                        <div class="input-group has-validation">
                                            <select name="blocked" id="updateBlocked" class="form-control">
                                                <option value="true">Bị chặn</option>
                                                <option value="false">Không chặn</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="col-12">
                                        <label for="updateRole" class="form-label">Loại tài khoản</label>
                                        <div class="input-group has-validation">
                                            <select name="role" id="updateRole" class="form-control">
                                                <option value="CUSTOMER">Khách hàng</option>
                                                <option value="ADMIN">Quản trị viên</option>
                                                <option value="COURT_OWNER">Chủ sân</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                    <button type="submit" class="btn btn-primary">Cập nhật</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="modal fade" id="CreateModel" tabindex="-1">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <form action="<%=request.getContextPath()%>/admin/create-user" method="post">
                                <div class="modal-header">
                                    <h5 class="modal-title">Tạo tài khoản</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="col-12">
                                        <label for="createEmail" class="form-label">Email</label>
                                        <input type="email" name="email" class="form-control" id="createEmail" required>
                                        <div class="invalid-feedback">Vui lòng nhập địa chỉ email hợp lệ!</div>
                                    </div>

                                    <div class="col-12">
                                        <label for="createUsername" class="form-label">Username</label>
                                        <div class="input-group has-validation">
                                            <input type="text" name="username" class="form-control" id="createUsername" required>
                                            <div class="invalid-feedback">Vui lòng chọn 1 username.</div>
                                        </div>
                                    </div>

                                    <div class="col-12">
                                        <label for="createPassword" class="form-label">Password</label>
                                        <input type="password" name="password" class="form-control" id="createPassword" required>
                                        <div class="invalid-feedback">Vui lòng nhập mật khẩu!</div>
                                    </div>

                                    <div class="col-12">
                                        <label for="createPhone" class="form-label">Số điện thoại</label>
                                        <div class="input-group has-validation">
                                            <input type="tel" name="phone" class="form-control" id="createPhone" required>
                                            <div class="invalid-feedback">Vui lòng nhập số điện thoại.</div>
                                        </div>
                                    </div>

                                    <div class="col-12">
                                        <label for="createVerified" class="form-label">Tình trạng xác thực</label>
                                        <div class="input-group has-validation">
                                            <select name="verified" id="createVerified" class="form-control">
                                                <option value="true">Đã xác thực</option>
                                                <option value="false">Chưa xác thực</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="col-12">
                                        <label for="createBlocked" class="form-label">Chặn vào hệ thống</label>
                                        <div class="input-group has-validation">
                                            <select name="blocked" id="createBlocked" class="form-control">
                                                <option value="true">Bị chặn</option>
                                                <option selected value="false">Không chặn</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="col-12">
                                        <label for="createRole" class="form-label">Loại tài khoản</label>
                                        <div class="input-group has-validation">
                                            <select name="role" id="createRole" class="form-control">
                                                <option value="CUSTOMER">Khách hàng</option>
                                                <option value="ADMIN">Quản trị viên</option>
                                                <option value="COURT_OWNER">Chủ sân</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                    <button type="submit" class="btn btn-primary">Tạo</button>
                                </div>
                            </form>
                        </div>
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
<script>
    $("#myTable").DataTable()
    function changeUpdateModalForm(id, email, username, phone, verified, blocked, role) {
        $("#updateId").val(id)
        $("#updateEmail").val(email);
        $("#updateUsername").val(username);
        $("#updatePhone").val(phone);
        if (verified === 'true'){
            $("#updateVerified").prop('disabled', true);
        } else {
            $("#updateVerified").prop('disabled', false);
        }
        $("#updateVerified").val(verified);
        $("#updateBlocked").val(blocked);
        $("#updateRole").val(role);
    }
</script>
</body>

</html>