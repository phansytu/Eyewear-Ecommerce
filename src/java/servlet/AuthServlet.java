package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;

/**
 * AuthServlet  –  Proxy đăng nhập / đăng xuất tới Python Auth API.
 *
 * POST /auth?action=login    → gọi Python /api/auth/login, lưu token vào session
 * POST /auth?action=register → gọi Python /api/auth/register
 * GET  /auth?action=logout   → xóa session
 */
@WebServlet(name = "AuthServlet", urlPatterns = {"/auth"})
public class AuthServlet extends HttpServlet {

    private static final String PYTHON_BASE =
        System.getenv("PYTHON_AI_URL") != null
            ? System.getenv("PYTHON_AI_URL")
            : "http://localhost:5000";

    private static final int CONNECT_TIMEOUT = 5_000;
    private static final int READ_TIMEOUT    = 10_000;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "login"    -> handleLogin(request, response);
            case "register" -> handleRegister(request, response);
            default         -> sendJson(response, 400, "{\"error\":\"action không hợp lệ\"}");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }

    // ── Login ──────────────────────────────────────────────
    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String body = readBody(request);
        String pythonResp = callPython(PYTHON_BASE + "/api/auth/login", "POST", body, null);

        if (pythonResp == null) {
            sendJson(response, 503, "{\"error\":\"Dịch vụ xác thực không khả dụng\"}");
            return;
        }

        // Parse access_token, refresh_token, role từ JSON đơn giản
        // (Dùng regex thủ công để tránh thêm thư viện JSON vào servlet)
        String accessToken  = extractJsonStr(pythonResp, "access_token");
        String refreshToken = extractJsonStr(pythonResp, "refresh_token");
        String role         = extractJsonStr(pythonResp, "role");

        if (accessToken != null) {
            // Lưu vào HTTP session (server-side, an toàn hơn localStorage)
            HttpSession session = request.getSession(true);
            session.setAttribute("access_token",  accessToken);
            session.setAttribute("refresh_token", refreshToken);
            session.setAttribute("role",          role != null ? role : "user");
            session.setMaxInactiveInterval(
                "admin".equals(role) ? 1800 : 3600   // admin: 30 phút, user: 1 giờ
            );
            sendJson(response, 200, "{\"success\":true,\"role\":\"" + safeRole(role) + "\"}");
        } else {
            // Forward error từ Python (401 / 422…)
            sendJson(response, 401, pythonResp);
        }
    }

    // ── Register ───────────────────────────────────────────
    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String body = readBody(request);
        String pythonResp = callPython(PYTHON_BASE + "/api/auth/register", "POST", body, null);

        if (pythonResp == null) {
            sendJson(response, 503, "{\"error\":\"Dịch vụ đăng ký không khả dụng\"}");
            return;
        }
        sendJson(response, 200, pythonResp);
    }

    // ── HTTP helper ────────────────────────────────────────
    private String callPython(String endpoint, String method, String body, String token) {
        HttpURLConnection conn = null;
        try {
            URL url = new URL(endpoint);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod(method);
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setRequestProperty("Accept", "application/json");
            if (token != null) conn.setRequestProperty("Authorization", "Bearer " + token);
            conn.setConnectTimeout(CONNECT_TIMEOUT);
            conn.setReadTimeout(READ_TIMEOUT);
            if (body != null) {
                conn.setDoOutput(true);
                try (OutputStream os = conn.getOutputStream()) {
                    os.write(body.getBytes(StandardCharsets.UTF_8));
                }
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
            log("AuthServlet error: " + e.getMessage());
            return null;
        } finally {
            if (conn != null) conn.disconnect();
        }
    }

    // ── Utilities ──────────────────────────────────────────
    private String readBody(HttpServletRequest req) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(req.getInputStream(), StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null) sb.append(line);
        }
        return sb.toString();
    }

    /** Minimal JSON string extractor – avoids dependency on Jackson in servlet. */
    private String extractJsonStr(String json, String key) {
        String search = "\"" + key + "\":\"";
        int start = json.indexOf(search);
        if (start == -1) return null;
        start += search.length();
        int end = json.indexOf("\"", start);
        return end == -1 ? null : json.substring(start, end);
    }

    private String safeRole(String role) {
        if ("admin".equals(role)) return "admin";
        return "user";
    }

    private void sendJson(HttpServletResponse resp, int status, String json) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.setStatus(status);
        try (PrintWriter out = resp.getWriter()) { out.print(json); }
    }
}
