<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <%@include file="../include/head.jsp"%>
    <title>Đăng ký</title>
    <style>
        .card {
            border-radius: 1rem;
            box-shadow: 0 0 25px rgba(0, 0, 0, 0.05);
            border: none;
        }

        .form-control:focus {
            border-color: #2575fc;
            box-shadow: 0 0 0 0.2rem rgba(37, 117, 252, 0.25);
        }

        .logo img {
            height: 40px;
            margin-right: 10px;
        }

        .logo span {
            font-size: 1.5rem;
            font-weight: 600;
            color: #333;
        }

        body {
            background-color: #f8f9fa;
        }
    </style>
</head>

<body>

<main class="d-flex justify-content-center align-items-center min-vh-100">
    <section class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">

                <div class="text-center mb-4">
                    <a href="<%=request.getContextPath()%>/" class="logo d-inline-flex align-items-center justify-content-center">
                        <img src="<%=request.getContextPath()%>/assets/img/apple-touch-icon.png" alt="">
                        <span class="ms-2"><%=Config.app_name%></span>
                    </a>
                </div>

                <div class="card p-4">
                    <div class="card-body">

                        <div class="text-center mb-3">
                            <h5 class="card-title fw-bold text-primary">Đăng ký</h5>
                            <p class="text-muted small">Điền thông tin cá nhân của bạn để tạo tài khoản</p>
                        </div>

                        <form class="needs-validation" action="<%=request.getContextPath()%>/register" method="post" novalidate>

                            <div class="mb-3">
                                <label for="yourEmail" class="form-label">Email</label>
                                <input type="email" name="email" class="form-control" id="yourEmail" required>
                                <div class="invalid-feedback">Vui lòng nhập địa chỉ email hợp lệ!</div>
                            </div>

                            <div class="mb-3">
                                <label for="yourUsername" class="form-label">Tên đăng nhập</label>
                                <input type="text" name="username" class="form-control" id="yourUsername" required>
                                <div class="invalid-feedback">Vui lòng nhập tên đăng nhập.</div>
                            </div>

                            <div class="mb-3">
                                <label for="yourPassword" class="form-label">Mật khẩu</label>
                                <input type="password" name="password" class="form-control" id="yourPassword" required>
                                <div class="invalid-feedback">Vui lòng nhập mật khẩu!</div>
                            </div>

                            <div class="mb-3">
                                <label for="yourPhone" class="form-label">Số điện thoại</label>
                                <input type="tel" name="phone" class="form-control" id="yourPhone" required>
                                <div class="invalid-feedback">Vui lòng nhập số điện thoại.</div>
                            </div>

                            <div class="d-grid mb-3">
                                <button class="btn btn-primary" type="submit">Đăng ký</button>
                            </div>

                            <div class="text-center small">
                                <p class="mb-0">Đã có tài khoản? <a href="<%=request.getContextPath()%>/login">Đăng nhập</a></p>
                            </div>

                        </form>

                    </div>
                </div>

                <div class="text-center mt-3 small text-muted">
                    Thiết kế bởi <a href="https://bootstrapmade.com/" class="fw-bold text-primary">BootstrapMade</a>
                </div>

            </div>
        </div>
    </section>
</main>

<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>
<%@include file="../include/js.jsp"%>

</body>
</html>
