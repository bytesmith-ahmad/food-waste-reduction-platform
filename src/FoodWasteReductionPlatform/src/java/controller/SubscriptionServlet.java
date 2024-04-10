package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import model.Subscription;
import businesslayer.SubscriptionBusinessLogic;
import model.User;

public class SubscriptionServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
                HttpSession session = request.getSession(false);
                User user = (User)session.getAttribute("user");
                
        SubscriptionBusinessLogic subscriptionBL = new SubscriptionBusinessLogic();
        Subscription subscription = new Subscription();
        subscription.setUserId(user.getId());
        subscription.setLocation(request.getParameter("location"));
        subscription.setMinPrice(Double.parseDouble(request.getParameter("minPrice"))); 
        subscription.setMaxPrice(Double.parseDouble(request.getParameter("maxPrice")));
        subscription.setMinQty(Integer.parseInt(request.getParameter("minQty"))); 
        subscription.setMaxQty(Integer.parseInt(request.getParameter("maxQty")));
        subscription.setCommunicationMethod(request.getParameter("communicationMethod"));
        subscriptionBL.addSubscription(subscription);
        request.getSession().setAttribute("register_success_msg", "Registration successful! Please log in.");
        response.sendRedirect("index.jsp");
    }
}
