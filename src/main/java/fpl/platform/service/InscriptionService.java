package fpl.platform.service;

import fpl.platform.dto.InscriptionDTO;
import fpl.platform.dto.InscriptionEtudiantDTO;

import java.util.List;

public interface InscriptionService {

    // Student enroll
    InscriptionEtudiantDTO inscrire(Long coursId, String username);

    // Student unsubscribe
    void desinscrire(Long coursId, String username);

    // Student dashboard
    List<InscriptionEtudiantDTO> getInscriptionsByEtudiant(String username);

    // Single course check (for "Démarrer" access)
    InscriptionEtudiantDTO getInscriptionDTOByCours(Long coursId, String username);

    // Update progression
    InscriptionEtudiantDTO updateProgression(Long inscriptionId, int augmentation);

    // Teacher side
    long countByCours(Long coursId);

    List<InscriptionDTO> getInscriptionsByCoursId(Long coursId);
    

}
