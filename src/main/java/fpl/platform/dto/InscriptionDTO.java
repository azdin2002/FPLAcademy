package fpl.platform.dto;

import java.time.LocalDateTime;

public class InscriptionDTO {

    private Long id;
    private Long etudiantId;
    private String username;
    private int progression;
    private boolean termine;
    private LocalDateTime dateInscription;

    public InscriptionDTO(Long id, Long etudiantId, String username,
                          int progression, boolean termine,
                          LocalDateTime dateInscription) {
        this.id = id;
        this.etudiantId = etudiantId;
        this.username = username;
        this.progression = progression;
        this.termine = termine;
        this.dateInscription = dateInscription;
    }

    public Long getId() { return id; }
    public Long getEtudiantId() { return etudiantId; }
    public String getUsername() { return username; }
    public int getProgression() { return progression; }
    public boolean isTermine() { return termine; }
    public LocalDateTime getDateInscription() { return dateInscription; }
}
