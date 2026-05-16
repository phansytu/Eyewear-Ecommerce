package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

/**
 * ChatbotServlet v2  –  JWT-aware proxy servlet.
 *
 * Flow:
 *   1. User kiểm tra session (đã login chưa?)
 *   2. Lấy access_token từ session
 *   3. Forward request tới Python AI với Authorization header
 *   4. Trả kết quả về JSP
 *
 * Endpoints Python được ủy quyền:
 *   POST /api/chat          → role user + admin
 *   GET  /api/admin/stats   → role admin only (xem ChatbotAdminServlet)
 */
@WebServlet(name = "ChatbotServlet", urlPatterns = {"/chat"})
public class ChatbotServlet extends HttpServlet {

    private static final String PYTHON_BASE_URL =
        System.getenv("PYTHON_AI_URL") != null
            ? System.getenv("PYTHON_AI_URL")
            : "http://localhost:5000";

    private static final int CONNECT_TIMEOUT = 5_000;
    private static final int READ_TIMEOUT    = 30_000;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── 1. Lấy JWT từ session ──────────────────────────
        HttpSession session = request.getSession(false);
        String accessToken  = (session != null) ? (String) session.getAttribute("access_token") : null;

        if (accessToken == null || accessToken.isBlank()) {
            sendJson(response, HttpServletResponse.SC_UNAUTHORIZED,
                     "{\"error\":\"Vui lòng đăng nhập để sử dụng chatbot\"}");
            return;
        }

        // ── 2. Đọc body từ request ─────────────────────────
        String body = readBody(request);
        if (body == null || body.isBlank() || !body.contains("\"message\"")) {
            sendJson(response, HttpServletResponse.SC_BAD_REQUEST,
                     "{\"error\":\"Thiếu trường message\"}");
            return;
        }

        // ── 3. Gọi Python AI ───────────────────────────────
        String aiResult = callPython(PYTHON_BASE_URL + "/api/chat", body, accessToken);
        if (aiResult == null) {
            sendJson(response, HttpServletResponse.SC_SERVICE_UNAVAILABLE,
                     "{\"error\":\"AI service không phản hồi. Vui lòng thử lại sau.\"}");
            return;
        }

        sendJson(response, HttpServletResponse.SC_OK, aiResult);
    }

    /** Gọi Python endpoint với Bearer token. */
    private String callPython(String endpoint, String body, String token) {
        HttpURLConnection conn = null;
        try {
            URL url = new URL(endpoint);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setRequestProperty("Accept", "application/json");
            conn.setRequestProperty("Authorization", "Bearer " + token);
            conn.setConnectTimeout(CONNECT_TIMEOUT);
            conn.setReadTimeout(READ_TIMEOUT);
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(body.getBytes(StandardCharsets.UTF_8));
            }

            int status = conn.getResponseCode();
            InputStream is = (status >= 400) ? conn.getErrorStream() : conn.getInputStream();
            if (is == null) return null;

            StringBuilder sb = new StringBuilder();
            try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
                String line;
                while ((line = br.readLine()) != null) sb.append(line);
            }
            return sb.toString();

        } catch (Exception e) {
            log("ChatbotServlet error: " + e.getMessage());
            return null;
        } finally {
            if (conn != null) conn.disconnect();
        }
    }

    private String readBody(HttpServletRequest req) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(req.getInputStream(), StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null) sb.append(line);
        }
        return sb.toString();
    }

    private void sendJson(HttpServletResponse resp, int status, String json) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.setStatus(status);
        try (PrintWriter out = resp.getWriter()) {
            out.print(json);
        }
    }
}
