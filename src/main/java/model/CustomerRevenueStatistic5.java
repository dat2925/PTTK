package model;

import java.math.BigDecimal;

public class CustomerRevenueStatistic5 extends Customer5 {
    private final BigDecimal totalAmount;
    private final long totalTransaction;
    private final long totalTicket;

    public CustomerRevenueStatistic5(int id, String name, BigDecimal totalAmount,
                                     long totalTransaction, long totalTicket) {
        super(id, name);
        this.totalAmount = totalAmount;
        this.totalTransaction = totalTransaction;
        this.totalTicket = totalTicket;
    }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public long getTotalTransaction() { return totalTransaction; }
    public long getTotalTicket() { return totalTicket; }
}
