// File: UserServlet.java
package controller;

import businesslayer.UserBusinessLogic;
import model.User;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import javax.servlet.http.HttpSession;

public class UserServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("register".equals(action)) {
            registerUser(request, response);
        } else if ("login".equals(action)) {
            loginUser(request, response);
        }
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            logoutUser(request, response);
        }
    }

    private void registerUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserBusinessLogic userBL = new UserBusinessLogic();
        User user = new User();
        user.setName(request.getParameter("name"));
        user.setEmail(request.getParameter("email"));
        user.setPassword(request.getParameter("password")); // Consider using hashing for storing passwords
        user.setUserType(request.getParameter("userType"));
        userBL.addUser(user);
        request.getSession().setAttribute("register_success_msg", "Registration successful! Please log in.");
        response.sendRedirect("index.jsp");
//        RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");
//        dispatcher.forward(request, response);
    }

    private void loginUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserBusinessLogic userBL = new UserBusinessLogic();
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userBL.authenticateUser(email, password);

        if (user != null) {
            request.getSession().setAttribute("user", user);
            response.sendRedirect("views/home.jsp"); // Redirect to home page or dashboard
        } else {
            request.getSession().setAttribute("login_error_msg", "Invalid email or password");
            response.sendRedirect("index.jsp");
        }
    }
    
    private void logoutUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false); // Fetch session if it exists
        if (session != null) {
            session.invalidate(); // Invalidate the session, removing any session attributes
        }
        response.sendRedirect("index.jsp"); // Redirect to login page
    }
}
