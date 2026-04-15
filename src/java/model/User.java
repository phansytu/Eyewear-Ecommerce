package model;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
import java.sql.Timestamp;
/**
 *
 * @author Admin
 */
public class User {
    private int id;
    private String username;
    private String email;
    private String password;
    private String role;
    private Timestamp createAt;
    private String phone;
    private String full_name;
    private int loginAttempts;
    private Timestamp lockedUntil;
    private String status;
    private Timestamp lastLogin;
     private String resetToken;
    private Timestamp resetTokenExpiry;

    public User() {
    }

    public User(int id, String username, String email, String password, String role, Timestamp createAt, String phone, String full_name, int loginAttempts, Timestamp lockedUntil, String status, Timestamp lastLogin, String resetToken, Timestamp resetTokenExpiry) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.password = password;
        this.role = role;
        this.createAt = createAt;
        this.phone = phone;
        this.full_name = full_name;
        this.loginAttempts = loginAttempts;
        this.lockedUntil = lockedUntil;
        this.status = status;
        this.lastLogin = lastLogin;
        this.resetToken = resetToken;
        this.resetTokenExpiry = resetTokenExpiry;
    }

    public int getLoginAttempts() {
        return loginAttempts;
    }

    public void setLoginAttempts(int loginAttempts) {
        this.loginAttempts = loginAttempts;
    }

    public Timestamp getLockedUntil() {
        return lockedUntil;
    }

    public void setLockedUntil(Timestamp lockedUntil) {
        this.lockedUntil = lockedUntil;
    }

    

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Timestamp getCreateAt() {
        return createAt;
    }

    public void setCreateAt(Timestamp createAt) {
        this.createAt = createAt;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getFull_name() {
        return full_name;
    }

    public void setFull_name(String full_name) {
        this.full_name = full_name;
    }
    public String getStatus(){
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(Timestamp lastLogin) {
        this.lastLogin = lastLogin;
    }

    public String getResetToken() {
        return resetToken;
    }

    public void setResetToken(String resetToken) {
        this.resetToken = resetToken;
    }

    public Timestamp getResetTokenExpiry() {
        return resetTokenExpiry;
    }

    public void setResetTokenExpiry(Timestamp resetTokenExpiry) {
        this.resetTokenExpiry = resetTokenExpiry;
    }
    public boolean isAdmin() {
        return "admin".equals(role);
    }
    
    public boolean isLocked() {
        if (lockedUntil == null) return false;
        return lockedUntil.after(new Timestamp(System.currentTimeMillis()));
    }
    

    
    
    
    
}
