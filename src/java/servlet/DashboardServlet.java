package servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// Đường dẫn ảo mà bạn sẽ dùng trong thẻ <a>
@WebServlet("/admin/dashboard") 
public class DashboardServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Tại đây bạn có thể lấy dữ liệu thống kê để hiển thị lên Dashboard
        // Ví dụ: request.setAttribute("totalProducts", productDAO.count());
        
        // Chuyển hướng đến file JSP thực tế nằm trong thư mục của bạn
        request.getRequestDispatcher("/jsp/admin/dashboard.jsp").forward(request, response);
    }
}