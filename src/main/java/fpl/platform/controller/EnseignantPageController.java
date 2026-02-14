package fpl.platform.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/enseignant") // Toutes les routes ici commencent par /enseignant
public class EnseignantPageController {

    @GetMapping("/dashboard")
    public String dashboard() {
        return "enseignant/dashboard";
    }

    @GetMapping("/publier")
    public String formPublier() {
        return "enseignant/publier";
    }

    @GetMapping("/modifier/{id}")
    public String formModifier(@PathVariable Long id) {
        return "enseignant/modifier";
    }

    @GetMapping("/cours/{id}")
    public String detailCours(@PathVariable Long id, Model model) {
        model.addAttribute("coursId", id);
        return "enseignant/detail-cours";
    }

    @GetMapping("/cours/{id}/etudiants")
    public String voirEtudiants(@PathVariable Long id) {
        return "enseignant/liste-etudiants";
    }

    @GetMapping("/cours/{id}/inscriptions")
    public String inscriptionsPage(@PathVariable Long id, Model model) {
        model.addAttribute("coursId", id);
        return "enseignant/liste-etudiants";
    }
    
    @GetMapping("/catalogue")
    public String catalogue() {
        return "enseignant/catalogue";
    }
}