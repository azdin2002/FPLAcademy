package fpl.platform.service.impl;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import fpl.platform.dto.InscriptionDTO;
import fpl.platform.dto.InscriptionEtudiantDTO;
import fpl.platform.exception.BusinessException;
import fpl.platform.exception.ResourceNotFoundException;
import fpl.platform.model.Cours;
import fpl.platform.model.Inscription;
import fpl.platform.model.Role;
import fpl.platform.model.User;
import fpl.platform.repository.CoursRepository;
import fpl.platform.repository.InscriptionRepository;
import fpl.platform.repository.UserRepository;
import fpl.platform.service.InscriptionService;

import java.util.List;

@Service
@Transactional
public class InscriptionServiceImpl implements InscriptionService {

    private final InscriptionRepository inscriptionRepository;
    private final CoursRepository coursRepository;
    private final UserRepository userRepository;

    public InscriptionServiceImpl(InscriptionRepository inscriptionRepository,
                                  CoursRepository coursRepository,
                                  UserRepository userRepository) {
        this.inscriptionRepository = inscriptionRepository;
        this.coursRepository = coursRepository;
        this.userRepository = userRepository;
    }

    // ===============================
    // STUDENT ENROLL
    // ===============================
    @Override
    public InscriptionEtudiantDTO inscrire(Long coursId, String username) {

        User etudiant = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur introuvable"));

        if (etudiant.getRole() != Role.ROLE_ETUDIANT) {
            throw new BusinessException("Seul un étudiant peut s'inscrire");
        }

        Cours cours = coursRepository.findById(coursId)
                .orElseThrow(() -> new ResourceNotFoundException("Cours introuvable"));

        if (inscriptionRepository.findByEtudiantAndCours(etudiant, cours).isPresent()) {
            throw new BusinessException("Vous êtes déjà inscrit à ce cours");
        }

        long nombreInscrits = inscriptionRepository.countByCoursId(coursId);
        if (nombreInscrits >= cours.getCapaciteMax()) {
            throw new BusinessException("Capacité maximale atteinte");
        }

        Inscription inscription = new Inscription();
        inscription.setEtudiant(etudiant);
        inscription.setCours(cours);
        inscription.setProgression(0);
        inscription.setTermine(false);

        Inscription saved = inscriptionRepository.save(inscription);

        return mapToEtudiantDTO(saved);
    }

    // ===============================
    // UNSUBSCRIBE
    // ===============================
    @Override
    public void desinscrire(Long coursId, String username) {

        User etudiant = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur introuvable"));

        Inscription inscription = inscriptionRepository
                .findByEtudiantIdAndCoursId(etudiant.getId(), coursId)
                .orElseThrow(() -> new ResourceNotFoundException("Inscription introuvable"));

        inscriptionRepository.delete(inscription);
    }

    // ===============================
    // UPDATE PROGRESSION
    // ===============================
    @Override
    public InscriptionEtudiantDTO updateProgression(Long inscriptionId, int augmentation) {

        Inscription inscription = inscriptionRepository.findById(inscriptionId)
                .orElseThrow(() -> new ResourceNotFoundException("Inscription introuvable"));

        int nouveauProgres = Math.min(inscription.getProgression() + augmentation, 100);
        inscription.setProgression(nouveauProgres);

        if (nouveauProgres == 100) {
            inscription.setTermine(true);
        }

        Inscription saved = inscriptionRepository.save(inscription);

        return mapToEtudiantDTO(saved);
    }

    // ===============================
    // STUDENT DASHBOARD
    // ===============================
    @Override
    @Transactional(readOnly = true)
    public List<InscriptionEtudiantDTO> getInscriptionsByEtudiant(String username) {

        User etudiant = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur introuvable"));

        return inscriptionRepository.findByEtudiant(etudiant)
                .stream()
                .map(this::mapToEtudiantDTO)
                .toList();
    }

    // ===============================
    // CHECK ACCESS TO COURSE
    // ===============================
    @Override
    @Transactional(readOnly = true)
    public InscriptionEtudiantDTO getInscriptionDTOByCours(Long coursId, String username) {

        User etudiant = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur introuvable"));

        Inscription inscription = inscriptionRepository
                .findByEtudiantIdAndCoursId(etudiant.getId(), coursId)
                .orElseThrow(() -> new ResourceNotFoundException("Inscription introuvable"));

        return new InscriptionEtudiantDTO(
                inscription.getId(),
                inscription.getCours().getId(),
                inscription.getCours().getTitre(),
                inscription.getCours().getEnseignant().getUsername(),
                inscription.getCours().getDescription(),
                inscription.getProgression(),
                inscription.isTermine(),
                inscription.getDateInscription()
        );
    }


    // ===============================
    // TEACHER SIDE
    // ===============================
    @Override
    public long countByCours(Long coursId) {
        return inscriptionRepository.countByCoursId(coursId);
    }

    @Override
    public List<InscriptionDTO> getInscriptionsByCoursId(Long coursId) {

        return inscriptionRepository.findByCoursId(coursId)
                .stream()
                .map(i -> new InscriptionDTO(
                        i.getId(),
                        i.getEtudiant().getId(),
                        i.getEtudiant().getUsername(),
                        i.getProgression(),
                        i.isTermine(),
                        i.getDateInscription()
                ))
                .toList();
    }

    // ===============================
    // PRIVATE MAPPER
    // ===============================
    private InscriptionEtudiantDTO mapToEtudiantDTO(Inscription i) {
        return new InscriptionEtudiantDTO(
                i.getId(),
                i.getCours().getId(),
                i.getCours().getTitre(),
                i.getCours().getEnseignant().getUsername(),
                i.getCours().getDescription(),
                i.getProgression(),
                i.isTermine(),
                i.getDateInscription()
        );
    }
    

}
