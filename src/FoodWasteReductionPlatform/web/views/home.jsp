<%
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("../index.jsp"); // Redirect to the home page
        return; // Stop processing the rest of the JSP
    }
%>
<%@page import="businesslayer.SubscriptionBusinessLogic"%>
<%@page import="model.Subscription"%>
<%@page import="model.PurchasedInventory"%>
<%@page import="model.ClaimedInventory"%>
<%@page import="model.User"%>
<%@page import="businesslayer.InventoryBusinessLogic"%>
<%@page import="java.util.List" %>
<%@page import="model.Inventory" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
               <% 
                   InventoryBusinessLogic inventoryService = new InventoryBusinessLogic();
                   SubscriptionBusinessLogic subscriptionService = new SubscriptionBusinessLogic();
                   
                   User user = (User)session.getAttribute("user");
                   String userType = user.getUserType();
                   List<Inventory> inventory = inventoryService.getInventory(user); 
                   List<ClaimedInventory> claimedItems = null;
                   if (userType.equalsIgnoreCase("charitable_organization")) {
                        claimedItems = inventoryService.getClaimedItems(user.getId()); 
                   }
                   List<PurchasedInventory> purchasedItems = null;
                   List<Subscription> subscriptions = null;
                   if (userType.equalsIgnoreCase("consumer")) {
                        purchasedItems = inventoryService.getPurchasedItems(user.getId()); 
                        subscriptions = subscriptionService.getSubscriptions(user.getId()); 
                   }
               %>
                   
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <title>Food Waste Reduction Platform</title>
                        <meta charset="utf-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1">
                        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
                        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
                        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
                        <style>
                            /* Remove the navbar's default margin-bottom and rounded borders */
                            
                            .navbar {
                                margin-bottom: 0;
                                border-radius: 0;
                            }
                            /* Add a gray background color and some padding to the footer */
                            
                            footer {
                                background-color: #f2f2f2;
                                padding: 25px;
                            }
                            
                            .panel-right {
                                float: right;
                            }
                            
                            .mt-5 {
                                margin-top: 50px;
                            }
                            .near-expiry-item{
                                background: #d9534f36;
                            }
                        </style>
                    </head>

                    <body>

                        <nav class="navbar navbar-inverse">
                            <div class="container-fluid">
                                <div class="navbar-header">
                                    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>                        
                          </button>
                                    <a class="navbar-brand" href="#">Food Waste Reduction Platform</a>
                                </div>
                                <div class="collapse navbar-collapse" id="myNavbar">
                                    <ul class="nav navbar-nav navbar-right">
                                        <li><a href="../UserServlet?action=logout"><span class="glyphicon glyphicon-log-out"></span> Logout</a></li>
                                    </ul>
                                </div>
                            </div>
                        </nav>

                        <div class="container mt-5">
                            <!-- Inventory Panel -->
                            <div class="panel">
                                <div class="panel-heading">
                                    <div class="row">
                                        <div class="col-sm-8">
                                            <h3 class="panel-title"><span class="glyphicon glyphicon-th"></span> Inventory</h3>
                                        </div>
                                        <div class="col-sm-4">
                                                 <% if (userType.equalsIgnoreCase("retailer")) { %>
                                                    <button type="button" class="btn btn-primary panel-right" data-toggle="modal" data-target="#addInventoryModal"> <span class="glyphicon glyphicon-plus"></span> Add New</button>
                                                 <% } %>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel-body">
                                    <% if (session.getAttribute("success_msg") != null) { %>
                                        <div class="alert alert-success" role="alert">
                                            <%= session.getAttribute("success_msg") %>
                                        </div>
                                    <% session.removeAttribute("success_msg"); %>
                                    <% } %>
                                    <table class="table table-bordered table-striped">
                                        <thead>
                                            <tr>
                                                <th>Item</th>
                                                <th>Quantity</th>
                                                <th>Expiration Date</th>
                                                <th>Price</th>
                                                 <% if (userType.equalsIgnoreCase("retailer") || userType.equalsIgnoreCase("consumer")) { %>
                                                    <th>Discounted Price</th>
                                                 <% } %>
                                                 <% if (userType.equalsIgnoreCase("retailer")) { %>
                                                    <th>Flagged For Surplus</th>
                                                    <th>Marked for donation</th>
                                                 <% } %>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% 
                                            for (Inventory item : inventory) {
                                                // Calculate if the item is surplus
                                                boolean expiresInAweek = false;
                                                if (item.getExpirationDate() != null) {
                                                    java.util.Date today = new java.util.Date();
                                                    long diff = item.getExpirationDate().getTime() - today.getTime();
                                                    long daysUntilExpiration = diff / (24 * 60 * 60 * 1000);
                                                    if (daysUntilExpiration <= 7) {
                                                        expiresInAweek = true;
                                                    }
                                                }
                                            %>
                                            <tr id="item-<%= item.getId()%>">
                                                <td><%= item.getItemName()%></td>
                                                <td><%= item.getQuantity()%> 
                                                    <span style="float: right;">
                                                        <button type="button" class="btn btn-success btn-xs" onclick="showAddQuantityModal(<%= item.getId()%>,'<%= item.getItemName()%>')"> <span class="glyphicon glyphicon-plus"></span></button>     
                                                    </span>
                                                </td>
                                                <td class="<%= expiresInAweek ? "near-expiry-item" : "" %>"><%= item.getExpirationDate()%></td>
                                                <td><%= item.getPrice()%></td>
                                                 <% if (userType.equalsIgnoreCase("retailer") || userType.equalsIgnoreCase("consumer")) { %>
                                                    <td><%= item.getDiscount() !=0 ? item.getPrice() - item.getDiscount() : "" %></td>
                                                 <% } %>
                                                 <% if (userType.equalsIgnoreCase("retailer")) { %>
                                                    <td><%= item.isFlagged() ? "Yes" : "" %></td>
                                                    <td><%= item.isDonationFlag()? "Yes" : "" %></td>
                                                 <% } %>
                                                <td>
                                                    
                                                    <% if (userType.equalsIgnoreCase("retailer")) { %>
                                                        <% if (!item.isFlagged()) { %>
                                                        <button type="button" class="btn btn-info btn-xs" onclick="showMarkSurplusModal(<%= item.getId()%>,'<%= item.getItemName()%>')"> <span class="glyphicon glyphicon-plus"></span> Mark as surplus</button>
                                                        <% } else{ %>
                                                        <button type="button" class="btn btn-warning btn-xs" onclick="showAddDiscountModal(<%= item.getId()%>,'<%= item.getItemName()%>')"> <span class="glyphicon glyphicon-usd"></span> Add Discount</button>
                                                        <button type="button" class="btn btn-danger btn-xs" onclick="showAddDonationModal(<%= item.getId()%>,'<%= item.getItemName()%>')"> <span class="glyphicon glyphicon-flag"></span> Flag for Donation</button>
                                                        <% } %>
                                                    <% } else if (userType.equalsIgnoreCase("charitable_organization")) { %>
                                                        <button type="button" class="btn btn-info btn-xs" onclick="showClaimDonationModal(<%= item.getId()%>,'<%= item.getItemName()%>')"> <span class="glyphicon glyphicon-plus"></span> Claim Item</button>
                                                    <% } else{ %>
                                                        <button type="button" class="btn btn-info btn-xs" onclick="showPurchaseItemModal(<%= item.getId()%>,'<%= item.getItemName()%>')"> <span class="glyphicon glyphicon-plus"></span> Purchase Item</button>
                                                    <% }  %>
                                                </td>
                                            </tr>
                                            <% }%>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                                        
                            <%  if (userType.equalsIgnoreCase("charitable_organization")) { %>  
                            <div class="panel">
                                <div class="panel-heading">
                                    <div class="row">
                                        <div class="col-sm-8">
                                            <h3 class="panel-title"><span class="glyphicon glyphicon-th"></span> Claimed Items</h3>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel-body">
                                    <table class="table table-bordered table-striped">
                                        <thead>
                                            <tr>
                                                <th>Item</th>
                                                <th>Quantity</th>
                                                <th>Claim Date</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% 
                                            for (ClaimedInventory item : claimedItems) {
                                            %>
                                            <tr id="item-<%= item.getId()%>">
                                                <td><%= item.getItemName()%> </td>
                                                <td><%= item.getQuantity()%> </td>
                                                <td><%= item.getClaim_date()%></td>
                                            </tr>
                                            <% }%>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <% }%>
                            
                            <%  if (userType.equalsIgnoreCase("consumer")) { %>  
                            <div class="panel">
                                <div class="panel-heading">
                                    <div class="row">
                                        <div class="col-sm-8">
                                            <h3 class="panel-title"><span class="glyphicon glyphicon-th"></span> Purchased Items</h3>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel-body">
                                    <table class="table table-bordered table-striped">
                                        <thead>
                                            <tr>
                                                <th>Item</th>
                                                <th>Quantity</th>
                                                <th>Purchase Date</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% 
                                            for (PurchasedInventory item : purchasedItems) {
                                            %>
                                            <tr id="item-<%= item.getId()%>">
                                                <td><%= item.getItemName()%> </td>
                                                <td><%= item.getQuantity()%> </td>
                                                <td><%= item.getPurchase_date()%></td>
                                            </tr>
                                            <% }%>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="panel">
                                <div class="panel-heading">
                                    <div class="row">
                                        <div class="col-sm-8">
                                            <h3 class="panel-title"><span class="glyphicon glyphicon-th"></span> Subscriptions</h3>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel-body">
                                    <div class="row">
                                        <div class="col-sm-6">
                                            <h4>Add New</h4>
                                            <form action="../SubscriptionServlet" method="post">
                                                <div class="mb-3">
                                                    <label for="location" class="form-label">Location:</label>
                                                    <input type="text" class="form-control" id="location" name="location" required>
                                                </div>
                                                <div class="mb-3">
                                                    <label for="preference" class="form-label">Food Preference: <small>Leave empty if you do not want to set.</small></label>
                                                    <div class="row">
                                                        <div class="col-sm-6">
                                                            <input type="number" class="form-control" id="minPrice" name="minPrice" required placeholder="Minimum Price">
                                                        </div>
                                                        <div class="col-sm-6">
                                                            <input type="number" class="form-control" id="maxPrice" name="maxPrice" required placeholder="Maximum Price">
                                                        </div>
                                                        <div class="col-sm-6">
                                                            <input type="number" class="form-control" id="minQty" name="minQty" required placeholder="Minimum Qty">
                                                        </div>
                                                        <div class="col-sm-6">
                                                            <input type="number" class="form-control" id="maxQty" name="maxQty" required placeholder="Maximum Qty">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Communication Method:</label>
                                                    <div>
                                                        <input type="radio" id="email" name="communicationMethod" value="email" checked required>
                                                        <label for="email">Email</label>
                                                    </div>
                                                    <div>
                                                        <input type="radio" id="phone" name="communicationMethod" value="phone">
                                                        <label for="phone">Phone</label>
                                                    </div>
                                                </div>
                                                <button type="submit" class="btn btn-primary">Subscribe</button>
                                            </form>
                                        </div>
                                        <div class="col-sm-6">
                                            <table class="table table-bordered table-striped">
                                                <thead>
                                                    <tr>
                                                        <th>Item</th>
                                                        <th>Quantity</th>
                                                        <th>Purchase Date</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <% 
                                                    for (Subscription subscription : subscriptions) {
                                                    %>
                                                    <tr id="item-<%= subscription.getId()%>">
                                                        <td><%= subscription.getLocation()%> </td>
                                                        <td><%= subscription.getCommunicationMethod()%> </td>
                                                        <td><%= subscription.getSubsciptionDate()%></td>
                                                    </tr>
                                                    <% }%>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <% }%>

                            <!-- Add Inventory Modal -->
                            <div class="modal fade" id="addInventoryModal" tabindex="-1" role="dialog" aria-labelledby="modalLabel" aria-hidden="true">
                                <div class="modal-dialog" role="document">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                                            <h4 class="modal-title">Add Item</h4>
                                        </div>
                                        <div class="modal-body">
                                            <form action="../InventoryServlet" method="post">
                                                <input type="hidden" name="action" value="add">
                                                <div class="form-group">
                                                    <label for="itemName">Item Name</label>
                                                    <input type="text" class="form-control" name="itemName" placeholder="Item Name" required>
                                                </div>
                                                <div class="form-group">
                                                    <label for="quantity">Quantity</label>
                                                    <input type="number" class="form-control" name="quantity" placeholder="Quantity" required>
                                                </div>
                                                <div class="form-group">
                                                    <label for="expirationDate">Expiration Date</label>
                                                    <input type="date" class="form-control" name="expirationDate" placeholder="YYYY-MM-DD" required>
                                                </div>
                                                <div class="form-group">
                                                    <label for="price">Price</label>
                                                    <input type="text" class="form-control" name="price" placeholder="Price" required>
                                                </div>
                                                <div class="row">
                                                    <button type="submit" class="btn btn-primary" style="float: right;margin-right: 20px">Add Item</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                        <!-- Mark as Surplus Modal -->
                        <div class="modal fade" id="markSurplusModal" tabindex="-1" role="dialog" aria-labelledby="markSurplusModalLabel" aria-hidden="true">
                          <div class="modal-dialog" role="document">
                            <div class="modal-content">
                              <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <h5 class="modal-title" id="markSurplusModalLabel">Mark Item as Surplus</h5>
                              </div>
                              <div class="modal-body">
                                <form action="../InventoryServlet" method="post">
                                  <input type="hidden" id="markSurplusItemId" name="itemId">
                                  <input type="hidden" name="action" value="markSurplus">
                                  <p>Are you sure you want to mark this item as surplus?</p>
                                  <button type="submit" class="btn btn-primary">Confirm</button>
                                </form>
                              </div>
                            </div>
                          </div>
                        </div>

                        
                        <!-- Add Quantity Modal -->
                        <div class="modal fade" id="addQuantityModal" tabindex="-1" role="dialog" aria-labelledby="addQuantityModalLabel" aria-hidden="true">
                          <div class="modal-dialog" role="document">
                            <div class="modal-content">
                              <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <h5 class="modal-title" id="addQuantityModalLabel">Add Quantity</h5>
                              </div>
                              <div class="modal-body">
                                <form action="../InventoryServlet" method="post">
                                  <div class="form-group">
                                    <label for="currentQty">Current Qty:</label>
                                    <input type="text" class="form-control" id="currentQty" readonly>
                                  </div>
                                  <div class="form-group">
                                    <label for="quantityToAdd">Quantity to Add:</label>
                                    <input type="number" class="form-control" id="quantityToAdd" name="quantityToAdd" required>
                                  </div>
                                  <div class="form-group">
                                    <label for="totalQty">Total Quantity:</label>
                                    <input type="text" class="form-control" id="totalQty" readonly>
                                    <input type="hidden" id="addQuantityItemId" name="itemId">
                                    <input type="hidden" name="action" value="addQuantity">
                                  </div>
                                  <button type="submit" class="btn btn-primary">Add Quantity</button>
                                </form>
                              </div>
                            </div>
                          </div>
                        </div>

                        <!-- Flag Discount Modal -->
                        <div class="modal fade" id="flagDiscountModal" tabindex="-1" role="dialog" aria-labelledby="flagDiscountModalLabel" aria-hidden="true">
                          <div class="modal-dialog" role="document">
                            <div class="modal-content">
                              <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <h5 class="modal-title" id="flagDiscountModalLabel">Flag Discount</h5>
                              </div>
                              <div class="modal-body">
                                <form action="../InventoryServlet" method="post">
                                  <div class="form-group">
                                    <label for="originalPrice">Original Price:</label>
                                    <input type="text" class="form-control" id="originalPrice" readonly>
                                  </div>
                                  <div class="form-group">
                                    <label for="discountAmount">Discount Amount:</label>
                                    <input type="number" class="form-control" id="discountAmount" name="discountAmount" required oninput="calculateDiscountedPrice()">
                                  </div>
                                  <div class="form-group">
                                    <label for="discountedPrice">Discounted Price:</label>
                                    <input type="text" class="form-control" id="discountedPrice" readonly>
                                    <input type="hidden" id="flagDiscountItemId" name="itemId">
                                    <input type="hidden" name="action" value="flagDiscount">
                                  </div>
                                  <button type="submit" class="btn btn-primary">Apply Discount</button>
                                </form>
                              </div>
                            </div>
                          </div>
                        </div>
                        
                        
                        <!-- Mark for Donation Modal -->
                        <div class="modal fade" id="markDonationModal" tabindex="-1" role="dialog" aria-labelledby="markDonationModalLabel" aria-hidden="true">
                          <div class="modal-dialog" role="document">
                            <div class="modal-content">
                              <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <h5 class="modal-title" id="markDonationModalLabel">Mark Item for Donation</h5>
                              </div>
                              <div class="modal-body">
                                <form action="../InventoryServlet" method="post">
                                  <input type="hidden" id="markDonationItemId" name="itemId">
                                  <input type="hidden" name="action" value="markForDonation">
                                  <p>Are you sure you want to mark this item for donation?</p>
                                  <button type="submit" class="btn btn-primary">Confirm</button>
                                </form>
                              </div>
                            </div>
                          </div>
                        </div>

                        <!-- Claim Donation Modal -->
                        <div class="modal fade" id="claimDonationModal" tabindex="-1" role="dialog" aria-labelledby="claimDonationModalLabel" aria-hidden="true">
                          <div class="modal-dialog" role="document">
                            <div class="modal-content">
                              <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <h5 class="modal-title" id="claimDonationModalLabel">Claim Item for Donation</h5>
                              </div>
                              <div class="modal-body">
                                <form action="../InventoryServlet" method="post">
                                  <input type="hidden" id="claimDonationItemId" name="itemId">
                                  <input type="hidden" name="action" value="claimAsDonation">
                                  <p>Are you sure you want to claim this item for donation?</p>
                                  <button type="submit" class="btn btn-primary">Confirm</button>
                                </form>
                              </div>
                            </div>
                          </div>
                        </div>
                        
                        <!-- Purchase Item Modal -->
                        <div class="modal fade" id="purchaseItemModal" tabindex="-1" role="dialog" aria-labelledby="purchaseItemModalLabel" aria-hidden="true">
                          <div class="modal-dialog" role="document">
                            <div class="modal-content">
                              <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <h5 class="modal-title" id="purchaseItemModalLabel">Purchase Item</h5>
                              </div>
                              <div class="modal-body">
                                <form action="../InventoryServlet" method="post">
                                  <input type="hidden" id="purchaseItemId" name="itemId">
                                  <input type="hidden" name="action" value="purchaseItem">
                                  <div class="form-group">
                                    <label for="quantityToAdd">Select Qty:</label>
                                    <input type="number" class="form-control" id="quantityToPurchase" name="quantityToPurchase" value="1" required>
                                  </div>
                                  <button type="submit" class="btn btn-primary">Confirm</button>
                                </form>
                              </div>
                            </div>
                          </div>
                        </div>


                      </div>
                    </body>
                    <script>
                        function showMarkSurplusModal(itemId, itemName) {
                          $('#markSurplusModalLabel').text(`Flag `+itemName+' as surplus');
                          $('#markSurplusItemId').val(itemId);
                          $('#markSurplusModal').modal('show');
                        }
                        function showAddDonationModal(itemId, itemName){
                          $('#markDonationModalLabel').text(`Mark `+itemName+' for donation');
                          $('#markDonationItemId').val(itemId);
                          $('#markDonationModal').modal('show');
                        }
                        function showClaimDonationModal(itemId, itemName){
                            $('#claimDonationModalLabel').text(`Claim `+itemName+' as donation');
                            $('#claimDonationItemId').val(itemId);
                            $('#claimDonationModal').modal('show');
                          }
                        function showPurchaseItemModal(itemId, itemName){
                          $('#purchaseItemModalLabel').text(`Purchase `+itemName);
                          $('#purchaseItemId').val(itemId);
                          var qty = $("#item-" + itemId).find("td:eq(1)").text();
                          $("input").attr({"max" : qty,"min" : 1});
                          $('#purchaseItemModal').modal('show');
                        }

                        // Show the Add Quantity Modal and populate it
                        function showAddQuantityModal(itemId, itemName) {
                          $('#addQuantityModalLabel').text(`Add Quantity for `+itemName);
                          $('#addQuantityItemId').val(itemId);
                          var currentQty = $("#item-" + itemId).find("td:eq(1)").text();
                          $('#currentQty').val(currentQty);
                          $('#addQuantityModal').modal('show');
                        }

                        // Show the Flag Discount Modal and populate it
                        function showAddDiscountModal(itemId, itemName) {
                          $('#flagDiscountModalLabel').text(`Set Discount for `+itemName);
                          $('#flagDiscountItemId').val(itemId);
                          var originalPrice = parseFloat($("#item-" + itemId).find("td:eq(3)").text());
                          $('#originalPrice').val(originalPrice);
                          $('#flagDiscountModal').modal('show');
                        }
                        // Calculate the new qty on input change
                        $('#quantityToAdd').on('input', function() {
                            calculateTotalQty();
                        });
                        
                        function calculateTotalQty() {
                            var currentQty = parseInt($("#item-" + $('#addQuantityItemId').val()).find("td:eq(1)").text());
                            var quantityToAdd = parseInt($('#quantityToAdd').val());
                            
                            var totalQty = quantityToAdd + currentQty;
                            $('#totalQty').val(totalQty);
                        }
                        
                        // Calculate the discounted price on input change
                        $('#discountAmount').on('input', function() {
                            calculateDiscountedPrice();
                        });

                        function calculateDiscountedPrice() {
                            var originalPrice = parseFloat($("#item-" + $('#flagDiscountItemId').val()).find("td:eq(3)").text());
                            var discount = parseFloat($('#discountAmount').val());
                            var discountedPrice = originalPrice - discount;
                            $('#discountedPrice').val(discountedPrice.toFixed(2));
                        }
                         $('#toggleExpiresInAweek').click(function() {
                            if ($(this).is(':checked')) {
                                $('tbody tr').hide(); // Hide all rows
                                $('.expiresInAweek_item').show(); // Show only rows with the surplus_item class
                            } else {
                                $('tbody tr').show(); // Show all rows
                            }
                        });
                        </script>



                    </html>