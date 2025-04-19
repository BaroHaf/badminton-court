<%@ page import="java.util.List" %>
<%@ page import="Model.Product" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% List<Product> products = (List<Product>) request.getAttribute("products"); %>

<!DOCTYPE html>
<html lang="en">

<head>
    <%@include file="../include/head.jsp" %>
    <title>Quản lý sản phẩm</title>
</head>

<body>

<%@include file="../include/header.jsp" %>
<%@include file="../include/sidebar.jsp" %>

<main id="main" class="main">
    <div class="pagetitle">
        <h1>Quản lý sản phẩm</h1>
    </div>

    <section class="section dashboard">
        <div class="row">
            <!-- Form thêm sản phẩm -->
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">Thêm sản phẩm</div>
                    <div class="card-body">
                        <form action="<%=request.getContextPath()%>/court-owner/products" method="post">
                            <div class="mb-3">
                                <label class="form-label">Tên sản phẩm</label>
                                <input type="text" class="form-control" name="name" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Giá</label>
                                <input type="number" step="0.01" class="form-control" name="price" min="0" required>
                            </div>
                            <button type="submit" class="btn btn-primary">Thêm</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Danh sách sản phẩm -->
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">Danh sách sản phẩm</div>
                    <div class="card-body">
                        <table class="table table-bordered" id="productTable">
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên</th>
                                <th>Giá</th>
                                <th>Hành động</th>
                            </tr>
                            </thead>
                            <tbody>
                            <% for (Product p : products) { %>
                            <tr>
                                <td><%= p.getId() %></td>
                                <td><%= p.getName() %></td>
                                <td><%= p.getPrice() %></td>
                                <td>
                                    <button onclick="changeUpdateModalForm(<%= p.getId() %>, '<%= p.getName() %>', <%= p.getPrice() %>)"
                                            class="btn btn-primary"
                                            data-bs-toggle="modal"
                                            data-bs-target="#updateModal">
                                        Cập nhật
                                    </button>
                                    <a href="<%=request.getContextPath()%>/court-owner/delete-product?id=<%=p.getId()%>">
                                        <button class="btn btn-danger">
                                            Xóa
                                        </button>
                                    </a>
                                </td>
                            </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </section>
</main>

<!-- Modal cập nhật sản phẩm -->
<div class="modal fade" id="updateModal" tabindex="-1" aria-labelledby="updateModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="updateModalLabel">Cập nhật sản phẩm</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="<%=request.getContextPath()%>/court-owner/update-product" method="post">
                    <input type="hidden" id="updateId" name="id">

                    <div class="mb-3">
                        <label class="form-label">Tên sản phẩm</label>
                        <input type="text" class="form-control" id="updateName" name="name" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Giá</label>
                        <input type="number" step="0.01" class="form-control" id="updatePrice" name="price" required>
                    </div>

                    <button type="submit" class="btn btn-success">Cập nhật</button>
                </form>
            </div>
        </div>
    </div>
</div>

<%@include file="../include/footer.jsp" %>
<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i
        class="bi bi-arrow-up-short"></i></a>

<%@include file="../include/js.jsp" %>
<script>
    function changeUpdateModalForm(id, name, price) {
        $("#updateId").val(id);
        $("#updateName").val(name);
        $("#updatePrice").val(price);
    }
</script>

</body>
</html>
