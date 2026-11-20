package dao;

import com.mysql.cj.jdbc.MysqlDataSource;
import java.sql.Connection;
import java.sql.SQLException;

public abstract class DAO5 {
    private static final MysqlDataSource DATA_SOURCE = createDataSource();

    protected Connection getConnection() throws SQLException {
        return DATA_SOURCE.getConnection();
    }

    private static MysqlDataSource createDataSource() {
        MysqlDataSource dataSource = new MysqlDataSource();
        dataSource.setURL(setting("cineman.db.url", "CINEMAN_DB_URL",
                "jdbc:mysql://127.0.0.1:3306/cineman"));
        dataSource.setUser(setting("cineman.db.user", "CINEMAN_DB_USER", "cineman_app"));
        dataSource.setPassword(setting("cineman.db.password", "CINEMAN_DB_PASSWORD", ""));
        return dataSource;
    }

    private static String setting(String property, String variable, String fallback) {
        String value = System.getProperty(property);
        if (value == null) {
            value = System.getenv(variable);
        }
        return value == null ? fallback : value;
    }
}
