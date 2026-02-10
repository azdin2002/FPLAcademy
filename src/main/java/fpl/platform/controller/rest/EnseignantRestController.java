package fpl.platform.controller.rest;

import fpl.platform.dto.CoursStatsDTO;
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
import org.springframework.http.HttpStatus;

import java.util.List;

@RestController
@RequestMapping("/api/enseignant")
public class EnseignantRestController {

    @Autowired
    private CoursRepository coursRepo;
    
    @Autowired
    private UserRepository userRepo;

    @Autowired
    private InscriptionRepository inscriptionRepo;

    @GetMapping("/cours")
    public ResponseEntity<List<CoursStatsDTO>> getMesCours(Authentication auth) {

        User prof = userRepo.findByUsername(auth.getName());
        List<Cours> coursList = coursRepo.findByEnseignant(prof);

        List<CoursStatsDTO> result = coursList.stream().map(c -> {
            long count = inscriptionRepo.countByCoursId(c.getId());
            return new CoursStatsDTO(
                    c.getId(),
                    c.getTitre(),
                    c.getDescription(),
                    count
            );
        }).toList();

        return ResponseEntity.ok(result);
    }

    @PostMapping("/cours")
    public ResponseEntity<Cours> creerCours(@RequestBody Cours cours, Authentication auth) {
        User prof = userRepo.findByUsername(auth.getName());
        cours.setEnseignant(prof);
        Cours saved = coursRepo.save(cours);
        return ResponseEntity.ok(saved);
    }

    @GetMapping("/cours/{id}")
    public ResponseEntity<Cours> getCours(
            @PathVariable Long id,
            Authentication auth) {

        User prof = userRepo.findByUsername(auth.getName());

        return coursRepo.findById(id)
                .filter(c -> c.getEnseignant().getId().equals(prof.getId()))
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.status(HttpStatus.FORBIDDEN).build());
    }


    @PutMapping("/cours/{id}")
    public ResponseEntity<Cours> modifierCours(
            @PathVariable Long id,
            @RequestBody Cours coursDetails,
            Authentication auth) {

        User prof = userRepo.findByUsername(auth.getName());

        return coursRepo.findById(id)
                .filter(c -> c.getEnseignant().getId().equals(prof.getId()))
                .map(cours -> {
                    cours.setTitre(coursDetails.getTitre());
                    cours.setDescription(coursDetails.getDescription());
                    cours.setContenu(coursDetails.getContenu());
                    return ResponseEntity.ok(coursRepo.save(cours));
                })
                .orElse(ResponseEntity.status(HttpStatus.FORBIDDEN).build());
    }

    @DeleteMapping("/cours/{id}")
    public ResponseEntity<Void> supprimerCours(
            @PathVariable Long id,
            Authentication auth) {

        User prof = userRepo.findByUsername(auth.getName());
        Cours cours = coursRepo.findById(id).orElse(null);

        if (cours == null) {
            return ResponseEntity.notFound().build();
        }

        if (!cours.getEnseignant().getId().equals(prof.getId())) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }

        coursRepo.delete(cours);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/cours/{coursId}/inscriptions")
    public ResponseEntity<List<Inscription>> getInscriptionsParCours(@PathVariable Long coursId) {
        
        List<Inscription> inscriptions = inscriptionRepo.findByCoursId(coursId);
        return ResponseEntity.ok(inscriptions);
    }
}