package edu.oregonstate.backend;

/**
 * Created by Vee on 3/24/2016.
 */

import java.security.MessageDigest;
import java.util.List;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

@PersistenceCapable
public class User {
    @PrimaryKey
    @Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
    private Long id;

    @Persistent
    private String username;

    @Persistent
    private String password;

    public Long getID() {
        return id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    private static String hash(String str) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update("asljf".getBytes("UTF-16")); // any string unique to your
            // application
            md.update(str.getBytes("UTF-16"));
            byte[] bytes = md.digest();
            StringBuffer rv = new StringBuffer();
            for (int i = 0; i < bytes.length; i++)
                rv.append(Integer.toString(bytes[i], 16));
            return rv.toString();
        } catch (Exception rethrowThis) {
            throw new IllegalStateException(rethrowThis);
        }
    }

    public static User createAccount(String username, String password) {
        User user = new User();
        user.setUsername(username);
        user.setPassword(hash(password));
        return user;
    }

    @SuppressWarnings("unchecked")
    public static User loadAccount(String username, String password,
                                   PersistenceManager pm) {
        Query query = pm.newQuery(User.class,
                "username == :uu && password == :pp");
        List<User> tmp = (List<User>) query.execute(username, hash(password));
        User rv = tmp != null && tmp.size() > 0 ? tmp.get(0) : null;
        query.closeAll();
        return rv;
    }

    @SuppressWarnings("unchecked")
    public static boolean usernameExists(String username, PersistenceManager pm) {
        Query query = pm.newQuery(User.class, "username == :uu");
        List<User> tmp = (List<User>) query.execute(username);
        boolean rv = tmp != null && tmp.size() > 0;
        query.closeAll();
        return rv;
    }
}
