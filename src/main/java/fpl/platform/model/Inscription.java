package fpl.platform.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import jakarta.persistence.*;

@Entity 
@Table(name = "inscriptions")
public class Inscription {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "etudiant_id")
    @JsonIgnoreProperties({"roles", "password"})
    private User etudiant;

    @ManyToOne
    @JoinColumn(name = "cours_id")
    @JsonIgnoreProperties("inscriptions")
    private Cours cours;

    private int progression = 0;
    private boolean termine = false;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public int getProgression() { return progression; }
    public void setProgression(int progression) { this.progression = progression; }
    
    public boolean isTermine() { return termine; }
    public void setTermine(boolean termine) { this.termine = termine; }

    public User getEtudiant() { return etudiant; }
    public void setEtudiant(User etudiant) { this.etudiant = etudiant; }

    public Cours getCours() { return cours; }
    public void setCours(Cours cours) { this.cours = cours; }
}