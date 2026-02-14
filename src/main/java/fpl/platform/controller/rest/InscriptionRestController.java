package fpl.platform.controller.rest;

import fpl.platform.model.Inscription;
import fpl.platform.service.InscriptionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


@RestController
@RequestMapping("/api/inscriptions")
public class InscriptionRestController {

    @Autowired
    private InscriptionService inscriptionService;

    // Utilisé par : Dashboard Étudiant
    @GetMapping("/etudiant")
    public ResponseEntity<List<Inscription>> getMesInscriptions(Authentication auth) {
        List<Inscription> inscriptions = inscriptionService.getInscriptionsByUsername(auth.getName());
        return ResponseEntity.ok(inscriptions);
    }

    // Utilisé par : Catalogue (pour savoir si l'étudiant est déjà inscrit)
    @GetMapping("/mes-inscriptions")
    public ResponseEntity<List<Inscription>> getMesInscriptionsShort(Authentication auth) {
        List<Inscription> inscriptions = inscriptionService.getInscriptionsByUsername(auth.getName());
        return ResponseEntity.ok(inscriptions);
    }

    // Utilisé par : Bouton "S'inscrire" du Catalogue
    @PostMapping("/inscrire/{coursId}")
    public ResponseEntity<?> inscrire(@PathVariable Long coursId, Authentication auth) {
        try {
            return inscriptionService.inscrireEtudiant(coursId, auth.getName())
                    .map(ResponseEntity::ok)
                    .orElse(ResponseEntity.notFound().build());
        } catch (IllegalStateException e) {
            Map<String, String> response = new HashMap<>();
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    // Update progression
    @PutMapping("/{id}/progression")
    public ResponseEntity<Inscription> updateProgression(
            @PathVariable Long id,
            @RequestBody Map<String, Integer> payload) {
        
        int augmentation = payload.getOrDefault("augmentation", 25);
        
        return inscriptionService.updateProgression(id, augmentation)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Delete an inscription
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteInscription(@PathVariable Long id) {
        if (inscriptionService.deleteInscription(id)) {
            return ResponseEntity.ok().build();
        }
        return ResponseEntity.notFound().build();
    }
    
    @GetMapping("/etudiant/cours/{coursId}")
    public ResponseEntity<Inscription> getInscriptionByCours(
            @PathVariable Long coursId,
            Authentication auth) {

        return inscriptionService.getInscriptionByCoursAndUsername(coursId, auth.getName())
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    
}