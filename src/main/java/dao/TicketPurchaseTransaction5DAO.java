package dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Customer5;
import model.TicketPurchaseTransaction5;

public class TicketPurchaseTransaction5DAO extends DAO5 {
    public TicketPurchaseTransaction5[] getCustomerTransactions(int customerId, LocalDate startDate,
                                                               LocalDate endDate) throws SQLException {
        List<TicketPurchaseTransaction5> transactions = new ArrayList<>();
        try (Connection connection = getConnection();
             CallableStatement query = connection.prepareCall("{call getCustomerTransactions(?, ?, ?)}")) {
            query.setInt(1, customerId);
            query.setDate(2, Date.valueOf(startDate));
            query.setDate(3, Date.valueOf(endDate));
            try (ResultSet rows = query.executeQuery()) {
                while (rows.next()) {
                    Customer5 customer = new Customer5(rows.getInt("customerId"), rows.getString("customerName"));
                    transactions.add(new TicketPurchaseTransaction5(
                            rows.getInt("id"), rows.getString("transactionCode"),
                            rows.getObject("transactionDateTime", LocalDateTime.class),
                            rows.getString("purchaseChannel"), customer, rows.getLong("ticketCount"),
                            rows.getBigDecimal("totalAmount")));
                }
            }
        }
        return transactions.toArray(TicketPurchaseTransaction5[]::new);
    }
}
