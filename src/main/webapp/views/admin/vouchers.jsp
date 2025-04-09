<%@ page import="java.util.List" %>
<%@ page import="Model.Voucher" %>
<%@ page import="Dao.VoucherDao" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <%@include file="../include/head.jsp" %>
    <title>Quản lý Voucher</title>
</head>

<body>

<%@include file="../include/header.jsp" %>
<%@include file="../include/sidebar.jsp" %>

<main id="main" class="main">
    <div class="pagetitle">
        <h1>Quản lý Voucher</h1>
    </div>

    <section class="section">
        <div class="row">
            <div class="col-md-4">
                <h5>Thêm Voucher</h5>
                <form action="<%=request.getContextPath()%>/admin/voucher" method="post">
                    <div class="mb-3">
                        <label>Mã Voucher</label>
                        <input type="text" name="code" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label>Loại</label>
                        <select name="type" class="form-control">
                            <option value="PERCENTAGE">Phần trăm</option>
                            <option value="FIX_AMOUNT">Số tiền</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label>Giảm giá</label>
                        <input type="number" name="discount" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label>Ngày bắt đầu</label>
                        <input type="date" name="startDate" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label>Ngày kết thúc</label>
                        <input type="date" name="endDate" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label>Áp dụng cho hạng</label>
                        <select name="forRank" id="forRank">
                            <option value="BRONZE">BRONZE</option>
                            <option value="SILVER">SILVER</option>
                            <option value="GOLD">GOLD</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-success">Thêm</button>
                </form>
            </div>

            <div class="col-md-8">
                <h5>Danh sách Voucher</h5>
                <table class="table">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Mã</th>
                        <th>Loại</th>
                        <th>Giảm giá</th>
                        <th>Ngày bắt đầu</th>
                        <th>Ngày kết thúc</th>
                        <th>Vô hiệu hóa</th>
                        <th>Áp dụng cho hạng</th>
                        <th>Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% List<Voucher> vouchers = new VoucherDao().getAll();
                        for (Voucher v : vouchers) { %>
                    <tr>
                        <td><%= v.getId() %></td>
                        <td><%= v.getCode() %></td>
                        <td><%= v.getType() %></td>
                        <td><%= v.getDiscount() %></td>
                        <td><%= v.getStartDate() %></td>
                        <td><%= v.getEndDate() %></td>
                        <td><%= v.isDisabled() ? "Có" : "Không" %></td>
                        <td><%= v.getForRank() %></td>
                        <td>
                            <button onclick="changeUpdateModalForm(<%= v.getId() %>, '<%= v.getCode() %>', '<%= v.getType() %>', <%= v.getDiscount() %>, '<%= v.getStartDate() %>', '<%= v.getEndDate() %>', <%= v.isDisabled() %>)" type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#UpdateModal">
                                Cập nhật
                            </button>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </section>
</main>

<!-- Modal cập nhật voucher -->
<div class="modal fade" id="UpdateModal" tabindex="-1" aria-labelledby="UpdateModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Cập nhật Voucher</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="<%=request.getContextPath()%>/admin/voucher/update" method="post">
                    <input type="hidden" name="id" id="update-id">
                    <div class="mb-3">
                        <label>Mã Voucher</label>
                        <input type="text" name="code" id="update-code" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label>Loại</label>
                        <select name="type" id="update-type" class="form-control">
                            <option value="PERCENTAGE">Phần trăm</option>
                            <option value="FIX_AMOUNT">Số tiền</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label>Giảm giá</label>
                        <input type="number" name="discount" id="update-discount" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label>Ngày bắt đầu</label>
                        <input type="date" name="startDate" id="update-startDate" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label>Ngày kết thúc</label>
                        <input type="date" name="endDate" id="update-endDate" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label>Vô hiệu hóa</label>
                        <input type="checkbox" name="disabled" id="update-disabled">
                    </div>
                    <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    function changeUpdateModalForm(id, code, type, discount, startDate, endDate, disabled) {
        document.getElementById('update-id').value = id;
        document.getElementById('update-code').value = code;
        document.getElementById('update-type').value = type;
        document.getElementById('update-discount').value = discount;
        document.getElementById('update-startDate').value = startDate;
        document.getElementById('update-endDate').value = endDate;
        document.getElementById('update-disabled').checked = disabled;
    }
</script>

<%@include file="../include/footer.jsp" %>
<%@include file="../include/js.jsp" %>

</body>
</html>
