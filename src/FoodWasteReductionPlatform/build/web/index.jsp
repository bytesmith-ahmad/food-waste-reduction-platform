<!-- File: login_register.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session != null && session.getAttribute("user") != null) {
        response.sendRedirect("views/home.jsp"); // Redirect to the home page
        return; // Stop processing the rest of the JSP
    }
%>
<html>
<head>
    <title>Food Waste Reduction Platform</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.2/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <style>
        .card {
            margin-top: 20px;
        }
        .card-header {
            background-color: #007bff;
            color: white;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <h2 class="text-center mt-4">Food Waste Reduction Platform</h2>
            <% if (session.getAttribute("register_success_msg") != null) { %>
                <div class="alert alert-success" role="alert">
                    <%= session.getAttribute("register_success_msg") %>
                </div>
            <% session.removeAttribute("register_success_msg"); %>
            <% } %>
            
            <% if (session.getAttribute("login_error_msg") != null) { %>
                <div class="alert alert-warning" role="alert">
                    <%= session.getAttribute("login_error_msg") %>
                </div>
            <% session.removeAttribute("login_error_msg"); %>
            <% } %>
            <div class="card">
                <div class="card-body">
                    <div class="tab-content" id="login-register-tabs-content">
                        <div class="tab-pane fade show active" id="login" role="tabpanel" aria-labelledby="login-tab">
                            <form action="UserServlet" method="post">
                                <input type="hidden" name="action" value="login">
                                <div class="form-group">
                                    <label>Email:</label>
                                    <input type="email" name="email" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label>Password:</label>
                                    <input type="password" name="password" class="form-control" required>
                                </div>
                                <button type="submit" class="btn btn-primary">Login</button>
                                <div class="mt-3">
                                    Not a member? <a href="#register" data-toggle="tab">Register</a>
                                </div>
                            </form>
                        </div>
                        <div class="tab-pane fade" id="register" role="tabpanel" aria-labelledby="register-tab">
                            <form action="UserServlet" method="post">
                                <input type="hidden" name="action" value="register">
                                <div class="form-group">
                                    <label>Name:</label>
                                    <input type="text" name="name" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label>Email:</label>
                                    <input type="email" name="email" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label>Password:</label>
                                    <input type="password" name="password" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label>User Type:</label>
                                    <select name="userType" class="form-control">
                                        <option value="retailer">Retailers</option>
                                        <option value="consumer">Consumer</option>
                                        <option value="charitable_organization">Charitable organization</option>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-success">Register</button>
                                <div class="mt-3">
                                    Already registered? <a href="#login" data-toggle="tab">Login</a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    $(document).ready(function() {
        $('#login-register-tabs a').on('click', function(e) {
            e.preventDefault();
            $(this).tab('show');
        });
    });
</script>
</body>
</html>
