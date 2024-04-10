package businesslayer;

import dataaccesslayer.SubscriptionDaoImpl;
import dataaccesslayer.InventoryDaoImpl;
import java.util.List;
import model.Subscription;

public class SubscriptionBusinessLogic {

    private SubscriptionDaoImpl subscriptionDao = null;
    
    
    public SubscriptionBusinessLogic() {
        subscriptionDao = new SubscriptionDaoImpl();
    }
    
    public void addSubscription(Subscription subscription) {
        subscriptionDao.addSubscription(subscription);
    }
    public List<Subscription> getSubscriptions(int consumerId) {
        return subscriptionDao.getSubscriptions(consumerId);
    }
    
}
