package fpl.platform.service;

import fpl.platform.model.User;
import fpl.platform.model.Role;

public interface UserService {

    User registerUser(String username, String password, Role role);
}
