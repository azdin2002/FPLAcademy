package fpl.platform.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
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
                .requestMatchers("/inscription", "/connexion", "/login", "/css/**", "/js/**", "/WEB-INF/jsp/**").permitAll()
                .requestMatchers("/api/users/inscription").permitAll()
                .requestMatchers("/enseignant/**").hasRole("ENSEIGNANT")
                .requestMatchers("/etudiant/**").hasRole("ETUDIANT")
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
            	)

            
            .logout(logout -> logout
                .logoutUrl("/deconnexion")
                .logoutSuccessUrl("/connexion?logout=true")
                .invalidateHttpSession(true)
                .deleteCookies("JSESSIONID")
                .permitAll()
            )

            .exceptionHandling(ex -> ex.accessDeniedPage("/access-denied"));

        return http.build();
    }
}