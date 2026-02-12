package fpl.platform.repository;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import fpl.platform.model.User;

public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByUsername(String username);
}
