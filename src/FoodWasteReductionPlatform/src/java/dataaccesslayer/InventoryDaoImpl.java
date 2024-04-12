// File: InventoryDaoImpl.java
package dataaccesslayer;

import model.Inventory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.ClaimedInventory;
import model.PurchasedInventory;

public class InventoryDaoImpl {

    public void addInventoryItem(Inventory item) {
        String sql = "INSERT INTO inventory (retail_id, item_name, quantity, location, expiration_date, flagged, discount) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = new DataSource().createConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, item.getRetailId()); //?
            pstmt.setString(2, item.getItemName());
            pstmt.setInt(3, item.getQuantity());
            pstmt.setString(4, "Not implemented");
            pstmt.setDate(5, new java.sql.Date(item.getExpirationDate().getTime()));
            pstmt.setInt(6,0);
            pstmt.setDouble(7, item.getPrice()); // Need refactor
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Inventory> getInventory() {
        List<Inventory> surplusItems = new ArrayList<>();
        String sql = "SELECT * FROM inventory_view WHERE 1";
        try (Connection con = new DataSource().createConnection();
             PreparedStatement pstmt = con.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Inventory item = new Inventory();
                item.setId(rs.getInt("id"));
                item.setRetailId(rs.getInt("retail_id"));
                item.setItemName(rs.getString("item_name"));
                item.setQuantity(rs.getInt("quantity"));
                item.setExpirationDate(rs.getDate("expiration_date"));
                item.setFlagged(rs.getBoolean("flagged_surplus"));
                item.setDonationFlag(rs.getBoolean("flagged_donation"));
                item.setPrice(rs.getDouble("price"));
                item.setDiscount(rs.getDouble("applied_discount"));
                surplusItems.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("called");
        return surplusItems;
    }

    public List<Inventory> getInventoryByRetailer(int retailerId) {
        List<Inventory> inventory = new ArrayList<>();
        String sql = "SELECT * FROM inventory WHERE retail_id = "+retailerId;
        try (Connection con = new DataSource().createConnection();
             PreparedStatement pstmt = con.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Inventory item = new Inventory();
                item.setId(rs.getInt("id"));
                item.setItemName(rs.getString("item_name"));
                item.setQuantity(rs.getInt("quantity"));
                item.setLocation(rs.getString("location")); //TODO
                item.setExpirationDate(rs.getDate("expiration_date"));
                item.setFlagged(rs.getInt("flagged"));
                item.setDiscount(rs.getInt("discount"));
                inventory.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return inventory;
    }
    

    public List<Inventory> getInventoryForOrg() {
        List<Inventory> inventory = new ArrayList<>();
        String sql = "SELECT * FROM inventory_view WHERE flagged_donation = 1;";
        try (Connection con = new DataSource().createConnection();
             PreparedStatement pstmt = con.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Inventory item = new Inventory();
                item.setId(rs.getInt("id"));
                item.setItemName(rs.getString("item_name"));
                item.setQuantity(rs.getInt("quantity"));
                item.setExpirationDate(rs.getDate("expiration_date"));
                item.setFlagged(rs.getBoolean("flagged_surplus"));
                item.setDonationFlag(rs.getBoolean("flagged_donation"));
                item.setPrice(rs.getDouble("price"));
                item.setDiscount(rs.getDouble("applied_discount"));
                inventory.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return inventory;
    }
    
    
    public List<ClaimedInventory> getClaimedItems(int orgId) {
        List<ClaimedInventory> inventory = new ArrayList<>();
        String sql = "SELECT i.id,i.item_name,i.quantity,c.claim_date FROM inventory i join claimed_food c on i.id=c.inventory_id where c.charitable_org_id="+orgId;
        try (Connection con = new DataSource().createConnection();
             PreparedStatement pstmt = con.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                ClaimedInventory item = new ClaimedInventory();
                item.setId(rs.getInt("id"));
                item.setItemName(rs.getString("item_name"));
                item.setQuantity(rs.getInt("quantity"));
                item.setClaim_date(rs.getString("claim_date"));
                inventory.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return inventory;
    }
    
    
    public List<PurchasedInventory> getPurchasedItems(int consumerId) {
        List<PurchasedInventory> inventory = new ArrayList<>();
        String sql = "SELECT i.id,i.item_name,p.quantity,p.purchase_date FROM inventory i join purchased_items p on i.id=p.inventory_id where p.consumer_id="+consumerId;
        try (Connection con = new DataSource().createConnection();
             PreparedStatement pstmt = con.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                PurchasedInventory item = new PurchasedInventory();
                item.setId(rs.getInt("id"));
                item.setItemName(rs.getString("item_name"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPurchase_date(rs.getString("purchase_date"));
                inventory.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return inventory;
    }
    
     public boolean updateQuantity(int itemId, int quantityToAdd) {
        boolean rowUpdated = false;
        String query = "UPDATE inventory SET quantity = quantity + ? WHERE id = ?";
        
        try (Connection connection = new DataSource().createConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
             
            statement.setInt(1, quantityToAdd);
            statement.setInt(2, itemId);
            
            rowUpdated = statement.executeUpdate() > 0;
        }catch (SQLException e) {
            e.printStackTrace();
        }
        return rowUpdated;
    }

    public boolean flagItemDiscount(int itemId, double discountAmount)  {
        boolean rowUpdated = false;
        String query = "UPDATE inventory SET discount = ? WHERE id = ?";
        
        try (Connection connection = new DataSource().createConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
             
            statement.setDouble(1, discountAmount);
            statement.setInt(2, itemId);
            
            rowUpdated = statement.executeUpdate() > 0;
        }catch (SQLException e) {
            e.printStackTrace();
        }
        return rowUpdated;
    }

    public boolean markAsSurplus(int itemId) {
        boolean rowUpdated = false;
        String query = "UPDATE inventory SET flagged_surplus = 1 WHERE id = ?";
        
        try (Connection connection = new DataSource().createConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
             
            statement.setInt(1, itemId);
            
            rowUpdated = statement.executeUpdate() > 0;
        }catch (SQLException e) {
            e.printStackTrace();
        }
        return rowUpdated;
    }

    public boolean markForDonation(int itemId) {
        boolean rowUpdated = false;
        String query = "UPDATE inventory SET flagged_donation = 1 WHERE id = ?";
        
        try (Connection connection = new DataSource().createConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
             
            statement.setInt(1, itemId);
            
            rowUpdated = statement.executeUpdate() > 0;
        }catch (SQLException e) {
            e.printStackTrace();
        }
        return rowUpdated;
    }

    public void claimAsDonation(int itemId, int orgId) {
        String sql = "INSERT INTO claimed_food (charitable_org_id, inventory_id) VALUES (?, ?)";
        try (Connection con = new DataSource().createConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, orgId);
            pstmt.setInt(2, itemId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void purchaseItem(int consumerId, int itemId, int quantityToPurchase) {
        String sql = "INSERT INTO purchased_items (consumer_id, inventory_id, quantity) VALUES (?, ?,?)";
        try (Connection con = new DataSource().createConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, consumerId);
            pstmt.setInt(2, itemId);
            pstmt.setInt(3, quantityToPurchase);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        boolean rowUpdated = false;
        String query = "UPDATE inventory SET quantity = quantity - ? WHERE id = ?";
        
        try (Connection connection = new DataSource().createConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
             
            statement.setInt(1, quantityToPurchase);
            statement.setInt(2, itemId);
            
            rowUpdated = statement.executeUpdate() > 0;
        }catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
