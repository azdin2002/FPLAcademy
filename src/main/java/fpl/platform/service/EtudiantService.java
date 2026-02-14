package fpl.platform.service;

import fpl.platform.model.Inscription;
import fpl.platform.model.User;
import fpl.platform.repository.InscriptionRepository;
import fpl.platform.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EtudiantService {

    @Autowired
    private InscriptionRepository inscriptionRepository;

    @Autowired
    private UserRepository userRepository;

    /**
     * Récupère la liste des cours auxquels l'étudiant est inscrit
     * @param username Le nom d'utilisateur de l'étudiant
     * @return Liste des inscriptions de l'étudiant
     */
    public List<Inscription> getMesCours(String username) {
        User etudiant = userRepository.findByUsername(username);
        return inscriptionRepository.findByEtudiant(etudiant);
    }
}