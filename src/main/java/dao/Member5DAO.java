package dao;

import java.security.GeneralSecurityException;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import model.Customer5;
import model.Member5;

public class Member5DAO extends DAO5 {
    private static final String LOGIN = """
        SELECT id, name, role, authenticationInfo
        FROM tblMember5
        WHERE username = ? AND role IN ('CUSTOMER', 'MANAGER')
        """;
    private static final String CUSTOMER = """
        SELECT m.id, m.name
        FROM tblCustomer5 c
        JOIN tblMember5 m ON m.id = c.memberId
        WHERE c.memberId = ?
        """;

    public Member5 authenticate(String username, String password) throws SQLException {
        try (Connection connection = getConnection();
             PreparedStatement query = connection.prepareStatement(LOGIN)) {
            query.setString(1, username);
            try (ResultSet row = query.executeQuery()) {
                if (row.next() && matches(password, row.getString("authenticationInfo"))) {
                    return new Member5(row.getInt("id"), row.getString("name"), row.getString("role"));
                }
                return null;
            }
        }
    }

    public Customer5 findCustomer(int id) throws SQLException {
        try (Connection connection = getConnection();
             PreparedStatement query = connection.prepareStatement(CUSTOMER)) {
            query.setInt(1, id);
            try (ResultSet row = query.executeQuery()) {
                return row.next() ? new Customer5(row.getInt("id"), row.getString("name")) : null;
            }
        }
    }

    private boolean matches(String password, String storedHash) {
        String[] parts = storedHash.split(":");
        if (parts.length != 3) {
            return false;
        }

        try {
            int iterations = Integer.parseInt(parts[0]);
            byte[] salt = Base64.getDecoder().decode(parts[1]);
            byte[] expected = Base64.getDecoder().decode(parts[2]);
            if (iterations < 100000 || iterations > 1000000 || salt.length < 16 || expected.length != 32) {
                return false;
            }
            PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, iterations, 256);
            try {
                byte[] actual = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256").generateSecret(spec).getEncoded();
                return MessageDigest.isEqual(expected, actual);
            } finally {
                spec.clearPassword();
            }
        } catch (GeneralSecurityException | IllegalArgumentException ex) {
            return false;
        }
    }
}
