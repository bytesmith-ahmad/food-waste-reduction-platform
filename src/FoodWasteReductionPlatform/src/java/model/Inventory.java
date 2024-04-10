// File: Inventory.java
package model;

import java.util.Date;

public class Inventory {
    private int id;
    private int retailId;
    private String itemName;
    private int quantity;
    private Date expirationDate;
    private boolean flagged_surplus;
    private boolean flagged_donation;
    private double price;
    private double discount;

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
        return flagged_surplus;
    }

    public void setFlagged(boolean flagged_surplus) {
        this.flagged_surplus = flagged_surplus;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getDiscount() {
        return discount;
    }

    public void setDiscount(double discount) {
        this.discount = discount;
    }

    public boolean isDonationFlag() {
        return flagged_donation;
    }

    public void setDonationFlag(boolean flagged_donation) {
        this.flagged_donation = flagged_donation;
    }
}
