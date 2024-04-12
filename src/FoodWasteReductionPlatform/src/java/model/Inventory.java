// File: Inventory.java
package model;

import java.util.Date;

public class Inventory {
    private int id;
    private int retailId;
    private String itemName;
    private int quantity;
    private String location;
    private Date expirationDate;
    private int flagged;
    private int discount;

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getRetailId() {
        return retailId;
    }

    public void setRetailId(int retailId) {
        this.retailId = retailId;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Date getExpirationDate() {
        return expirationDate;
    }

    public void setExpirationDate(Date expirationDate) {
        this.expirationDate = expirationDate;
    }

    public boolean isFlagged() {
        return this.flagged == 1;
    }

    public void setFlagged(int flagged_surplus) {
        this.flagged = flagged_surplus;
    }

    public double getDiscount() {
        return discount;
    }

    public void setDiscount(int discount) {
        this.discount = discount;
    }

    public void setLocation(String location) {
        this.location = location;
    }
}
