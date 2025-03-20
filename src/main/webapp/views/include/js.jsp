<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Vendor JS Files -->
<script src="<%=request.getContextPath()%>/assets/vendor/apexcharts/apexcharts.min.js"></script>
<script src="<%=request.getContextPath()%>/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="<%=request.getContextPath()%>/assets/vendor/chart.js/chart.umd.js"></script>
<script src="<%=request.getContextPath()%>/assets/vendor/echarts/echarts.min.js"></script>
<script src="<%=request.getContextPath()%>/assets/vendor/quill/quill.js"></script>
<script src="<%=request.getContextPath()%>/assets/vendor/simple-datatables/simple-datatables.js"></script>
<script src="<%=request.getContextPath()%>/assets/vendor/tinymce/tinymce.min.js"></script>
<script src="<%=request.getContextPath()%>/assets/vendor/php-email-form/validate.js"></script>

<!-- Template Main JS File -->
<script src="<%=request.getContextPath()%>/assets/js/main.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js" integrity="sha512-VEd+nq25CkR676O+pLBnDW09R7VQX9Mdiij052gVCp5yVH3jGtH70Ho/UUv4mJDsEdTvqRCFZg0NKGiojGnUCw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/datatables/1.10.21/js/jquery.dataTables.min.js" integrity="sha512-BkpSL20WETFylMrcirBahHfSnY++H2O1W+UnEEO4yNIl+jI2+zowyoGJpbtk6bx97fBXf++WJHSSK2MV4ghPcg==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script>
    const mess_success = "<%=request.getAttribute("success")%>"
    const mess_warning = "<%=request.getAttribute("warning")%>"
    if (mess_success !== "null"){
        toastr.success(mess_success, "Thành công")
    }
    if (mess_warning !== "null"){
        toastr.warning(mess_warning, "Cảnh báo")
    }
</script>