// File: InventoryServlet.java
package controller;

import businesslayer.InventoryBusinessLogic;
import model.Inventory;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;
import model.User;

public class InventoryServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
           addItem(request,response);
        }
        else if ("addQuantity".equals(action)) {
           addQuantity(request,response);
        }
        else if ("flagDiscount".equals(action)) {
           flagDiscount(request,response);
        }else if ("markSurplus".equals(action)) {
           markSurplus(request,response);
        }else if ("markForDonation".equals(action)) {
           markForDonation(request,response);
        }else if ("claimAsDonation".equals(action)) {
           claimAsDonation(request,response);
        }else if ("purchaseItem".equals(action)) {
           purchaseItem(request,response);
        }
    }
    
    private void addItem(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        InventoryBusinessLogic inventoryBL = new InventoryBusinessLogic();
        try {
                HttpSession session = request.getSession(false);
                User user = (User)session.getAttribute("user");
                
                Inventory item = new Inventory();
                item.setRetailId(user.getId());
                item.setItemName(request.getParameter("itemName"));
                item.setQuantity(Integer.parseInt(request.getParameter("quantity")));
                item.setLocation(request.getParameter("location"));
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                item.setExpirationDate(sdf.parse(request.getParameter("expirationDate")));
                item.setDiscount(Integer.parseInt(request.getParameter("price")));
                inventoryBL.addInventoryItem(item);
                request.getSession(false).setAttribute("success_msg", "Item added sucessfuly.");
                response.sendRedirect("views/home.jsp"); // Redirect to the inventory management page
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private void addQuantity(HttpServletRequest request, HttpServletResponse response) throws IOException {
        InventoryBusinessLogic inventoryBL = new InventoryBusinessLogic();
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        int quantityToAdd = Integer.parseInt(request.getParameter("quantityToAdd"));
        inventoryBL.updateInventoryQuantity(itemId, quantityToAdd);
        request.getSession(false).setAttribute("success_msg", "Quantity added sucessfuly.");
        response.sendRedirect("views/home.jsp"); // Redirect to the inventory management page
    }

    private void flagDiscount(HttpServletRequest request, HttpServletResponse response) throws IOException {
        InventoryBusinessLogic inventoryBL = new InventoryBusinessLogic();
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        double discountAmount = Double.parseDouble(request.getParameter("discountAmount"));
        inventoryBL.flagInventoryItemForDiscount(itemId, discountAmount);
        request.getSession(false).setAttribute("success_msg", "Item flagged for discount sucessfuly.");
        response.sendRedirect("views/home.jsp"); // Redirect to the inventory management page
    }
    

    private void markSurplus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        InventoryBusinessLogic inventoryBL = new InventoryBusinessLogic();
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        inventoryBL.markAsSurplus(itemId);
        request.getSession(false).setAttribute("success_msg", "Item marked as surplus.");
        response.sendRedirect("views/home.jsp"); // Redirect to the inventory management page
    }
    
    private void markForDonation(HttpServletRequest request, HttpServletResponse response) throws IOException {
        InventoryBusinessLogic inventoryBL = new InventoryBusinessLogic();
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        inventoryBL.markForDonation(itemId);
        request.getSession(false).setAttribute("success_msg", "Item marked for donation.");
        response.sendRedirect("views/home.jsp"); // Redirect to the inventory management page
    }
    
    private void claimAsDonation(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = (User)request.getSession(false).getAttribute("user");
        InventoryBusinessLogic inventoryBL = new InventoryBusinessLogic();
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        inventoryBL.claimAsDonation(itemId,user.getId());
        request.getSession(false).setAttribute("success_msg", "Item claimed sucessfully.");
        response.sendRedirect("views/home.jsp"); // Redirect to the inventory management page
    }
    private void purchaseItem(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = (User)request.getSession(false).getAttribute("user");
        InventoryBusinessLogic inventoryBL = new InventoryBusinessLogic();
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        int quantityToPurchase = Integer.parseInt(request.getParameter("quantityToPurchase"));
        inventoryBL.purchaseItem(user.getId(),itemId,quantityToPurchase);
        request.getSession(false).setAttribute("success_msg", "Item purchased sucessfully.");
        response.sendRedirect("views/home.jsp"); // Redirect to the inventory management page
    }
   
}
