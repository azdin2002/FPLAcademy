package fpl.platform.dto;

public class CoursStatsDTO {

    private Long id;
    private String titre;
    private String description;
    private long nbEtudiants;

    public CoursStatsDTO() {
    	
    }
    
    public CoursStatsDTO(Long id, String titre, String description, long nbEtudiants) {
        this.id = id;
        this.titre = titre;
        this.description = description;
        this.nbEtudiants = nbEtudiants;
    }

    // getters & setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitre() {
        return titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public long getNbEtudiants() {
        return nbEtudiants;
    }

    public void setNbEtudiants(long nbEtudiants) {
        this.nbEtudiants = nbEtudiants;
    }
}
