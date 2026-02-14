package fpl.platform.service;

import fpl.platform.model.Cours;
import fpl.platform.model.Inscription;
import fpl.platform.model.User;
import fpl.platform.repository.CoursRepository;
import fpl.platform.repository.InscriptionRepository;
import fpl.platform.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class InscriptionService {

    @Autowired
    private InscriptionRepository inscriptionRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CoursRepository coursRepository;

    /**
     * Récupère toutes les inscriptions d'un étudiant
     * @param username Le nom d'utilisateur de l'étudiant
     * @return Liste des inscriptions de l'étudiant
     */
    public List<Inscription> getInscriptionsByUsername(String username) {
        User etudiant = userRepository.findByUsername(username);
        return inscriptionRepository.findByEtudiant(etudiant);
    }

    /**
     * Inscrit un étudiant à un cours
     * @param coursId L'identifiant du cours
     * @param username Le nom d'utilisateur de l'étudiant
     * @return L'inscription créée ou une exception si déjà inscrit ou cours inexistant
     */
    public Optional<Inscription> inscrireEtudiant(Long coursId, String username) {
        User etudiant = userRepository.findByUsername(username);
        
        Optional<Cours> coursOpt = coursRepository.findById(coursId);
        if (coursOpt.isEmpty()) {
            return Optional.empty();
        }
        
        Cours cours = coursOpt.get();
        
        // Vérifier si déjà inscrit
        Optional<Inscription> existingInscription = inscriptionRepository.findByEtudiantAndCours(etudiant, cours);
        if (existingInscription.isPresent()) {
            throw new IllegalStateException("Déjà inscrit");
        }
        
        // Créer nouvelle inscription
        Inscription inscription = new Inscription();
        inscription.setEtudiant(etudiant);
        inscription.setCours(cours);
        inscription.setProgression(0);
        inscription.setTermine(false);
        
        return Optional.of(inscriptionRepository.save(inscription));
    }

    /**
     * Met à jour la progression d'une inscription
     * @param inscriptionId L'identifiant de l'inscription
     * @param augmentation Le pourcentage d'augmentation de la progression
     * @return L'inscription mise à jour
     */
    public Optional<Inscription> updateProgression(Long inscriptionId, int augmentation) {
        return inscriptionRepository.findById(inscriptionId)
                .map(inscription -> {
                    int nouveauProgres = inscription.getProgression() + augmentation;
                    
                    if (nouveauProgres > 100) {
                        nouveauProgres = 100;
                    }
                    
                    inscription.setProgression(nouveauProgres);
                    if (nouveauProgres == 100) {
                        inscription.setTermine(true);
                    }
                    
                    return inscriptionRepository.save(inscription);
                });
    }

    /**
     * Supprime une inscription
     * @param inscriptionId L'identifiant de l'inscription
     * @return true si l'inscription a été supprimée, false sinon
     */
    public boolean deleteInscription(Long inscriptionId) {
        if (inscriptionRepository.existsById(inscriptionId)) {
            inscriptionRepository.deleteById(inscriptionId);
            return true;
        }
        return false;
    }

    /**
     * Récupère l'inscription d'un étudiant pour un cours spécifique
     * @param coursId L'identifiant du cours
     * @param username Le nom d'utilisateur de l'étudiant
     * @return L'inscription si elle existe
     */
    public Optional<Inscription> getInscriptionByCoursAndUsername(Long coursId, String username) {
        User etudiant = userRepository.findByUsername(username);
        
        return coursRepository.findById(coursId)
                .flatMap(cours -> inscriptionRepository.findByEtudiantAndCours(etudiant, cours));
    }

    /**
     * Récupère toutes les inscriptions pour un cours donné
     * @param coursId L'identifiant du cours
     * @return Liste des inscriptions pour ce cours
     */
    public List<Inscription> getInscriptionsByCours(Long coursId) {
        return inscriptionRepository.findByCoursId(coursId);
    }
}