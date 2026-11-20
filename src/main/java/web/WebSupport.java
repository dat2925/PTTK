package web;

import jakarta.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.HexFormat;

public final class WebSupport {
    private static final SecureRandom RANDOM = new SecureRandom();

    private WebSupport() {}

    public static String trim(String value) {
        return value == null ? "" : value.strip();
    }

    public static int positiveId(String value) {
        try {
            return Math.max(0, Integer.parseInt(value));
        } catch (NumberFormatException ex) {
            return 0;
        }
    }

    public static String encode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }

    public static String formToken(HttpSession session) {
        synchronized (session) {
            String token = (String) session.getAttribute("formToken");
            if (token == null) {
                byte[] bytes = new byte[32];
                RANDOM.nextBytes(bytes);
                token = HexFormat.of().formatHex(bytes);
                session.setAttribute("formToken", token);
            }
            return token;
        }
    }

    public static boolean validToken(HttpSession session, String submitted) {
        return submitted != null && MessageDigest.isEqual(
                formToken(session).getBytes(StandardCharsets.UTF_8),
                submitted.getBytes(StandardCharsets.UTF_8));
    }
}
