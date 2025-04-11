package Model;

import Util.Util;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalTime;
import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Entity
@ToString
@Table(name = "venues")
public class Venue extends DistributedEntity {
    @Column(nullable = false, columnDefinition = "NVARCHAR(255)")
    private String name;

    private String normalizedName;

    @Column(nullable = false, columnDefinition = "NVARCHAR(255)")
    private String address;

    private String normalizedAddress;

    private String image;
    private LocalTime openTime;
    private LocalTime closeTime;
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User owner;

    @OneToMany(mappedBy = "venue", cascade = CascadeType.ALL)
    private List<Court> courts;

    private boolean deleted;

    public Venue(String name, String address, String image, LocalTime openTime, LocalTime closeTime, User user) {
        this.name = name;
        this.normalizedName = Util.removeAccents(name);
        this.address = address;
        this.normalizedAddress = Util.removeAccents(address);
        this.image = image;
        this.openTime = openTime;
        this.closeTime = closeTime;
        this.owner = user;
    }
}
