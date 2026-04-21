package servlet;

import DAO.OrderDAO;
import model.Order;
import model.OrderDetail;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy thông tin form khách điền
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String paymentMethod = request.getParameter("paymentMethod"); // e.g., 'cod'

        // KHỞI TẠO ĐỐI TƯỢNG ORDER
        Order newOrder = new Order();
        newOrder.setUserId(user.getId()); // ID của người đang login
        newOrder.setTotalAmount(350000); // Lấy giá trị tổng tiền từ Giỏ hàng (Cart) của bạn
        newOrder.setAddress(address);
        newOrder.setPhone(phone);
        newOrder.setPaymentStatus("unpaid");

        // KHỞI TẠO DANH SÁCH CHI TIẾT ĐƠN HÀNG (Lấy từ Giỏ hàng - Cart)
        // Dưới đây là dữ liệu giả lập, bạn thay bằng vòng lặp get giỏ hàng của bạn nhé
        List<OrderDetail> details = new ArrayList<>();
        details.add(new OrderDetail(0, 0, 1, 2, 150000, null)); // Mua 2 Kính ID=1
        details.add(new OrderDetail(0, 0, 3, 1, 50000, null));  // Mua 1 Kính ID=3

        // GỌI DAO ĐỂ LƯU VÀO DATABASE
        OrderDAO orderDAO = new OrderDAO();
        boolean success = orderDAO.placeOrder(newOrder, details);

        if (success) {
            // Xóa giỏ hàng sau khi đặt thành công (nếu có biến cart trong session)
            // session.removeAttribute("cart");
            response.sendRedirect("orders?message=success"); // Trả về trang Đơn mua của Khách (Mình đã code cho bạn ở trên)
        } else {
            response.sendRedirect("checkout.jsp?error=failed");
        }
    }
}