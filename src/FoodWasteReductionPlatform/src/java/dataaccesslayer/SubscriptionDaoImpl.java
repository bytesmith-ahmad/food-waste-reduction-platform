package dataaccesslayer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Subscription;

public class SubscriptionDaoImpl {

    public void addSubscription(Subscription subscription) {
        String sql = "INSERT INTO subscriptions (user_id, location, communication_method, minPrice,maxPrice,minQty,maxQty) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = new DataSource().createConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, subscription.getUserId());
            pstmt.setString(2, subscription.getLocation());
            pstmt.setString(3, subscription.getCommunicationMethod());
            pstmt.setDouble(4, subscription.getMinPrice());
            pstmt.setDouble(5, subscription.getMaxPrice());
            pstmt.setInt(6, subscription.getMinQty());
            pstmt.setInt(7, subscription.getMaxQty());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Subscription> getSubscriptions(int user_id) {
        List<Subscription> subscriptions = new ArrayList<>();
        String sql = "SELECT * FROM subscriptions WHERE user_id="+user_id;
        try (Connection con = new DataSource().createConnection();
             PreparedStatement pstmt = con.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Subscription sub = new Subscription();
                    sub.setId(rs.getInt("subscription_id")); // Assuming there's a setter for user ID
                    sub.setUserId(rs.getInt("user_id")); // Assuming there's a setter for user ID
                    sub.setLocation(rs.getString("location"));
                    sub.setCommunicationMethod(rs.getString("communication_method"));
                    sub.setMinPrice(rs.getDouble("minPrice"));
                    sub.setMaxPrice(rs.getDouble("maxPrice"));
                    sub.setMinQty(rs.getInt("minQty"));
                    sub.setMaxQty(rs.getInt("maxQty"));
                    sub.setSubsciptionDate(rs.getString("subscription_date"));
                    subscriptions.add(sub);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("called");
        return subscriptions;
    }
    
}
