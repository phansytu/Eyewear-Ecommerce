package servlet;

import com.google.gson.Gson;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/upload-review-image")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10
)
public class UploadReviewImageServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> result = new HashMap<>();
        
        try {
            Part filePart = request.getPart("image");
            if (filePart == null || filePart.getSize() == 0) {
                result.put("success", false);
                result.put("message", "Vui lòng chọn ảnh!");
                response.getWriter().write(new Gson().toJson(result));
                return;
            }
            
            // Tạo thư mục uploads/reviews
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "reviews";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // Lưu file
            String fileName = UUID.randomUUID().toString() + ".jpg";
            String filePath = uploadPath + File.separator + fileName;
            filePart.write(filePath);
            
            String imageUrl = request.getContextPath() + "/uploads/reviews/" + fileName;
            
            result.put("success", true);
            result.put("url", imageUrl);
            
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi upload: " + e.getMessage());
        }
        
        response.getWriter().write(new Gson().toJson(result));
    }
}