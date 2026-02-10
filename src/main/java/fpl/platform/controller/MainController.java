package fpl.platform.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.security.core.Authentication;

import fpl.platform.repository.CoursRepository;

import org.springframework.ui.Model;

@Controller
public class MainController {

    @GetMapping("/")
    public String home() {
        return "redirect:/connexion";
    }

    @GetMapping("/access-denied")
    public String accessDenied() {
        return "error-403";
    }
}
