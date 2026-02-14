package fpl.platform.controller.rest;

import fpl.platform.model.User;
import fpl.platform.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/users")
public class UserRestController {

    @Autowired
    private UserService userService;

    @PostMapping("/inscription")
    public ResponseEntity<?> inscrireUtilisateur(@RequestBody User user) {
        try {
            userService.enregistrerUtilisateur(user);
            Map<String, String> response = new HashMap<>();
            response.put("message", "Inscription réussie");
            response.put("username", user.getUsername());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Erreur lors de l'inscription: " + e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }
}