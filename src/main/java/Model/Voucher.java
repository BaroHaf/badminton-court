package Model;

import Model.Constant.Rank;
import Model.Constant.VoucherType;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Entity
@Table(name = "vouchers")
public class Voucher extends DistributedEntity{
    @Column(unique = true)
    private String code;
    @Enumerated(EnumType.STRING)
    private VoucherType type;
    private int discount;
    private LocalDate startDate;
    private LocalDate endDate;
    private boolean disabled;
    @Enumerated(EnumType.STRING)
    private Rank forRank;

    public long calculateDiscount(long amount) {
        if (type == VoucherType.PERCENTAGE){
            return amount * ((100 - discount) / 100);
        } else {
            return amount - discount * 100L;
        }
    }
    public long calculateDiscountdisplay(long amount) {
        System.out.println("Amount: " + amount);
        System.out.println("Amount percent: " + Math.round(amount * (1.0 - ((double) discount / 100.0))));
        System.out.println("Amount tien: " + (amount - discount));

        if (type == VoucherType.PERCENTAGE){
            return Math.round(amount * (1.0 - ((double) discount / 100.0)));
        } else {
            return amount - discount;
        }
    }


}
