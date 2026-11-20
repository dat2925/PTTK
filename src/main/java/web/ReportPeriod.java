package web;

import jakarta.servlet.http.HttpServletRequest;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

public record ReportPeriod(LocalDate startDate, LocalDate endDate) {
    private static final DateTimeFormatter DISPLAY_DATE = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    public static ReportPeriod from(String start, String end) {
        if (WebSupport.trim(start).isEmpty() || WebSupport.trim(end).isEmpty()) {
            throw new IllegalArgumentException("Vui lòng nhập ngày bắt đầu và ngày kết thúc.");
        }
        try {
            LocalDate first = LocalDate.parse(start);
            LocalDate last = LocalDate.parse(end);
            if (first.isAfter(last)) {
                throw new IllegalArgumentException("Ngày kết thúc phải từ ngày bắt đầu trở đi.");
            }
            if (first.getYear() < 1000 || last.getYear() > 9999) {
                throw new IllegalArgumentException("Khoảng ngày nằm ngoài giới hạn của CSDL.");
            }
            return new ReportPeriod(first, last);
        } catch (DateTimeParseException ex) {
            throw new IllegalArgumentException("Ngày không hợp lệ. Vui lòng chọn lại khoảng ngày.");
        }
    }

    public String displayStart() { return DISPLAY_DATE.format(startDate); }
    public String displayEnd() { return DISPLAY_DATE.format(endDate); }

    public void expose(HttpServletRequest request) {
        request.setAttribute("startDate", startDate.toString());
        request.setAttribute("endDate", endDate.toString());
        request.setAttribute("displayStart", displayStart());
        request.setAttribute("displayEnd", displayEnd());
    }
}
