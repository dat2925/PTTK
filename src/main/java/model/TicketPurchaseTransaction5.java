package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class TicketPurchaseTransaction5 {
    private static final DateTimeFormatter DATE_TIME = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    private final int id;
    private final String transactionCode;
    private final LocalDateTime transactionDateTime;
    private final String purchaseChannel;
    private final Customer5 customer;
    private final long ticketCount;
    private final BigDecimal totalAmount;

    public TicketPurchaseTransaction5(int id, String transactionCode, LocalDateTime transactionDateTime,
                                       String purchaseChannel, Customer5 customer, long ticketCount,
                                       BigDecimal totalAmount) {
        this.id = id;
        this.transactionCode = transactionCode;
        this.transactionDateTime = transactionDateTime;
        this.purchaseChannel = purchaseChannel;
        this.customer = customer;
        this.ticketCount = ticketCount;
        this.totalAmount = totalAmount;
    }

    public int getId() { return id; }
    public String getTransactionCode() { return transactionCode; }
    public LocalDateTime getTransactionDateTime() { return transactionDateTime; }
    public String getPurchaseChannel() { return purchaseChannel; }
    public Customer5 getCustomer() { return customer; }
    public long getTicketCount() { return ticketCount; }
    public BigDecimal getTotalAmount() { return totalAmount; }

    public String getDisplayDateTime() {
        return DATE_TIME.format(transactionDateTime);
    }

    public String getDisplayChannel() {
        return switch (purchaseChannel) {
            case "ONLINE" -> "Trực tuyến";
            case "COUNTER" -> "Tại quầy";
            default -> purchaseChannel;
        };
    }
}
