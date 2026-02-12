<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier le Cours - FPL Academy</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8f9fa; /* Unified Light background */
            color: #212529;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .main-content { flex: 1; }

        /* --- Return Button Style (Matches stat-badge) --- */
        .btn-return {
            background-color: rgba(118, 75, 162, 0.08);
            color: #764ba2;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 0.85rem;
            border: 1px solid rgba(118, 75, 162, 0.1);
        }
        .btn-return:hover {
            background-color: #764ba2;
            color: white;
            transform: translateX(-5px);
        }

        /* --- Card Styling --- */
        .card-premium {
            background-color: #ffffff;
            border: 1px solid #e9ecef;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            overflow: hidden;
        }
        .card-header-clean {
            background-color: #ffffff;
            border-bottom: 1px solid #e9ecef;
            padding: 1.5rem 2rem;
        }

        /* --- Form Styling --- */
        .form-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1.2px;
            color: #6c757d;
            font-weight: 700;
            margin-bottom: 0.6rem;
        }
        .form-control {
            border: 1.5px solid #e9ecef;
            border-radius: 10px;
            padding: 0.85rem 1.1rem;
            font-size: 0.95rem;
            transition: all 0.2s;
        }
        .form-control:focus {
            border-color: #764ba2;
            box-shadow: 0 0 0 4px rgba(118, 75, 162, 0.1);
            outline: none;
        }

        /* --- Action Buttons --- */
        .btn-save {
            background-color: #764ba2;
            border-color: #764ba2;
            color: white;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: 700;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(118, 75, 162, 0.2);
        }
        .btn-save:hover {
            background-color: #5a377d;
            transform: translateY(-2px);
            box-shadow: 0 8px 18px rgba(118, 75, 162, 0.3);
            color: white;
        }
        .btn-cancel-text {
            color: #6c757d;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
            transition: color 0.2s;
        }
        .btn-cancel-text:hover { color: #212529; }
        
        textarea::-webkit-scrollbar { width: 6px; }
        textarea::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 10px; }
    </style>
</head>
<body>

<%@ include file="../common/header.jsp" %>

<div class="container mt-5 main-content">
    <div class="row mb-4 align-items-center">
        <div class="col-md-6">
            <a href="/enseignant/dashboard" class="btn-return">
                <i class="fas fa-arrow-left"></i> Retour au Dashboard
            </a>
        </div>
        <div class="col-md-6 text-md-end mt-3 mt-md-0">
            <span class="text-muted small fw-bold text-uppercase" style="letter-spacing: 1px;">Mode Instructor &bull; Edition</span>
        </div>
    </div>

    <div class="row justify-content-center mb-5">
        <div class="col-md-10 col-lg-8">
            <div class="card card-premium">
                <div class="card-header-clean text-center">
                    <h2 class="fw-bold mb-1 text-dark" id="pageTitle">Modifier le cours</h2>
                    <p class="text-muted mb-0 small">Mettez &agrave; jour les d&eacute;tails et le contenu de votre formation.</p>
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
                            <textarea id="description" class="form-control" rows="2" placeholder="R&eacute;sumez l'objectif du cours..." required></textarea>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Contenu d&eacute;taill&eacute;</label>
                            <textarea id="contenu" class="form-control" rows="12" placeholder="R&eacute;digez le corps de votre cours..."></textarea>
                        </div>

                        <div class="d-flex justify-content-between align-items-center mt-5 pt-4 border-top">
                            <a href="/enseignant/dashboard" class="btn-cancel-text">
                                Annuler
                            </a>
                            <button type="submit" class="btn btn-save" id="submitBtn">
                                <i class="fas fa-save me-2"></i>Enregistrer les modifications
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            
            <div class="text-center mt-4 text-muted small" style="letter-spacing: 1px; opacity: 0.6;">
                <strong>FPL ACADEMY</strong> &bull; GESTION DE CONTENU
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
<script>
document.addEventListener('DOMContentLoaded', () => {

    // Extract ID safely
    const pathParts = window.location.pathname.split('/');
    const courseId = pathParts[pathParts.length - 1];

    if (!courseId || isNaN(courseId)) {
        alert("ID du cours invalide.");
        return;
    }

    async function loadCourse() {
        try {
            const response = await fetch(`/api/enseignant/cours/\${courseId}`);
            if (!response.ok) throw new Error('Failed to load course');

            const course = await response.json();
            populateForm(course);

        } catch (error) {
            console.error('Error loading course:', error);
            alert("Impossible de charger le cours.");
        }
    }

    function populateForm(course) {
        document.getElementById('coursId').value = course.id;
        document.getElementById('titre').value = course.titre || '';
        document.getElementById('description').value = course.description || '';
        document.getElementById('contenu').value = course.contenu || '';
        document.getElementById('pageTitle').textContent =
            'Modifier : ' + (course.titre || '');
    }

    document.getElementById('modifierForm').addEventListener('submit', async (e) => {
        e.preventDefault();

        const submitBtn = document.getElementById('submitBtn');
        submitBtn.disabled = true;
        submitBtn.innerHTML =
            '<span class="spinner-border spinner-border-sm me-2"></span> Enregistrement...';

        const formData = {
            titre: document.getElementById('titre').value,
            description: document.getElementById('description').value,
            contenu: document.getElementById('contenu').value
        };

        try {
            const response = await fetch(`/api/enseignant/cours/\${courseId}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(formData)
            });

            if (!response.ok) throw new Error();

            // Redirect with success message
            window.location.href = '/enseignant/dashboard?success=updated';

        } catch (error) {
            alert('Erreur lors de la modification.');
            submitBtn.disabled = false;
            submitBtn.innerHTML =
                '<i class="fas fa-save me-2"></i>Enregistrer les modifications';
        }
    });

    loadCourse();
});
</script>

</body>
</html>