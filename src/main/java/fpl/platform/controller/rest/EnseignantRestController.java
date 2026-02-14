package fpl.platform.controller.rest;

import fpl.platform.dto.CoursStatsDTO;
import fpl.platform.model.Cours;
import fpl.platform.model.Inscription;
import fpl.platform.service.EnseignantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/enseignant")
public class EnseignantRestController {

    @Autowired
    private EnseignantService enseignantService;

    @GetMapping("/cours")
    public ResponseEntity<List<CoursStatsDTO>> getMesCours(Authentication auth) {
        List<CoursStatsDTO> result = enseignantService.getMesCours(auth.getName());
        return ResponseEntity.ok(result);
    }

    @PostMapping("/cours")
    public ResponseEntity<Cours> creerCours(@RequestBody Cours cours, Authentication auth) {
        Cours saved = enseignantService.creerCours(cours, auth.getName());
        return ResponseEntity.ok(saved);
    }

    @GetMapping("/cours/{id}")
    public ResponseEntity<Cours> getCours(
            @PathVariable Long id,
            Authentication auth) {

        return enseignantService.getCoursByIdAndEnseignant(id, auth.getName())
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.status(HttpStatus.FORBIDDEN).build());
    }

    @PutMapping("/cours/{id}")
    public ResponseEntity<Cours> modifierCours(
            @PathVariable Long id,
            @RequestBody Cours coursDetails,
            Authentication auth) {

        return enseignantService.modifierCours(id, coursDetails, auth.getName())
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.status(HttpStatus.FORBIDDEN).build());
    }

    @DeleteMapping("/cours/{id}")
    public ResponseEntity<Void> supprimerCours(
            @PathVariable Long id,
            Authentication auth) {

        Boolean result = enseignantService.supprimerCours(id, auth.getName());

        if (result == null) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        
        if (result) {
            return ResponseEntity.ok().build();
        }
        
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/cours/{coursId}/inscriptions")
    public ResponseEntity<List<Inscription>> getInscriptionsParCours(@PathVariable Long coursId) {
        List<Inscription> inscriptions = enseignantService.getInscriptionsParCours(coursId);
        return ResponseEntity.ok(inscriptions);
    }
}