// File: UserBusinessLogic.java
package businesslayer;

import dataaccesslayer.UserDaoImpl;
import model.User;

public class UserBusinessLogic {

    private UserDaoImpl userDao = null;

    public UserBusinessLogic() {
        userDao = new UserDaoImpl();
    }

    public void addUser(User user) {
        userDao.addUser(user);
    }

    public User authenticateUser(String email, String password) {
        return userDao.authenticateUser(email, password);
    }
}
