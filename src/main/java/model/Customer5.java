package model;

import java.util.Locale;

public class Customer5 extends Member5 {
    public Customer5(int id, String name) {
        super(id, name, "CUSTOMER");
    }

    public String getCode() {
        return String.format(Locale.ROOT, "KH%03d", getId());
    }
}
