package edu.oregonstate.backend;

/**
 * Created by Vee on 3/24/2016.
 */

//import java.security.MessageDigest;
import java.util.List;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import com.google.appengine.api.datastore.Blob;

@PersistenceCapable
public class Contact {
    @PrimaryKey
    @Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
    private Long id;

    @Persistent
    private String contactname;
    @Persistent
    private String address;
    @Persistent
    private String city;
    @Persistent
    private String state;
    @Persistent
    private String email;
    @Persistent
    private String phonenum;
    @Persistent
    private Blob pic;

    @Persistent
    private Long user;

    public Long getID() {
        return id;
    }

    public String getContactName() {
        return contactname;
    }

    public void setContactName(String contactname) {
        this.contactname = contactname;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }


    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }


    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }


    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNum() {
        return phonenum;
    }

    public void setPhoneNum(String phonenum) {
        this.phonenum = phonenum;
    }

    public byte[] getPhoto() {
        return pic != null ? pic.getBytes() : new byte[0];
    }

    public void setPhoto(byte[] photo) {
        this.pic = new Blob(photo != null ? photo : new byte[0]);
    }

    public Long getUser() {
        return user;
    }

    public void setUser(Long user) {
        this.user = user;
    }

    @SuppressWarnings("unchecked")
    public static List<Contact> loadContacts(Long owner, PersistenceManager pm) {
        Query query;
        List<Contact> rv;
        if (owner == null) {
            query = pm.newQuery(Item.class);
            rv = (List<Contact>) query.execute();
        } else {
            query = pm.newQuery(Item.class, "owner == :oo");
            rv = (List<Contact>) query.execute(owner);
        }
        query.closeAll();
        return rv;
    }
}