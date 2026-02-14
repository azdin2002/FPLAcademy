package fpl.platform.controller.rest;

import fpl.platform.model.Cours;
import fpl.platform.service.CoursService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/cours")
public class CoursRestController {

    @Autowired
    private CoursService coursService;

    @GetMapping
    public List<Cours> getListeCours() {
        return coursService.getAllCours();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Cours> getCoursById(@PathVariable Long id) {
        return coursService.getCoursById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    

}