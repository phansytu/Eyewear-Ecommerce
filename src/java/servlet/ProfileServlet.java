package servlet;

import DAO.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        // Vì profile.jsp nằm ngoài thư mục gốc Web Pages
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Lấy dữ liệu từ form
        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String dob = request.getParameter("dob");

        // Cập nhật đối tượng user hiện tại
        user.setFull_name(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setGender(gender);
        user.setDob(dob);

        // Lưu vào DB
        UserDAO dao = new UserDAO();
        if (dao.updateProfile(user)) {
            session.setAttribute("user", user); // Cập nhật lại session
            request.setAttribute("message", "Cập nhật hồ sơ thành công!");
        } else {
            request.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại.");
        }
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}