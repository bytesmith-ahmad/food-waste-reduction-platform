package businesslayer;

import dataaccesslayer.InventoryDaoImpl;
import java.util.List;
import model.ClaimedInventory;
import model.Inventory;
import model.PurchasedInventory;
import model.User;

public class InventoryBusinessLogic {

    private InventoryDaoImpl inventoryDao = null;

    public InventoryBusinessLogic() {
        inventoryDao = new InventoryDaoImpl();
    }

    public void addInventoryItem(Inventory item) {
        inventoryDao.addInventoryItem(item);
    }

    public List<Inventory> getInventory(User user) {
        String userType = user.getUserType();
        if(userType.equalsIgnoreCase("retailer")){
            return inventoryDao.getInventoryByRetailer(user.getId());
        }else if(userType.equalsIgnoreCase("charitable_organization")){
            return inventoryDao.getInventoryForOrg();
        }
        else{
            return inventoryDao.getInventory();
        }
    }
    public List<ClaimedInventory> getClaimedItems(int orgId) {
        return inventoryDao.getClaimedItems(orgId);
    }
    public List<PurchasedInventory> getPurchasedItems(int consumerId) {
        return inventoryDao.getPurchasedItems(consumerId);
    }
    
    public boolean updateInventoryQuantity(int itemId, int quantityToAdd) {
            return inventoryDao.updateQuantity(itemId, quantityToAdd);
    }

    public boolean flagInventoryItemForDiscount(int itemId, double discountAmount) {
            return inventoryDao.flagItemDiscount(itemId, discountAmount);
    }

    public boolean markAsSurplus(int itemId) {
        return inventoryDao.markAsSurplus(itemId);
    }

    public boolean markForDonation(int itemId) {
        return inventoryDao.markForDonation(itemId);
    }

    public void claimAsDonation(int itemId, int orgId) {
         inventoryDao.claimAsDonation(itemId,orgId);
    }

    public void purchaseItem(int consumerId, int itemId, int quantityToPurchase) {
         inventoryDao.purchaseItem(consumerId,itemId,quantityToPurchase);
    }
}
