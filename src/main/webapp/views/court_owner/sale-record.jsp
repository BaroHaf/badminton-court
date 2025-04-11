<%@ page import="java.util.List" %>
<%@ page import="Model.*" %>
<%@ page import="Util.Util" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.LocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  List<Product> products = (List<Product>) request.getAttribute("products");
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
        <li class="breadcrumb-item active">Trang chủ</li>
      </ol>
    </nav>
  </div>
  <!-- End Page Title -->

  <section class="section dashboard">
    <div class="row">

      <!-- Form thêm bản ghi bán hàng -->
      <div class="col-md-4">
        <div class="card">
          <div class="card-header">Thêm bản ghi bán hàng</div>
          <div class="card-body">
            <form action="<%=request.getContextPath()%>/court-owner/sale-record" method="post">
              <div class="mb-3">
                <label class="form-label">Sản phẩm</label>
                <select class="form-control" name="product_id" required>
                  <% for (Product p : products) { %>
                  <option value="<%= p.getId() %>"><%= p.getName() %> - <%= p.getPrice() %> đ</option>
                  <% } %>
                </select>
              </div>
              <div class="mb-3">
                <label class="form-label">Số lượng</label>
                <input type="number" class="form-control" name="quantity" min="1" required>
              </div>
              <button type="submit" class="btn btn-primary">Thêm</button>
            </form>
          </div>
        </div>
      </div>

      <!-- Danh sách bán hàng -->
      <div class="col-md-8">
        <div class="card">
          <div class="card-header">Danh sách doanh thu cho ngày <%=LocalDate.now().toString()%></div>
          <div class="card-body">
            <table class="table table-bordered" id="saleRecordTable">
              <thead>
              <tr>
                <th>ID</th>
                <th>Sản phẩm</th>
                <th>Số lượng</th>
                <th>Giá</th>
                <th>Tổng tiền</th>
                <th>Hành động</th>
              </tr>
              </thead>
              <tbody>
              <% for (SaleRecord sr : saleRecords) { %>
              <tr>
                <td><%= sr.getId() %></td>
                <td><%= sr.getProduct().getName() %></td>
                <td><%= sr.getQuantity() %></td>
                <td><%= sr.getPrice() %> đ</td>
                <td><%= sr.getTotal() %> đ</td>
                <td>
                  <a href="<%=request.getContextPath()%>/court-owner/sale-record/delete?sale_record_id=<%=sr.getId()%>">
                    <button class="btn btn-warning">
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
<!-- End #main -->

<!-- ======= Footer ======= -->
<%@include file="../include/footer.jsp" %>
<!-- End Footer -->

<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i
        class="bi bi-arrow-up-short"></i></a>

<%@include file="../include/js.jsp" %>
<script>
  function changeUpdateModalForm(id, quantity) {
    $("#updateId").val(id);
    $("#updateQuantity").val(quantity);
  }
</script>
</body>

</html>