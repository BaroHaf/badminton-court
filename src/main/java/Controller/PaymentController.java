package Controller;

import Dao.BookingDao;
import Dao.PaymentDao;
import Dao.VoucherDao;
import Model.Booking;
import Model.Constant.BookingStatus;
import Model.Constant.TransactionStatus;
import Model.Payment;
import Model.User;
import Model.Voucher;
import Util.Util;
import Util.VNPayUtil;
import Util.Config;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

public class PaymentController {
    @WebServlet("/customer/payment")
    public static class PaymentServlet extends HttpServlet {
        public static long getAmount(List<Booking> bookings){
            long amount = 0;
            for (int i = 0; i < bookings.size(); i++) {
                amount += (long) (bookings.get(i).getCourt().getPricePerHour() * Util.calculateHourDifference(bookings.get(i).getStartTime(), bookings.get(i).getEndTime()));
            }
            return amount;
        }
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            long[] ids = Arrays.stream(req.getParameter("ids").split(",")).mapToLong(Long::parseLong).toArray();
            User user = (User) req.getSession().getAttribute("user");
            List<Booking> bookings = new BookingDao().getBookingsIn(ids);
            String voucherCode = req.getParameter("voucherCode");
            String vnp_Version = "2.1.0";
            String vnp_Command = "pay";
            String orderType = "other";
            long amount = getAmount(bookings) * 100L;
            boolean check = true;
            Voucher voucher = null;
            if (!voucherCode.isEmpty()){
                 voucher = new VoucherDao().findByCodeNotDisable(voucherCode);
                if (voucher != null) {
                    if (user.getRank().ordinal() < voucher.getForRank().ordinal()){
                        check = false;
                    } else {
                        amount = voucher.calculateDiscount(amount);
                    }
                } else {
                    check = false;
                }
            }
            if (check){
                String bankCode = req.getParameter("bankCode");
                String vnp_TxnRef = VNPayUtil.getRandomNumber(8);
                String vnp_IpAddr = VNPayUtil.getIpAddress(req);
                String vnp_TmnCode = Config.vnp_TmnCode;
                Map<String, String> vnp_Params = new HashMap<>();
                vnp_Params.put("vnp_Version", vnp_Version);
                vnp_Params.put("vnp_Command", vnp_Command);
                vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
                vnp_Params.put("vnp_Amount", String.valueOf(amount));
                vnp_Params.put("vnp_CurrCode", "VND");
                if (bankCode != null && !bankCode.isEmpty()) {
                    vnp_Params.put("vnp_BankCode", bankCode);
                }
                vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
                String vnp_OrderInfo = UUID.randomUUID() + "-" + System.currentTimeMillis() + "|" + req.getParameter("ids");
                vnp_Params.put("vnp_OrderInfo", vnp_OrderInfo);
                vnp_Params.put("vnp_OrderType", orderType);
                String locate = req.getParameter("language");
                if (locate != null && !locate.isEmpty()) {
                    vnp_Params.put("vnp_Locale", locate);
                } else {
                    vnp_Params.put("vnp_Locale", "vn");
                }
                vnp_Params.put("vnp_ReturnUrl", Config.vnp_ReturnUrl);
                vnp_Params.put("vnp_IpAddr", vnp_IpAddr);
                Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
                SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
                String vnp_CreateDate = formatter.format(cld.getTime());
                vnp_Params.put("vnp_CreateDate", vnp_CreateDate);
                cld.add(Calendar.MINUTE, 15);
                String vnp_ExpireDate = formatter.format(cld.getTime());
                vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);
                List fieldNames = new ArrayList(vnp_Params.keySet());
                Collections.sort(fieldNames);
                StringBuilder hashData = new StringBuilder();
                StringBuilder query = new StringBuilder();
                Iterator itr = fieldNames.iterator();
                while (itr.hasNext()) {
                    String fieldName = (String) itr.next();
                    String fieldValue = vnp_Params.get(fieldName);
                    if ((fieldValue != null) && (!fieldValue.isEmpty())) {
                        hashData.append(fieldName);
                        hashData.append('=');
                        hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
                        query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII));
                        query.append('=');
                        query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
                        if (itr.hasNext()) {
                            query.append('&');
                            hashData.append('&');
                        }
                    }
                }
                String queryUrl = query.toString();
                String vnp_SecureHash = VNPayUtil.hmacSHA512(Config.secretKey, hashData.toString());
                queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
                Payment payment = new Payment();
                payment.setAmount(amount/100);
                payment.setTxnRef(vnp_TxnRef);
                payment.setOrderInfo(vnp_OrderInfo);
                if (voucher != null) {
                    payment.setVoucherCode(voucher.getCode());
                    payment.setVoucherDiscount(voucher.getDiscount());
                    payment.setDiscountAmount(getAmount(bookings)  - amount / 100);
                }
                new PaymentDao().save(payment);
                String paymentUrl = Config.vnp_PayUrl + "?" + queryUrl;
                resp.sendRedirect(paymentUrl);
            } else {
                req.getSession().setAttribute("warning", "Mã giảm giá không tồn tại, hoặc bạn không thể dùng mã này.");
                resp.sendRedirect(req.getHeader("referer"));
            }

        }
    }

    @WebServlet("/vnpay-result")
    public static class PaymentResultServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            BookingDao bookingDao = new BookingDao();
            PaymentDao paymentDao = new PaymentDao();
            Map<String, String> fields = new HashMap<>();
            for (Enumeration<?> params = req.getParameterNames(); params.hasMoreElements(); ) {
                String fieldName = URLEncoder.encode((String) params.nextElement(), StandardCharsets.US_ASCII.toString());
                String fieldValue = URLEncoder.encode(req.getParameter(fieldName), StandardCharsets.US_ASCII.toString());
                if ((fieldValue != null) && (!fieldValue.isEmpty())) {
                    fields.put(fieldName, fieldValue);
                }
            }
            fields.remove("vnp_SecureHashType");
            fields.remove("vnp_SecureHash");
            String signValue = VNPayUtil.hashAllFields(fields);
            if (signValue.equals(req.getParameter("vnp_SecureHash"))){
                SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
                SimpleDateFormat sqlFormatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                String paid_at = req.getParameter("vnp_PayDate");
                String vnp_OrderInfo = req.getParameter("vnp_OrderInfo");
                Payment payment = paymentDao.findByOrderInfo(vnp_OrderInfo);
                if (payment != null) {
                    if (payment.transactionStatus == null){
                        String vnp_TransactionStatus = req.getParameter("vnp_TransactionStatus");
                        String vnp_TransactionNo = req.getParameter("vnp_TransactionNo");
                        String vnp_BankTranNo = req.getParameter("vnp_BankTranNo");
                        String vnp_CardType = req.getParameter("vnp_CardType");
                        String vnp_BankCode = req.getParameter("vnp_BankCode");
                        payment.setBankCode(vnp_BankCode);
                        payment.setTransactionNo(vnp_TransactionNo);
                        payment.setTransactionStatus(TransactionStatus.fromCode(vnp_TransactionStatus));
                        payment.setCardType(vnp_CardType);
                        payment.setBankTranNo(vnp_BankTranNo);
                        long[] booking_ids = Arrays.stream(vnp_OrderInfo.split("\\|")[1].split(",")).mapToLong(Long::parseLong).toArray();
                        List<Booking> bookings = bookingDao.getBookingsIn(booking_ids);
                        if (payment.transactionStatus == TransactionStatus.SUCCESS){
                            for (Booking booking : bookings) {
                                booking.setStatus(BookingStatus.CONFIRMED);
                                booking.setPayment(payment);
                                booking.setAmount(booking.getCourt().getPricePerHour() * Util.calculateHourDifference(booking.getStartTime(), booking.getEndTime()));
                            }
                            bookingDao.updateAll(bookings);
                            payment.setBookings(bookings);
                        }
                        try {
                            payment.setPaid_at(Timestamp.valueOf(sqlFormatter.format(formatter.parse(paid_at))));
                        } catch (ParseException e) {
                            throw new RuntimeException(e);
                        }
                        paymentDao.update(payment);
                        if (payment.transactionStatus == TransactionStatus.SUCCESS){
                            req.getSession().setAttribute("success", "Thanh toán thành công.");
                        } else {
                            req.getSession().setAttribute("warning", "Thanh toán không thành công.");
                        }
                    } else {
                        req.getSession().setAttribute("warning", "Vui lòng không spam");
                    }
                } else {
                    req.getSession().setAttribute("warning", "Giao dịch không tồn tại");
                }
            } else {
                req.getSession().setAttribute("warning", "Mã băm không khớp");
            }
            resp.sendRedirect(req.getContextPath() + "/customer/bookings");
        }
    }
}
