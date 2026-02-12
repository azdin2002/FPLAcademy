package fpl.platform.service;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import fpl.platform.dto.CoursResponse;
import fpl.platform.dto.CoursStatsDTO;
import fpl.platform.model.Cours;
import fpl.platform.model.User;

public interface CoursService {

	CoursResponse createCours(Cours cours, String username);
	CoursResponse updateCours(Long id, Cours cours, String username);
	void deleteCours(Long id, String username);
	Page<CoursResponse> getAllCours(Pageable pageable);
	CoursResponse getCoursById(Long id);
	List<CoursStatsDTO> getCoursByEnseignant(String username);


}
