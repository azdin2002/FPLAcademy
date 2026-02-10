package fpl.platform.service;

import fpl.platform.model.User;
import fpl.platform.repository.UserRepository; // Doit correspondre au nom du fichier
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AppService {

    @Autowired
    private UserRepository userRepo; 

    @Autowired
    private BCryptPasswordEncoder encoder;

    public void enregistrerUtilisateur(User user) {
        user.setPassword(encoder.encode(user.getPassword()));
        userRepo.save(user);
    }
}