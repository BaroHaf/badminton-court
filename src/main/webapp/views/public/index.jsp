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

            <h1>This is da home page</h1>

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