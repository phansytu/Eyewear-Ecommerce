/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;

import DAO.UserDAO;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;
import model.User;
import util.EmailUtil;
import util.OTPUtil;

/**
 *
 * @author Admin
 */
@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();


    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ForgotPasswordServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ForgotPasswordServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        if(token != null && !token.isEmpty()){
            //xac thuc token va hien thi form dat la mat khau
            User user = userDAO.validateResetToken(token);
            if(user != null){
                request.setAttribute("token", token);
                request.getRequestDispatcher("/resetpassword.jsp").forward(request, response);
                
            } else {
                request.getRequestDispatcher("/forgotpassword.jsp").forward(request, response);
            }
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email =request.getParameter("email");
        response.setContentType("application/json");
        Map<String, Object> jsonResponse = new HashMap<>();
        
        User user = userDAO.getUserByEmail(email);
        if(user == null) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Email khong ton tai trong he thong");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        //tao token va luu vao database
        String token = OTPUtil.generateToken();
        if (userDAO.saveResetToken(user.getId(), token, 30)) {
            String resetLink = request.getScheme() + "://" + request.getServerName() + 
                              ":" + request.getServerPort() + request.getContextPath() + 
                              "/forgot-password?token=" + token;
            
            String emailBody = EmailUtil.getResetPasswordEmailBody(user.getUsername(), resetLink);
            
            if (EmailUtil.sendEmail(email, "Đặt lại mật khẩu - Cửa hàng kính thời trang", emailBody)) {
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Email đặt lại mật khẩu đã được gửi! Vui lòng kiểm tra hộp thư.");
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Gửi email thất bại, vui lòng thử lại sau!");
            }
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Có lỗi xảy ra, vui lòng thử lại!");
        }
        
        response.getWriter().write(new Gson().toJson(jsonResponse));
    
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
