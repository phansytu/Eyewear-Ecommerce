package util;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class EmailUtil {
    // Cấu hình email - thay bằng thông tin thật của bạn
    private static final String FROM_EMAIL = "phansytu24@gmail.com";
    private static final String FROM_PASSWORD = "jtqvxxgcwqqdkgys"; // Dùng App Password cho Gmail
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    
    public static boolean sendEmail(String toEmail, String subject, String body) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, FROM_PASSWORD);
            }
        });
        
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(body, "text/html; charset=utf-8");
            
            Transport.send(message);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Tạo nội dung email OTP
    public static String getOtpEmailBody(String username, String otp, int expiryMinutes) {
        return "<!DOCTYPE html>" +
               "<html>" +
               "<head><meta charset='UTF-8'></head>" +
               "<body style='font-family: Arial, sans-serif;'>" +
               "<div style='max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 10px;'>" +
               "<h2 style='color: #667eea;'>🔐 Xác thực tài khoản</h2>" +
               "<p>Xin chào <strong>" + username + "</strong>,</p>" +
               "<p>Mã OTP của bạn là:</p>" +
               "<div style='background: #f4f4f4; padding: 15px; text-align: center; font-size: 32px; font-weight: bold; letter-spacing: 5px; border-radius: 5px;'>" +
               otp +
               "</div>" +
               "<p>Mã này có hiệu lực trong <strong>" + expiryMinutes + " phút</strong>.</p>" +
               "<p>Nếu bạn không yêu cầu, vui lòng bỏ qua email này.</p>" +
               "<hr>" +
               "<p style='color: #999; font-size: 12px;'>Cửa hàng kính thời trang</p>" +
               "</div>" +
               "</body>" +
               "</html>";
    }
    
    // Tạo nội dung email reset password
    public static String getResetPasswordEmailBody(String username, String resetLink) {
        return "<!DOCTYPE html>" +
               "<html>" +
               "<head><meta charset='UTF-8'></head>" +
               "<body style='font-family: Arial, sans-serif;'>" +
               "<div style='max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 10px;'>" +
               "<h2 style='color: #667eea;'>🔑 Đặt lại mật khẩu</h2>" +
               "<p>Xin chào <strong>" + username + "</strong>,</p>" +
               "<p>Bạn vừa yêu cầu đặt lại mật khẩu. Nhấp vào nút bên dưới để tiếp tục:</p>" +
               "<div style='text-align: center; margin: 30px 0;'>" +
               "<a href='" + resetLink + "' style='background: #667eea; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px; display: inline-block;'>Đặt lại mật khẩu</a>" +
               "</div>" +
               "<p>Hoặc copy link này vào trình duyệt:</p>" +
               "<p style='word-break: break-all; color: #667eea;'>" + resetLink + "</p>" +
               "<p>Link này có hiệu lực trong 30 phút.</p>" +
               "<hr>" +
               "<p style='color: #999; font-size: 12px;'>Cửa hàng kính thời trang</p>" +
               "</div>" +
               "</body>" +
               "</html>";
    }
}