package Model;

import Model.Constant.Role;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Entity
@Table(name = "users")
public class User extends DistributedEntity {
    @Column(unique = true, nullable = false)
    private String email;
    @Column(unique = true, nullable = false)
    private String username;
    private String password;
    private String avatar;
    @Column(unique = true, nullable = false)
    private String phone;
    private String token;
    private boolean isVerified;
    private boolean isBlocked;
    @OneToMany(mappedBy = "user")
    private List<Booking> bookings;
    @Enumerated(EnumType.STRING)
    private Role role;

    public User(String email, String username, String password, String phone, Role role, String avatar, boolean isVerified, boolean isBlocked, String token) {
        this.email = email;
        this.username = username;
        this.password = password;
        this.phone = phone;
        this.role = role;
        this.avatar = avatar;
        this.isVerified = isVerified;
        this.isBlocked = isBlocked;
        this.token = token;
    }

    public User(String email, String username, String password, String avatar, String phone, boolean isVerified, boolean isBlocked, Role role) {
        this.email = email;
        this.username = username;
        this.password = password;
        this.avatar = avatar;
        this.phone = phone;
        this.isVerified = isVerified;
        this.isBlocked = isBlocked;
        this.role = role;
    }
}
