package fpl.platform.controller.rest;

import fpl.platform.dto.InscriptionEtudiantDTO;
import fpl.platform.model.Inscription;
import fpl.platform.service.InscriptionService;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/inscriptions")
public class InscriptionRestController {

    private final InscriptionService inscriptionService;

    public InscriptionRestController(InscriptionService inscriptionService) {
        this.inscriptionService = inscriptionService;
    }

    // 🔥 THIS IS THE MISSING ENDPOINT
    @GetMapping("/etudiant")
    public ResponseEntity<List<InscriptionEtudiantDTO>> getMesInscriptions(Authentication auth) {
        return ResponseEntity.ok(
                inscriptionService.getInscriptionsByEtudiant(auth.getName())
        );
    }

    @PutMapping("/{id}/progression")
    public ResponseEntity<InscriptionEtudiantDTO> updateProgression(
            @PathVariable Long id,
            @RequestBody Map<String, Integer> payload,
            Authentication auth) {

        int augmentation = payload.getOrDefault("augmentation", 25);

        InscriptionEtudiantDTO updated = inscriptionService.updateProgression(id, augmentation);
        InscriptionEtudiantDTO dto =
                inscriptionService.getInscriptionDTOByCours(
                        updated.getCoursId(),
                        auth.getName()
                );

        return ResponseEntity.ok(dto);
    }





    @DeleteMapping("/desinscrire/{coursId}")
    public ResponseEntity<Void> desinscrire(@PathVariable Long coursId,
                                            Authentication auth) {

        inscriptionService.desinscrire(coursId, auth.getName());
        return ResponseEntity.ok().build();
    }
    
    @GetMapping("/etudiant/cours/{coursId}")
    public ResponseEntity<InscriptionEtudiantDTO> getInscriptionByCours(
            @PathVariable Long coursId,
            Authentication auth) {

        return ResponseEntity.ok(
                inscriptionService.getInscriptionDTOByCours(coursId, auth.getName())
        );
    }


}
