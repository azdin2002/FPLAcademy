package fpl.platform.controller.rest;

import fpl.platform.dto.InscriptionDTO;
import fpl.platform.dto.InscriptionEtudiantDTO;
import fpl.platform.model.Inscription;
import fpl.platform.service.InscriptionService;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/etudiant")
public class EtudiantRestController {

    private final InscriptionService inscriptionService;

    public EtudiantRestController(InscriptionService inscriptionService) {
        this.inscriptionService = inscriptionService;
    }

    /**
     * Récupère la liste des cours auxquels l'étudiant connecté est inscrit.
     */
    @GetMapping("/inscriptions/etudiant")
    public List<InscriptionEtudiantDTO> getMesInscriptions(Authentication auth) {
        return inscriptionService.getInscriptionsByEtudiant(auth.getName());
    }
}
