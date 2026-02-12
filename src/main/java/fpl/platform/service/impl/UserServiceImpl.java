package fpl.platform.service.impl;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import fpl.platform.exception.BusinessException;
import fpl.platform.model.Role;
import fpl.platform.model.User;
import fpl.platform.repository.UserRepository;
import fpl.platform.service.UserService;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public UserServiceImpl(UserRepository userRepository,
                           PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public User registerUser(String username, String password, Role role) {

        if (userRepository.findByUsername(username).isPresent()) {
            throw new BusinessException("Username déjà utilisé");
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(passwordEncoder.encode(password));
        user.setRole(role);

        return userRepository.save(user);
    }
}
