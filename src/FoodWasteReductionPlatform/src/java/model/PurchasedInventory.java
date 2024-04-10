
package model;

/**
 *
 * @author Ahmad
 */
public class PurchasedInventory extends Inventory {
    private String purchase_date;

    public String getPurchase_date() {
        return purchase_date;
    }

    public void setPurchase_date(String purchase_date) {
        this.purchase_date = purchase_date;
    }
}
