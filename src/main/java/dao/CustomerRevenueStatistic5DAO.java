package dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import model.CustomerRevenueStatistic5;

public class CustomerRevenueStatistic5DAO extends DAO5 {
    public CustomerRevenueStatistic5[] getCustomerRevenue(LocalDate startDate, LocalDate endDate)
            throws SQLException {
        List<CustomerRevenueStatistic5> statistics = new ArrayList<>();
        try (Connection connection = getConnection();
             CallableStatement query = connection.prepareCall("{call getCustomerRevenue(?, ?)}")) {
            query.setDate(1, Date.valueOf(startDate));
            query.setDate(2, Date.valueOf(endDate));
            try (ResultSet rows = query.executeQuery()) {
                while (rows.next()) {
                    statistics.add(new CustomerRevenueStatistic5(
                            rows.getInt("customerId"), rows.getString("customerName"),
                            rows.getBigDecimal("totalAmount"), rows.getLong("totalTransaction"),
                            rows.getLong("totalTicket")));
                }
            }
        }
        return statistics.toArray(CustomerRevenueStatistic5[]::new);
    }
}
