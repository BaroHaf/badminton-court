package Model;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Entity
@Table(name = "products")
public class Product extends DistributedEntity{
    @Column(nullable = false, columnDefinition = "NVARCHAR(255)")
    private String name;
    private double price;
    @ManyToOne
    @JoinColumn(name = "owner_id")
    private User owner;
    private boolean deleted;
}
