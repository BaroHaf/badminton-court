<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <%@include file="../include/head.jsp"%>
    <title>Đăng nhập</title>
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
            <div class="col-md-6 col-lg-4">

                <div class="text-center mb-4">
                    <a href="<%=request.getContextPath()%>/" class="logo d-inline-flex align-items-center justify-content-center">
                        <img src="<%=request.getContextPath()%>/assets/img/apple-touch-icon.png" alt="">
                        <span class="ms-2">Đặt sân cầu lông</span>
                    </a>
                </div>


                <div class="card p-4">
                    <div class="card-body">

                        <div class="text-center mb-3">
                            <h5 class="card-title fw-bold" style="color: #0d6efd;">Đăng nhập</h5>
                            <p class="text-muted small">Nhập thông tin tài khoản của bạn</p>
                        </div>

                        <form action="<%=request.getContextPath()%>/login" method="post" class="needs-validation" novalidate>

                            <div class="mb-3">
                                <label for="yourUsername" class="form-label">Tên đăng nhập</label>
                                <div class="input-group has-validation">
                                    <span class="input-group-text"><i class="bi bi-person-fill"></i></span>
                                    <input type="text" name="username" class="form-control" id="yourUsername" required>
                                    <div class="invalid-feedback">Vui lòng nhập tên đăng nhập.</div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="yourPassword" class="form-label">Mật khẩu</label>
                                <div class="input-group has-validation">
                                    <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                                    <input type="password" name="password" class="form-control" id="yourPassword" required>
                                    <div class="invalid-feedback">Vui lòng nhập mật khẩu.</div>
                                </div>
                            </div>

                            <div class="d-grid mb-3">
                                <button class="btn btn-primary" type="submit">Đăng nhập</button>
                            </div>

                            <div class="text-center small">
                                <p class="mb-1">Chưa có tài khoản? <a href="<%=request.getContextPath()%>/register">Đăng ký</a></p>
                                <p>Quên mật khẩu? <a href="<%=request.getContextPath()%>/forgot-password">Lấy lại mật khẩu</a></p>
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
