package fpl.platform.dto;

public class CoursResponse {

    private Long id;
    private String titre;
    private String description;
    private String contenu;
    private Integer capaciteMax;
    private String enseignantUsername;
    private int nombreInscrits;

    public CoursResponse(Long id,
                         String titre,
                         String description,
                         String contenu,
                         Integer capaciteMax,
                         String enseignantUsername,
                         int nombreInscrits) {
        this.id = id;
        this.titre = titre;
        this.description = description;
        this.contenu = contenu;
        this.capaciteMax = capaciteMax;
        this.enseignantUsername = enseignantUsername;
        this.nombreInscrits = nombreInscrits;
    }

    public Long getId() { return id; }
    public String getTitre() { return titre; }
    public String getDescription() { return description; }
    public String getContenu() { return contenu; }
    public Integer getCapaciteMax() { return capaciteMax; }
    public String getEnseignantUsername() { return enseignantUsername; }
    public int getNombreInscrits() { return nombreInscrits; }
}
