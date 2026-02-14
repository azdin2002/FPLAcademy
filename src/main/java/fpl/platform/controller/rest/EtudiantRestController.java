package fpl.platform.controller.rest;

import fpl.platform.model.Inscription;
import fpl.platform.service.EtudiantService;
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
    private EtudiantService etudiantService;

    /**
     * Récupère la liste des cours auxquels l'étudiant connecté est inscrit.
     * Utilisé par le Dashboard (dashboard.jsp)
     */
    @GetMapping("/mes-cours")
    public ResponseEntity<List<Inscription>> getMesCours(Authentication auth) {
        List<Inscription> inscriptions = etudiantService.getMesCours(auth.getName());
        return ResponseEntity.ok(inscriptions);
    }

}