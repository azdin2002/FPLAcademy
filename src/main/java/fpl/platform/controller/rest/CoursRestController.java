package fpl.platform.controller.rest;

import fpl.platform.dto.CoursResponse;
import fpl.platform.service.CoursService;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/cours")
public class CoursRestController {

    private final CoursService coursService;

    public CoursRestController(CoursService coursService) {
        this.coursService = coursService;
    }

    @GetMapping
    public ResponseEntity<Page<CoursResponse>> getListeCours(Pageable pageable) {
        return ResponseEntity.ok(coursService.getAllCours(pageable));
    }

    @GetMapping("/{id}")
    public ResponseEntity<CoursResponse> getCoursById(@PathVariable Long id) {
        return ResponseEntity.ok(coursService.getCoursById(id));
    }
}
