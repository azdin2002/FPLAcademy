package fpl.platform.controller.rest;

import fpl.platform.model.Cours;
import fpl.platform.repository.CoursRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/cours")
public class CoursRestController {

    @Autowired
    private CoursRepository coursRepo;

    @GetMapping
    public List<Cours> getListeCours() {
        return coursRepo.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Cours> getCoursById(@PathVariable Long id) {
        return coursRepo.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    

}