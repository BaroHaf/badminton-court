package Model.Constant;

import lombok.Getter;

@Getter
public enum TransactionStatus {
    SUCCESS("00", "Giao dịch thành công"),
    SUSPICIOUS("07", "Trừ tiền thành công, giao dịch nghi ngờ"),
    NOT_REGISTERED("09", "Chưa đăng ký InternetBanking"),
    AUTH_FAIL("10", "Xác thực không đúng quá 3 lần"),
    TIMEOUT("11", "Hết hạn chờ thanh toán"),
    ACCOUNT_LOCKED("12", "Tài khoản bị khóa"),
    OTP_INCORRECT("13", "Sai OTP"),
    CANCELLED("24", "Khách hàng hủy giao dịch"),
    INSUFFICIENT_FUNDS("51", "Không đủ số dư"),
    DAILY_LIMIT_EXCEEDED("65", "Vượt hạn mức trong ngày"),
    BANK_MAINTENANCE("75", "Ngân hàng bảo trì"),
    INCORRECT_PASSWORD("79", "Sai mật khẩu quá số lần cho phép"),
    OTHER("99", "Lỗi khác");

    private final String code;
    private final String description;

    TransactionStatus(String code, String description) {
        this.code = code;
        this.description = description;
    }

    public static TransactionStatus fromCode(String code) {
        for (TransactionStatus status : values()) {
            if (status.code.equals(code)) {
                return status;
            }
        }
        return OTHER;
    }
}
