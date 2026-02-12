package fpl.platform.service.impl;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


import fpl.platform.model.Cours;
import fpl.platform.model.Role;
import fpl.platform.model.User;
import fpl.platform.repository.CoursRepository;
import fpl.platform.repository.InscriptionRepository;
import fpl.platform.repository.UserRepository;
import fpl.platform.service.CoursService;
import fpl.platform.exception.ResourceNotFoundException;
import fpl.platform.dto.CoursResponse;
import fpl.platform.dto.CoursStatsDTO;
import fpl.platform.exception.BusinessException;

@Service
@Transactional
public class CoursServiceImpl implements CoursService {

    private final CoursRepository coursRepository;
    private final UserRepository userRepository;
    private final InscriptionRepository inscriptionRepository;


    public CoursServiceImpl(CoursRepository coursRepository,
                            UserRepository userRepository, InscriptionRepository inscriptionRepository) {
        this.coursRepository = coursRepository;
        this.userRepository = userRepository;
        this.inscriptionRepository = inscriptionRepository;
    }
  


    @Override
    public CoursResponse createCours(Cours cours, String username) {

        User enseignant = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur introuvable"));

        if (enseignant.getRole() != Role.ROLE_ENSEIGNANT) {
            throw new BusinessException("Seul un enseignant peut créer un cours");
        }

        cours.setEnseignant(enseignant);

        Cours saved = coursRepository.save(cours);

        return mapToResponse(saved);
    }

    @Override
    @Transactional
    public CoursResponse updateCours(Long id, Cours updatedCours, String username) {

        Cours cours = coursRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Cours not found"));

        // security check
        if (!cours.getEnseignant().getUsername().equals(username)) {
            throw new RuntimeException("Access denied");
        }

        cours.setTitre(updatedCours.getTitre());
        cours.setDescription(updatedCours.getDescription());
        cours.setContenu(updatedCours.getContenu());

        return mapToResponse(cours);
    }


    @Override
    public void deleteCours(Long id, String username) {

        Cours existing = coursRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Cours introuvable"));

        if (!existing.getEnseignant().getUsername().equals(username)) {
            throw new BusinessException("Vous ne pouvez supprimer que vos propres cours");
        }

        coursRepository.delete(existing);
    }

    @Override
    public Page<CoursResponse> getAllCours(Pageable pageable) {

        return coursRepository.findAll(pageable)
                .map(this::mapToResponse);
    }

    @Override
    @Transactional(readOnly = true)
    public CoursResponse getCoursById(Long id) {

        Cours cours = coursRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Cours not found"));

        return mapToResponse(cours);
    }

    private CoursResponse mapToResponse(Cours cours) {
        return new CoursResponse(
                cours.getId(),
                cours.getTitre(),
                cours.getDescription(),
                cours.getContenu(),
                cours.getCapaciteMax(),
                cours.getEnseignant().getUsername(),
                cours.getInscriptions() != null ? cours.getInscriptions().size() : 0
        );
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<CoursStatsDTO> getCoursByEnseignant(String username) {

        User prof = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Utilisateur introuvable"));

        return coursRepository.findByEnseignant(prof)
                .stream()
                .map(c -> new CoursStatsDTO(
                        c.getId(),
                        c.getTitre(),
                        c.getDescription(),
                        inscriptionRepository.countByCoursId(c.getId())
                ))
                .toList();
    }
    

}
