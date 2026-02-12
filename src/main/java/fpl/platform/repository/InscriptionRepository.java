package fpl.platform.repository;

import fpl.platform.model.Inscription;
import fpl.platform.model.User;
import fpl.platform.model.Cours;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface InscriptionRepository extends JpaRepository<Inscription, Long> {
	List<Inscription> findByEtudiant(User etudiant);
    
    // Trouve tous les étudiants d'un cours spécifique (pour le prof)
    List<Inscription> findByCours(Cours cours);
    
    // Pour le bouton d'inscription (vérifier le doublon)
    Optional<Inscription> findByEtudiantAndCours(User etudiant, Cours cours);

    // Nécessaire pour la méthode que nous avons ajoutée dans EnseignantRestController
    List<Inscription> findByCoursId(Long coursId);
    
    Optional<Inscription> findByEtudiantIdAndCoursId(Long etudiantId, Long coursId);
    
    long countByCoursId(Long coursId);

}