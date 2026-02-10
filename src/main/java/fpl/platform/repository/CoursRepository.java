package fpl.platform.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import fpl.platform.model.Cours;
import fpl.platform.model.User;

public interface CoursRepository extends JpaRepository<Cours, Long> {
    List<Cours> findByEnseignant(User enseignant);

}