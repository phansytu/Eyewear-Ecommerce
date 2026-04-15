package servlet;

import DAO.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Category;

@WebServlet("/admin/categories")
public class AdminCategoryServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        CategoryDAO dao = new CategoryDAO();
        List<Category> categories = dao.getAllCategories();
        req.setAttribute("categories", categories);
        req.getRequestDispatcher("/jsp/admin/categories.jsp").forward(req, resp);
    }
}