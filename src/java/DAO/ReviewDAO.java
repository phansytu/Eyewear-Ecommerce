package DAO;

import model.ProductReview;
import model.ReviewReply;
import util.DBConnect;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {
    
    private Gson gson = new Gson();
    
    /**
     * Lấy danh sách đánh giá theo product_id
     */
    public List<ProductReview> getReviewsByProductId(int productId, int limit, int offset) {
        List<ProductReview> reviews = new ArrayList<>();
        String sql = """
            SELECT r.*, u.username, u.full_name, u.avatar
            FROM product_reviews r
            LEFT JOIN users u ON r.user_id = u.id
            WHERE r.product_id = ? AND r.status = 'approved'
            ORDER BY r.created_at DESC
            LIMIT ? OFFSET ?
            """;
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, limit);
            ps.setInt(3, offset);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                ProductReview review = mapResultSetToReview(rs);
                review.setReply(getReplyByReviewId(review.getId()));
                reviews.add(review);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reviews;
    }
    
    /**
     * Lấy tổng số đánh giá của sản phẩm
     */
    public int getTotalReviewsCount(int productId) {
        String sql = "SELECT COUNT(*) FROM product_reviews WHERE product_id = ? AND status = 'approved'";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Lấy điểm đánh giá trung bình của sản phẩm
     * @param productId ID sản phẩm
     * @return Điểm trung bình (làm tròn 1 chữ số thập phân)
     */
    public double getAverageRating(int productId) {
        String sql = "SELECT COALESCE(AVG(rating), 0) as avg_rating FROM product_reviews WHERE product_id = ? AND status = 'approved'";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                double avg = rs.getDouble("avg_rating");
                // Làm tròn đến 1 chữ số thập phân
                return Math.round(avg * 10) / 10.0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
    
    /**
     * Lấy thống kê đánh giá theo số sao
     */
    public int[] getRatingStatistics(int productId) {
        int[] stats = new int[5]; // 1-5 sao
        String sql = "SELECT rating, COUNT(*) as count FROM product_reviews WHERE product_id = ? AND status = 'approved' GROUP BY rating";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int rating = rs.getInt("rating");
                int count = rs.getInt("count");
                if (rating >= 1 && rating <= 5) {
                    stats[rating - 1] = count;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }
    
    /**
     * Lấy phần trăm đánh giá theo từng mức sao
     */
    public int[] getRatingPercentages(int productId) {
        int total = getTotalReviewsCount(productId);
        int[] stats = getRatingStatistics(productId);
        int[] percentages = new int[5];
        
        if (total > 0) {
            for (int i = 0; i < 5; i++) {
                percentages[i] = (int) Math.round((double) stats[i] / total * 100);
            }
        }
        return percentages;
    }
    
    /**
     * Thêm đánh giá mới
     */
    public boolean addReview(ProductReview review) {
        String sql = "INSERT INTO product_reviews (product_id, user_id, rating, comment, images) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, review.getProductId());
            ps.setInt(2, review.getUserId());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getComment());
            ps.setString(5, review.getImages());
            
            boolean success = ps.executeUpdate() > 0;
            if (success) {
                updateProductRatingStats(review.getProductId());
            }
            return success;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Kiểm tra user đã đánh giá sản phẩm chưa
     */
    public boolean hasUserReviewed(int userId, int productId) {
        String sql = "SELECT COUNT(*) FROM product_reviews WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Lấy đánh giá của user cho sản phẩm
     */
    public ProductReview getUserReview(int userId, int productId) {
        String sql = "SELECT * FROM product_reviews WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToReview(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Lấy phản hồi của review
     */
    private ReviewReply getReplyByReviewId(int reviewId) {
        String sql = """
            SELECT r.*, u.username, u.full_name, u.role
            FROM review_replies r
            LEFT JOIN users u ON r.user_id = u.id
            WHERE r.review_id = ?
            """;
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ReviewReply reply = new ReviewReply();
                reply.setId(rs.getInt("id"));
                reply.setReviewId(rs.getInt("review_id"));
                reply.setUserId(rs.getInt("user_id"));
                reply.setReplyText(rs.getString("reply_text"));
                reply.setCreatedAt(rs.getTimestamp("created_at"));
                reply.setUpdatedAt(rs.getTimestamp("updated_at"));
                reply.setUserName(rs.getString("full_name") != null ? rs.getString("full_name") : rs.getString("username"));
                reply.setUserRole(rs.getString("role"));
                return reply;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Cập nhật thống kê rating cho product
     */
    private void updateProductRatingStats(int productId) {
        String sql = """
            UPDATE products p
            SET p.total_reviews = (
                SELECT COUNT(*) FROM product_reviews WHERE product_id = ? AND status = 'approved'
            ),
            p.average_rating = (
                SELECT COALESCE(AVG(rating), 0) FROM product_reviews WHERE product_id = ? AND status = 'approved'
            )
            WHERE p.id = ?
            """;
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, productId);
            ps.setInt(3, productId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Xóa đánh giá (Admin)
     */
    public boolean deleteReview(int reviewId) {
        String sql = "DELETE FROM product_reviews WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Ẩn/Hiện đánh giá (Admin)
     */
    public boolean updateReviewStatus(int reviewId, String status) {
        String sql = "UPDATE product_reviews SET status = ? WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, reviewId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Thêm phản hồi cho đánh giá (Admin)
     */
    public boolean addReply(ReviewReply reply) {
        String sql = "INSERT INTO review_replies (review_id, user_id, reply_text) VALUES (?, ?, ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reply.getReviewId());
            ps.setInt(2, reply.getUserId());
            ps.setString(3, reply.getReplyText());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private ProductReview mapResultSetToReview(ResultSet rs) throws SQLException {
        ProductReview review = new ProductReview();
        review.setId(rs.getInt("id"));
        review.setProductId(rs.getInt("product_id"));
        review.setUserId(rs.getInt("user_id"));
        review.setRating(rs.getInt("rating"));
        review.setComment(rs.getString("comment"));
        review.setImages(rs.getString("images"));
        review.setCreatedAt(rs.getTimestamp("created_at"));
        review.setUpdatedAt(rs.getTimestamp("updated_at"));
        review.setStatus(rs.getString("status"));
        review.setUserName(rs.getString("full_name") != null ? rs.getString("full_name") : rs.getString("username"));
        review.setUserAvatar(rs.getString("avatar"));
        
        // Parse images JSON
        if (review.getImages() != null && !review.getImages().isEmpty()) {
            try {
                List<String> imageList = gson.fromJson(review.getImages(), new TypeToken<List<String>>(){}.getType());
                review.setImageList(imageList);
            } catch (Exception e) {
                review.setImageList(new ArrayList<>());
            }
        } else {
            review.setImageList(new ArrayList<>());
        }
        
        return review;
    }
}