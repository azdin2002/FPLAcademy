<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Modifier le Cours - FPL Academy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow border-0">
                <div class="card-header bg-warning text-dark py-3">
                    <h4 class="mb-0" id="pageTitle">Modifier le cours</h4>
                </div>
                <div class="card-body p-4">
                    <form id="modifierForm" action="javascript:void(0);">

                        <input type="hidden" id="coursId" />

                        <div class="mb-3">
                            <label class="form-label fw-bold">Titre du cours</label>
                            <input type="text" id="titre" class="form-control" required />
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Description courte</label>
                            <textarea id="description" class="form-control" rows="2" required></textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Contenu du cours</label>
                            <textarea id="contenu" class="form-control" rows="12" 
                                      placeholder="Rédigez votre cours ici..."></textarea>
                        </div>

                        <div class="d-flex justify-content-between mt-4">
                            <a href="/enseignant/dashboard" class="btn btn-outline-secondary">Annuler</a>
                            <button type="submit" class="btn btn-warning px-5 fw-bold" id="submitBtn">
                                Enregistrer les modifications
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            
            <div class="text-center mt-3 text-muted small" id="coursInfo">
                <!-- Course ID info will be shown here -->
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', () => {

	const pathParts = window.location.pathname.split('/');
	const courseId = pathParts[pathParts.length - 1];

    console.log("Course ID:", courseId);

    async function loadCourse() {
        try {
            const response = await fetch(`/api/enseignant/cours/\${courseId}`);
            if (!response.ok) throw new Error('Failed to load course');

            const course = await response.json();
            populateForm(course);
        } catch (error) {
            console.error('Error loading course:', error);
            alert('Erreur lors du chargement du cours.');
        }
    }

    function populateForm(course) {
        document.getElementById('coursId').value = course.id;
        document.getElementById('titre').value = course.titre;
        document.getElementById('description').value = course.description || '';
        document.getElementById('contenu').value = course.contenu || '';
        document.getElementById('pageTitle').textContent =
            'Modifier le cours : ' + course.titre;
    }

    document.getElementById('modifierForm')
        .addEventListener('submit', async (e) => {

        e.preventDefault();

        const submitBtn = document.getElementById('submitBtn');
        submitBtn.disabled = true;
        submitBtn.textContent = 'Enregistrement...';

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
            submitBtn.textContent = 'Enregistrer les modifications';
        }
    });

    loadCourse(); 

});
</script>

</body>
</html>
