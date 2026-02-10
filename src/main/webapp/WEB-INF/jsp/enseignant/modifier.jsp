<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Modifier le Cours - FPL Academy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --bg-light: #f8fafc; /* Very light slate blue/gray */
            --card-bg: #ffffff;
            --input-focus: #f1f5f9;
            --text-main: #1e293b;
            --text-muted: #64748b;
        }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: var(--bg-light);
            color: var(--text-main);
            min-height: 100vh;
        }

        .card-premium {
            background-color: var(--card-bg);
            border: 1px solid #e2e8f0;
            border-radius: 24px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.03);
            overflow: hidden;
        }

        .card-header-premium {
            background: #ffffff;
            border-bottom: 1px solid #f1f5f9;
            padding: 2.5rem 2.5rem 1.5rem 2.5rem;
        }

        .form-label {
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 1.2px;
            color: var(--text-muted);
            font-weight: 700;
            margin-bottom: 0.6rem;
        }

        .form-control {
            background-color: #ffffff;
            border: 1.5px solid #e2e8f0;
            color: var(--text-main);
            border-radius: 14px;
            padding: 0.85rem 1.2rem;
            transition: all 0.2s ease-in-out;
            font-size: 0.95rem;
        }

        .form-control:focus {
            background-color: #ffffff;
            border-color: #764ba2;
            box-shadow: 0 0 0 4px rgba(118, 75, 162, 0.1);
            outline: none;
        }

        /* Subtle glow for the whole form area on focus */
        .form-control:focus::placeholder {
            color: #cbd5e1;
        }

        .btn-save {
            background: var(--primary-gradient);
            border: none;
            color: white;
            padding: 14px 40px;
            border-radius: 14px;
            font-weight: 700;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(118, 75, 162, 0.2);
        }

        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(118, 75, 162, 0.3);
            color: white;
            filter: brightness(1.1);
        }

        .btn-cancel {
            color: var(--text-muted);
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
            transition: color 0.2s;
        }

        .btn-cancel:hover {
            color: var(--text-main);
        }

        /* Clean Scrollbar */
        textarea::-webkit-scrollbar { width: 6px; }
        textarea::-webkit-scrollbar-track { background: #f1f5f9; }
        textarea::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 10px; }
    </style>
</head>
<body>

<div class="container mt-5 mb-5">
    <div class="row justify-content-center">
        <div class="col-md-10 col-lg-8">
            <div class="card card-premium">
                <div class="card-header-premium text-center">
                    <h2 class="fw-bold mb-1" id="pageTitle" style="color: #0f172a;">Modifier le cours</h2>
                    <p class="text-muted mb-0">Mettez &agrave; jour les d&eacute;tails de votre formation professionnelle.</p>
                </div>
                
                <div class="card-body p-4 p-md-5">
                    <form id="modifierForm" action="javascript:void(0);">
                        <input type="hidden" id="coursId" />

                        <div class="mb-4">
                            <label class="form-label">Titre du cours</label>
                            <input type="text" id="titre" class="form-control" placeholder="Ex: Ma&icirc;trise de Spring Boot" required />
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Description courte</label>
                            <textarea id="description" class="form-control" rows="2" placeholder="Un r&eacute;sum&eacute; accrocheur pour vos &eacute;tudiants..." required></textarea>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Contenu d&eacute;taill&eacute;</label>
                            <textarea id="contenu" class="form-control" rows="10" placeholder="R&eacute;digez le corps de votre cours..."></textarea>
                        </div>

                        <div class="d-flex justify-content-between align-items-center mt-5">
                            <a href="/enseignant/dashboard" class="btn-cancel">
                                <i class="fas fa-chevron-left me-1"></i> Annuler
                            </a>
                            <button type="submit" class="btn btn-save" id="submitBtn">
                                Sauvegarder les modifications
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            
            <div class="text-center mt-4 text-muted small" style="letter-spacing: 1px;">
                <strong>FPL ACADEMY</strong> &bull; ESPACE ENSEIGNANT
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', () => {

	const pathParts = window.location.pathname.split('/');
	const courseId = pathParts[pathParts.length - 1];

    async function loadCourse() {
        try {
            const response = await fetch(`/api/enseignant/cours/\${courseId}`);
            if (!response.ok) throw new Error('Failed to load course');

            const course = await response.json();
            populateForm(course);
        } catch (error) {
            console.error('Error loading course:', error);
        }
    }

    function populateForm(course) {
        document.getElementById('coursId').value = course.id;
        document.getElementById('titre').value = course.titre;
        document.getElementById('description').value = course.description || '';
        document.getElementById('contenu').value = course.contenu || '';
        document.getElementById('pageTitle').textContent = 'Modifier : ' + course.titre;
    }

    document.getElementById('modifierForm').addEventListener('submit', async (e) => {
        e.preventDefault();
        const submitBtn = document.getElementById('submitBtn');
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span> Traitement...';

        const formData = {
            titre: document.getElementById('titre').value,
            description: document.getElementById('description').value,
            contenu: document.getElementById('contenu').value
        };

        try {
            const response = await fetch(`/api/enseignant/cours/\${courseId}`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(formData)
            });

            if (!response.ok) throw new Error();
            window.location.href = '/enseignant/dashboard?success=updated';
        } catch (error) {
            alert('Erreur lors de la modification.');
            submitBtn.disabled = false;
            submitBtn.textContent = 'Sauvegarder les modifications';
        }
    });

    loadCourse(); 
});
</script>
</body>
</html>