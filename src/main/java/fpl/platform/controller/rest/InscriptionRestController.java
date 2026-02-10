package fpl.platform.controller.rest;

import fpl.platform.model.Cours;
import fpl.platform.model.Inscription;
import fpl.platform.model.User;
import fpl.platform.repository.CoursRepository;
import fpl.platform.repository.InscriptionRepository;
import fpl.platform.repository.UserRepository;
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
    private InscriptionRepository inscriptionRepo;
    
    @Autowired
    private UserRepository userRepo;
    
    @Autowired
    private CoursRepository coursRepo;

    // Utilisé par : Dashboard Étudiant
    @GetMapping("/etudiant")
    public ResponseEntity<List<Inscription>> getMesInscriptions(Authentication auth) {
        // Correction : Utilisation du username pour trouver l'étudiant
        User etudiant = userRepo.findByUsername(auth.getName());
        List<Inscription> inscriptions = inscriptionRepo.findByEtudiant(etudiant);
        return ResponseEntity.ok(inscriptions);
    }

    // Utilisé par : Catalogue (pour savoir si l'étudiant est déjà inscrit)
    @GetMapping("/mes-inscriptions")
    public ResponseEntity<List<Inscription>> getMesInscriptionsShort(Authentication auth) {
        User etudiant = userRepo.findByUsername(auth.getName());
        return ResponseEntity.ok(inscriptionRepo.findByEtudiant(etudiant));
    }

    // Utilisé par : Bouton "S'inscrire" du Catalogue
    @PostMapping("/inscrire/{coursId}")
    public ResponseEntity<?> inscrire(@PathVariable Long coursId, Authentication auth) {
        User etudiant = userRepo.findByUsername(auth.getName());
        
        return coursRepo.findById(coursId)
                .map(cours -> {
                    // Vérifier si déjà inscrit (évite les doublons en base)
                    if (inscriptionRepo.findByEtudiantAndCours(etudiant, cours).isPresent()) {
                        Map<String, String> response = new HashMap<>();
                        response.put("message", "Déjà inscrit");
                        return ResponseEntity.badRequest().body(response);
                    }
                    
                    Inscription inscription = new Inscription();
                    inscription.setEtudiant(etudiant);
                    inscription.setCours(cours);
                    inscription.setProgression(0);
                    inscription.setTermine(false);
                    
                    return ResponseEntity.ok(inscriptionRepo.save(inscription));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    // Update progression
    @PutMapping("/{id}/progression")
    public ResponseEntity<Inscription> updateProgression(
            @PathVariable Long id,
            @RequestBody Map<String, Integer> payload) {
        
        return inscriptionRepo.findById(id)
                .map(inscription -> {
                    int augmentation = payload.getOrDefault("augmentation", 25);
                    int nouveauProgres = inscription.getProgression() + augmentation;
                    
                    if (nouveauProgres > 100) {
                        nouveauProgres = 100;
                    }
                    
                    inscription.setProgression(nouveauProgres);
                    if (nouveauProgres == 100) {
                        inscription.setTermine(true);
                    }
                    
                    Inscription updated = inscriptionRepo.save(inscription);
                    return ResponseEntity.ok(updated);
                })
                .orElse(ResponseEntity.notFound().build());
    }

    // Delete an inscription
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteInscription(@PathVariable Long id) {
        if (inscriptionRepo.existsById(id)) {
            inscriptionRepo.deleteById(id);
            return ResponseEntity.ok().build();
        }
        return ResponseEntity.notFound().build();
    }
    
    @GetMapping("/etudiant/cours/{coursId}")
    public ResponseEntity<Inscription> getInscriptionByCours(
            @PathVariable Long coursId,
            Authentication auth) {

        User etudiant = userRepo.findByUsername(auth.getName());

        return coursRepo.findById(coursId)
                .flatMap(cours ->
                        inscriptionRepo.findByEtudiantAndCours(etudiant, cours)
                )
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    
}
