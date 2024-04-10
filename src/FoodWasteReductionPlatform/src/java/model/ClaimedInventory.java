
package model;

/**
 *
 * @author Ahmad
 */
public class ClaimedInventory extends Inventory {
    private String claim_date;

    public String getClaim_date() {
        return claim_date;
    }

    public void setClaim_date(String claim_date) {
        this.claim_date = claim_date;
    }
}
