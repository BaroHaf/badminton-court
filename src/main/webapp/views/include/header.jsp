<%@ page import="Model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% User user = (User) request.getSession().getAttribute("user");%>
<header id="header" class="header fixed-top d-flex align-items-center">

    <div class="d-flex align-items-center justify-content-between">
        <a href="<%=request.getContextPath()%>/" class="logo d-flex align-items-center">
            <img src="<%=request.getContextPath()%>/assets/img/logo.png" alt="">
            <span class="d-none d-lg-block">NiceAdmin</span>
        </a>
        <i class="bi bi-list toggle-sidebar-btn"></i>
    </div><!-- End Logo -->

    <div class="search-bar">
        <form class="search-form d-flex align-items-center" method="POST" action="#">
            <input type="text" name="query" placeholder="Search" title="Enter search keyword">
            <button type="submit" title="Search"><i class="bi bi-search"></i></button>
        </form>
    </div><!-- End Search Bar -->

    <nav class="header-nav ms-auto">
        <ul class="d-flex align-items-center">

            <li class="nav-item d-block d-lg-none">
                <a class="nav-link nav-icon search-bar-toggle " href="#">
                    <i class="bi bi-search"></i>
                </a>
            </li><!-- End Search Icon-->
            <% if (user == null) {%>

                <!-- End Notification Nav -->
                <li class="nav-item dropdown pe-3" style="width: 400px;">
                    <div class="row">
                        <a class="col-6" href="<%=request.getContextPath()%>/login">
                            <button style="width: 100%" class="btn btn-success">Đăng nhập</button>
                        </a>
                        <a class="col-6" href="<%=request.getContextPath()%>/register">
                            <button style="width: 100%" class="btn btn-outline-success">Đăng kí</button>
                        </a>
                    </div>
                </li>
            <% } else {%>
                <li class="nav-item dropdown">

                <a class="nav-link nav-icon" href="#" data-bs-toggle="dropdown">
                    <i class="bi bi-bell"></i>
                    <span class="badge bg-primary badge-number">4</span>
                </a><!-- End Notification Icon -->

                <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow notifications">
                    <li class="dropdown-header">
                        You have 4 new notifications
                        <a href="#"><span class="badge rounded-pill bg-primary p-2 ms-2">View all</span></a>
                    </li>
                    <li>
                        <hr class="dropdown-divider">
                    </li>

                    <li class="notification-item">
                        <i class="bi bi-exclamation-circle text-warning"></i>
                        <div>
                            <h4>Lorem Ipsum</h4>
                            <p>Quae dolorem earum veritatis oditseno</p>
                            <p>30 min. ago</p>
                        </div>
                    </li>

                    <li>
                        <hr class="dropdown-divider">
                    </li>

                    <li class="notification-item">
                        <i class="bi bi-x-circle text-danger"></i>
                        <div>
                            <h4>Atque rerum nesciunt</h4>
                            <p>Quae dolorem earum veritatis oditseno</p>
                            <p>1 hr. ago</p>
                        </div>
                    </li>

                    <li>
                        <hr class="dropdown-divider">
                    </li>

                    <li class="notification-item">
                        <i class="bi bi-check-circle text-success"></i>
                        <div>
                            <h4>Sit rerum fuga</h4>
                            <p>Quae dolorem earum veritatis oditseno</p>
                            <p>2 hrs. ago</p>
                        </div>
                    </li>

                    <li>
                        <hr class="dropdown-divider">
                    </li>

                    <li class="notification-item">
                        <i class="bi bi-info-circle text-primary"></i>
                        <div>
                            <h4>Dicta reprehenderit</h4>
                            <p>Quae dolorem earum veritatis oditseno</p>
                            <p>4 hrs. ago</p>
                        </div>
                    </li>

                    <li>
                        <hr class="dropdown-divider">
                    </li>
                    <li class="dropdown-footer">
                        <a href="#">Show all notifications</a>
                    </li>

                </ul><!-- End Notification Dropdown Items -->

            </li>
                <img src="<%=request.getContextPath()%>/<%=user.getAvatar()%>" style="width: 40px;height: 40px;object-fit: cover" alt="Profile" class="rounded-circle">
                <span class="d-none d-md-block ps-2" style="margin-right: 10px"><%=user.getUsername()%></span>
                <a href="<%=request.getContextPath()%>/logout" style="margin-right: 10px">
                    <button style="width: 100%; " class="btn btn-outline-success">Đăng xuất</button>
                </a>
            <% } %>
            <!-- End Profile Nav -->

        </ul>
    </nav><!-- End Icons Navigation -->

</header>