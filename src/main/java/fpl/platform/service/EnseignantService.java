package fpl.platform.service;

import fpl.platform.dto.CoursStatsDTO;
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
public class EnseignantService {

    @Autowired
    private CoursRepository coursRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private InscriptionRepository inscriptionRepository;

    /**
     * Récupère la liste des cours d'un enseignant avec les statistiques d'inscription
     * @param username Le nom d'utilisateur de l'enseignant
     * @return Liste de CoursStatsDTO contenant les cours et le nombre d'étudiants inscrits
     */
    public List<CoursStatsDTO> getMesCours(String username) {
        User professeur = userRepository.findByUsername(username);
        List<Cours> coursList = coursRepository.findByEnseignant(professeur);

        return coursList.stream().map(c -> {
            long count = inscriptionRepository.countByCoursId(c.getId());
            return new CoursStatsDTO(
                    c.getId(),
                    c.getTitre(),
                    c.getDescription(),
                    count
            );
        }).toList();
    }

    /**
     * Crée un nouveau cours pour un enseignant
     * @param cours Le cours à créer
     * @param username Le nom d'utilisateur de l'enseignant
     * @return Le cours créé
     */
    public Cours creerCours(Cours cours, String username) {

        System.out.println("USERNAME = " + username);

        User professeur = userRepository.findByUsername(username);

        System.out.println("PROF = " + professeur);

        cours.setEnseignant(professeur);

        return coursRepository.save(cours);
    }


    /**
     * Récupère un cours appartenant à un enseignant
     * @param coursId L'identifiant du cours
     * @param username Le nom d'utilisateur de l'enseignant
     * @return Optional contenant le cours s'il appartient à l'enseignant
     */
    public Optional<Cours> getCoursByIdAndEnseignant(Long coursId, String username) {
        User professeur = userRepository.findByUsername(username);
        
        return coursRepository.findById(coursId)
                .filter(c -> c.getEnseignant().getId().equals(professeur.getId()));
    }

    /**
     * Modifie un cours existant
     * @param coursId L'identifiant du cours
     * @param coursDetails Les nouvelles informations du cours
     * @param username Le nom d'utilisateur de l'enseignant
     * @return Optional contenant le cours modifié s'il appartient à l'enseignant
     */
    public Optional<Cours> modifierCours(Long coursId, Cours coursDetails, String username) {
        User professeur = userRepository.findByUsername(username);

        return coursRepository.findById(coursId)
                .filter(c -> c.getEnseignant().getId().equals(professeur.getId()))
                .map(cours -> {
                    cours.setTitre(coursDetails.getTitre());
                    cours.setDescription(coursDetails.getDescription());
                    cours.setContenu(coursDetails.getContenu());
                    return coursRepository.save(cours);
                });
    }

    /**
     * Supprime un cours
     * @param coursId L'identifiant du cours
     * @param username Le nom d'utilisateur de l'enseignant
     * @return true si le cours a été supprimé, false si non trouvé, null si non autorisé
     */
    public Boolean supprimerCours(Long coursId, String username) {
        User professeur = userRepository.findByUsername(username);
        Optional<Cours> coursOpt = coursRepository.findById(coursId);

        if (coursOpt.isEmpty()) {
            return false; // Cours non trouvé
        }

        Cours cours = coursOpt.get();
        
        if (!cours.getEnseignant().getId().equals(professeur.getId())) {
            return null; // Non autorisé
        }

        coursRepository.delete(cours);
        return true; // Suppression réussie
    }

    /**
     * Récupère toutes les inscriptions pour un cours donné
     * @param coursId L'identifiant du cours
     * @return Liste des inscriptions
     */
    public List<Inscription> getInscriptionsParCours(Long coursId) {
        return inscriptionRepository.findByCoursId(coursId);
    }
}