package fpl.platform.service;

import fpl.platform.model.User;
import fpl.platform.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private BCryptPasswordEncoder encoder;

    /**
     * Enregistre un nouvel utilisateur avec un mot de passe encodé
     * @param user L'utilisateur à enregistrer
     * @return L'utilisateur enregistré
     */
    public User enregistrerUtilisateur(User user) {
        user.setPassword(encoder.encode(user.getPassword()));
        return userRepository.save(user);
    }

    /**
     * Récupère un utilisateur par son nom d'utilisateur
     * @param username Le nom d'utilisateur
     * @return L'utilisateur trouvé
     */
    public User getUserByUsername(String username) {
        return userRepository.findByUsername(username);
    }
}