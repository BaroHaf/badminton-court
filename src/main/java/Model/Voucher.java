package Model;

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

    public long calculateDiscount(long amount) {
        if (type == VoucherType.PERCENTAGE){
            return amount * discount;
        } else {
            return amount - discount;
        }
    }
}
