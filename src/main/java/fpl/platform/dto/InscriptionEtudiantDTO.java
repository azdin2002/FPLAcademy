package fpl.platform.dto;

import java.time.LocalDateTime;

public class InscriptionEtudiantDTO {

    private Long inscriptionId;
    private Long coursId;
    private String coursTitre;
    private String enseignantUsername;
    private String coursDescription;
    private int progression;
    private boolean termine;
    private LocalDateTime dateInscription;

    public InscriptionEtudiantDTO(Long inscriptionId,
                                  Long coursId,
                                  String coursTitre,
                                  String enseignantUsername,
                                  String coursDescription,
                                  int progression,
                                  boolean termine,
                                  LocalDateTime dateInscription) {

        this.inscriptionId = inscriptionId;
        this.coursId = coursId;
        this.coursTitre = coursTitre;
        this.enseignantUsername = enseignantUsername;
        this.coursDescription = coursDescription;
        this.progression = progression;
        this.termine = termine;
        this.dateInscription = dateInscription;
    }

    public Long getInscriptionId() { return inscriptionId; }
    public Long getCoursId() { return coursId; }
    public String getCoursTitre() { return coursTitre; }
    public String getEnseignantUsername() { return enseignantUsername; }
    public String getCoursDescription() { return coursDescription; }
    public int getProgression() { return progression; }
    public boolean isTermine() { return termine; }
    public LocalDateTime getDateInscription() { return dateInscription; }
}
