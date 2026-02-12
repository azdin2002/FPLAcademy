package fpl.platform.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@Configuration
public class SecurityConfig {

    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        http
            .csrf(csrf -> csrf.disable())

            .authorizeHttpRequests(auth -> auth

                // Public pages
                .requestMatchers("/inscription", "/connexion", "/login",
                                 "/css/**", "/js/**", "/WEB-INF/jsp/**").permitAll()

                .requestMatchers("/api/users/inscription").permitAll()

                // Teacher routes
                .requestMatchers("/enseignant/**").hasRole("ENSEIGNANT")
                .requestMatchers("/api/enseignant/**").hasRole("ENSEIGNANT")

                // Student routes
                .requestMatchers("/etudiant/**").hasRole("ETUDIANT")
                .requestMatchers("/api/etudiant/**").hasRole("ETUDIANT")
                .requestMatchers("/api/inscriptions/**").hasRole("ETUDIANT")

                // All other API calls require authentication
                .requestMatchers("/api/**").authenticated()

                .anyRequest().authenticated()
            )

            .formLogin(login -> login
                .loginPage("/connexion")
                .loginProcessingUrl("/login")
                .successHandler((request, response, authentication) -> {

                    boolean isProf = authentication.getAuthorities().stream()
                            .anyMatch(a -> a.getAuthority().equals("ROLE_ENSEIGNANT"));

                    if (isProf) {
                        response.sendRedirect("/enseignant/dashboard");
                    } else {
                        response.sendRedirect("/etudiant/dashboard");
                    }
                })
                .failureUrl("/connexion?error=true")
                .permitAll()
            )

            .logout(logout -> logout
                .logoutUrl("/deconnexion")
                .logoutSuccessUrl("/connexion?logout=true")
                .invalidateHttpSession(true)
                .deleteCookies("JSESSIONID")
                .permitAll()
            )

            .exceptionHandling(ex -> ex
                .accessDeniedPage("/access-denied")
            );

        return http.build();
    }
}
