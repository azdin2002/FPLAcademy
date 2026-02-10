package fpl.platform.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/etudiant")
public class EtudiantPageController {

    // Display student dashboard
    @GetMapping("/dashboard")
    public String dashboard() {
        return "etudiant/dashboard";
    }

    // Display course catalogue
    @GetMapping("/catalogue")
    public String catalogue() {
        return "etudiant/catalogue";
    }

    // Display course details
    @GetMapping("/cours/{id}")
    public String detailCours(@PathVariable Long id) {
        return "etudiant/detail-cours";
    }
}
