package fpl.platform.controller.rest;

import fpl.platform.model.Inscription;
import fpl.platform.model.User;
import fpl.platform.repository.InscriptionRepository;
import fpl.platform.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/etudiant")
public class EtudiantRestController {

    @Autowired
    private InscriptionRepository inscriptionRepo;

    @Autowired
    private UserRepository userRepo;

    /**
     * Récupère la liste des cours auxquels l'étudiant connecté est inscrit.
     * Utilisé par le Dashboard (dashboard.jsp)
     */
    @GetMapping("/mes-cours")
    public ResponseEntity<List<Inscription>> getMesCours(Authentication auth) {
        // 1. Trouver l'utilisateur connecté en base
        User etudiant = userRepo.findByUsername(auth.getName());
        
        // 2. Récupérer ses inscriptions via le repository
        List<Inscription> inscriptions = inscriptionRepo.findByEtudiant(etudiant);
        
        return ResponseEntity.ok(inscriptions);
    }
}