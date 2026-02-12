package fpl.platform.controller.rest;

import fpl.platform.dto.CoursResponse;
import fpl.platform.dto.CoursStatsDTO;
import fpl.platform.dto.InscriptionDTO;
import fpl.platform.service.CoursService;
import fpl.platform.service.InscriptionService;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/enseignant")
public class EnseignantRestController {

    private final CoursService coursService;
    private final InscriptionService inscriptionService;

    public EnseignantRestController(CoursService coursService,
                                    InscriptionService inscriptionService) {
        this.coursService = coursService;
        this.inscriptionService = inscriptionService;
    }

    // ===============================
    // GET ALL MY COURSES
    // ===============================
    @GetMapping("/cours")
    public ResponseEntity<List<CoursStatsDTO>> getMesCours(Authentication auth) {
        return ResponseEntity.ok(
                coursService.getCoursByEnseignant(auth.getName())
        );
    }

    // ===============================
    // CREATE COURSE
    // ===============================
    @PostMapping("/cours")
    public ResponseEntity<CoursResponse> creerCours(
            @RequestBody fpl.platform.model.Cours cours,
            Authentication auth) {

        return ResponseEntity.ok(
                coursService.createCours(cours, auth.getName())
        );
    }

    // ===============================
    // GET ONE COURSE
    // ===============================
    @GetMapping("/cours/{id}")
    public ResponseEntity<CoursResponse> getCours(@PathVariable Long id) {

        return ResponseEntity.ok(
                coursService.getCoursById(id)
        );
    }

    // ===============================
    // UPDATE COURSE
    // ===============================
    @PutMapping("/cours/{id}")
    public ResponseEntity<CoursResponse> modifierCours(
            @PathVariable Long id,
            @RequestBody fpl.platform.model.Cours cours,
            Authentication auth) {

        return ResponseEntity.ok(
                coursService.updateCours(id, cours, auth.getName())
        );
    }

    // ===============================
    // DELETE COURSE
    // ===============================
    @DeleteMapping("/cours/{id}")
    public ResponseEntity<Void> supprimerCours(
            @PathVariable Long id,
            Authentication auth) {

        coursService.deleteCours(id, auth.getName());
        return ResponseEntity.ok().build();
    }

    // ===============================
    // GET INSCRIPTIONS OF COURSE
    // ===============================
    @GetMapping("/cours/{id}/inscriptions")
    public ResponseEntity<List<InscriptionDTO>> getInscriptions(@PathVariable Long id) {

        return ResponseEntity.ok(
                inscriptionService.getInscriptionsByCoursId(id)
        );
    }
}
