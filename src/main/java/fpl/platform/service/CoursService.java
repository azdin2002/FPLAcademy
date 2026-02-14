package fpl.platform.service;

import fpl.platform.model.Cours;
import fpl.platform.repository.CoursRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class CoursService {

    @Autowired
    private CoursRepository coursRepository;

    /**
     * Récupère tous les cours disponibles
     * @return Liste de tous les cours
     */
    public List<Cours> getAllCours() {
        return coursRepository.findAll();
    }

    /**
     * Récupère un cours par son ID
     * @param id L'identifiant du cours
     * @return Optional contenant le cours s'il existe
     */
    public Optional<Cours> getCoursById(Long id) {
        return coursRepository.findById(id);
    }
}