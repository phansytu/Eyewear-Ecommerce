package servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "OrderServlet", urlPatterns = {"/orders"})
public class OrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy tham số tab đang active (Ví dụ: tat_ca, cho_xac_nhan, dang_giao,...)
        String status = request.getParameter("type");
        if (status == null) status = "all";
        
        request.setAttribute("activeTab", status);
        
        // GIẢ LẬP DỮ LIỆU ĐƠN HÀNG (Mock Data) ĐỂ CHẠY GIAO DIỆN SHOPEE
        // (Sau này bạn thay bằng: OrderDAO.getOrdersByUserId(user.getId(), status))
        request.setAttribute("mockShopName", "Mắt Kính Thời Trang Official");
        
        request.getRequestDispatcher("orders.jsp").forward(request, response);
    }
}