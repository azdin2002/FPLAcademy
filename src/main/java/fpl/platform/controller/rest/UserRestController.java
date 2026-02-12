package fpl.platform.controller.rest;

import fpl.platform.dto.RegisterUserRequest;
import fpl.platform.model.User;
import fpl.platform.service.UserService;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
public class UserRestController {

    private final UserService userService;

    public UserRestController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/inscription")
    public ResponseEntity<User> inscrireUtilisateur(
            @RequestBody RegisterUserRequest request) {

        User user = userService.registerUser(
                request.getUsername(),
                request.getPassword(),
                request.getRole()
        );

        return ResponseEntity.ok(user);
    }
}
