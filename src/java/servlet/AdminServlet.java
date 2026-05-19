<<<<<<< HEAD
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Admin
 */
@WebServlet(name = "AdminServlet", urlPatterns = {"/AdminServlet"})
public class AdminServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AdminServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminServlet at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
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
        processRequest(request, response);
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

=======
package com.eyewear.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;

/**
 * AdminServlet  –  Proxy tới Python /api/admin/*
 *
 * Kiểm tra role=admin trong session TRƯỚC khi forward request.
 * Nếu không có quyền → trả 403 ngay tại Java layer, không cần gọi Python.
 *
 * GET  /admin-api?path=stats         → GET  /api/admin/stats
 * GET  /admin-api?path=products      → GET  /api/admin/products
 * GET  /admin-api?path=logs          → GET  /api/admin/logs
 * POST /admin-api?path=reload        → POST /api/admin/reload
 */
@WebServlet(name = "AdminServlet", urlPatterns = {"/admin-api"})
public class AdminServlet extends HttpServlet {

    private static final String PYTHON_BASE =
        System.getenv("PYTHON_AI_URL") != null
            ? System.getenv("PYTHON_AI_URL")
            : "http://localhost:5000";

    // Whitelist of allowed admin paths (prevent path traversal)
    private static final java.util.Set<String> ALLOWED_PATHS = java.util.Set.of(
        "stats", "products", "logs", "reload"
    );

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        proxyAdmin(request, response, "GET", null);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String body = readBody(request);
        proxyAdmin(request, response, "POST", body);
    }

    private void proxyAdmin(HttpServletRequest request, HttpServletResponse response,
                             String method, String body) throws IOException {

        // ── 1. Session check ──────────────────────────────
        HttpSession session = request.getSession(false);
        if (session == null) {
            sendJson(response, 401, "{\"error\":\"Chưa đăng nhập\"}");
            return;
        }
        String role  = (String) session.getAttribute("role");
        String token = (String) session.getAttribute("access_token");

        if (!"admin".equals(role) || token == null) {
            sendJson(response, 403, "{\"error\":\"Chỉ admin mới có quyền truy cập\"}");
            return;
        }

        // ── 2. Path whitelist ─────────────────────────────
        String path = request.getParameter("path");
        if (path == null || !ALLOWED_PATHS.contains(path)) {
            sendJson(response, 400, "{\"error\":\"path không hợp lệ\"}");
            return;
        }

        // ── 3. Query string forwarding ────────────────────
        String qs    = request.getQueryString();
        String qsClean = qs != null ? qs.replaceAll("path=[^&]*&?", "").replaceAll("&$", "") : "";
        String endpoint = PYTHON_BASE + "/api/admin/" + path + (qsClean.isEmpty() ? "" : "?" + qsClean);

        // ── 4. Forward to Python ──────────────────────────
        String result = callPython(endpoint, method, body, token);
        if (result == null) {
            sendJson(response, 503, "{\"error\":\"Admin service không phản hồi\"}");
            return;
        }
        sendJson(response, 200, result);
    }

    private String callPython(String endpoint, String method, String body, String token) {
        HttpURLConnection conn = null;
        try {
            URL url = new URL(endpoint);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod(method);
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setRequestProperty("Accept", "application/json");
            conn.setRequestProperty("Authorization", "Bearer " + token);
            conn.setConnectTimeout(5_000);
            conn.setReadTimeout(15_000);
            if (body != null && !body.isBlank()) {
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
            log("AdminServlet error: " + e.getMessage());
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
        try (PrintWriter out = resp.getWriter()) { out.print(json); }
    }
>>>>>>> 11d2452 (sau giao dien)
}
