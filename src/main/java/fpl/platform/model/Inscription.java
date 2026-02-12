package fpl.platform.model;

import java.time.LocalDateTime;

import jakarta.persistence.*;
import lombok.*;


@Entity
@Table(
    name = "inscriptions",
    uniqueConstraints = {
        @UniqueConstraint(columnNames = {"etudiant_id", "cours_id"})
    }
)
public class Inscription {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "etudiant_id", nullable = false)
    private User etudiant;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cours_id", nullable = false)
    private Cours cours;

    @Column(nullable = false)
    private int progression = 0;

    @Column(nullable = false)
    private boolean termine = false;

    @Column(nullable = false, updatable = false)
    private LocalDateTime dateInscription;

    @PrePersist
    public void prePersist() {
        this.dateInscription = LocalDateTime.now();
    }

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Inscription() {
		super();
	}

	public User getEtudiant() {
		return etudiant;
	}

	public void setEtudiant(User etudiant) {
		this.etudiant = etudiant;
	}

	public Cours getCours() {
		return cours;
	}

	public void setCours(Cours cours) {
		this.cours = cours;
	}

	public int getProgression() {
		return progression;
	}

	public void setProgression(int progression) {
		this.progression = progression;
	}

	public boolean isTermine() {
		return termine;
	}

	public void setTermine(boolean termine) {
		this.termine = termine;
	}

	public LocalDateTime getDateInscription() {
		return dateInscription;
	}

	public void setDateInscription(LocalDateTime dateInscription) {
		this.dateInscription = dateInscription;
	}

	public Inscription(Long id, User etudiant, Cours cours, int progression, boolean termine,
			LocalDateTime dateInscription) {
		super();
		this.id = id;
		this.etudiant = etudiant;
		this.cours = cours;
		this.progression = progression;
		this.termine = termine;
		this.dateInscription = dateInscription;
	}
    
}
