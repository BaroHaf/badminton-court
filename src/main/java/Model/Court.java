package Model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "courts")
public class Court extends DistributedEntity {
    @Column(nullable = false)
    private String name;

    private boolean isAvailable;
    private double pricePerHour;
    @ManyToOne
    @JoinColumn(name = "venue_id", nullable = false)
    private Venue venue;
    private boolean deleted;
}
