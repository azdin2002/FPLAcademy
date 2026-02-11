<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier un Cours - FPL Academy</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8f9fa;
            color: #212529;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .main-content {
            flex: 1;
            padding-bottom: 3rem;
        }

        /* --- Return Button --- */
        .btn-return {
            background-color: rgba(118, 75, 162, 0.08);
            color: #764ba2;
            padding: 8px 20px;
            border-radius: 40px;
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
        .btn-return i {
            font-size: 0.8rem;
        }

        /* --- Card Styling --- */
        .card-premium {
            background-color: #ffffff;
            border: 1px solid #e9ecef;
            border-radius: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.03);
        }
        .card-header-clean {
            background-color: #ffffff;
            border-bottom: 1px solid #e9ecef;
            padding: 1.5rem 2rem;
            border-radius: 20px 20px 0 0;
        }

        /* --- Form Styling --- */
        .form-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #6c757d;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        .form-control {
            border: 1.5px solid #e9ecef;
            border-radius: 12px;
            padding: 0.75rem 1rem;
            font-size: 0.95rem;
            transition: all 0.2s;
            width: 100%;
        }
        .form-control:focus {
            border-color: #764ba2;
            box-shadow: 0 0 0 3px rgba(118, 75, 162, 0.1);
            outline: none;
        }
        .form-control.error {
            border-color: #dc3545;
            background-color: #fff5f5;
        }

        /* --- Error Message --- */
        .error-message {
            color: #dc3545;
            font-size: 0.75rem;
            font-weight: 600;
            margin-top: 0.5rem;
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .error-message i {
            font-size: 0.7rem;
        }

        /* --- Buttons --- */
        .btn-purple {
            background-color: #764ba2;
            border: none;
            color: white;
            font-weight: 600;
            border-radius: 40px;
            padding: 10px 28px;
            font-size: 0.9rem;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
        }
        .btn-purple:hover:not(:disabled) {
            background-color: #5a377d;
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(118, 75, 162, 0.2);
        }
        .btn-purple:disabled {
            background-color: #c4b5d1;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .btn-cancel {
            color: #6c757d;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
            padding: 10px 0;
            transition: color 0.2s;
        }
        .btn-cancel:hover {
            color: #212529;
        }

        .border-top {
            border-top: 1px solid #e9ecef !important;
            margin-top: 1.5rem;
            padding-top: 1.5rem;
        }

        @media (max-width: 768px) {
            .card-body {
                padding: 1.5rem !important;
            }
            .card-header-clean {
                padding: 1.25rem 1.5rem;
            }
        }
    </style>
</head>
<body>

<%@ include file="../common/header.jsp" %>

<div class="container mt-4 main-content">
    <!-- Header -->
    <div class="row mb-3 align-items-center">
        <div class="col-12 col-md-6 mb-3 mb-md-0">
            <a href="/enseignant/dashboard" class="btn-return">
                <i class="fas fa-arrow-left"></i> Retour au Dashboard
            </a>
        </div>
        <div class="col-12 col-md-6 text-md-end">
            <span class="text-muted small fw-bold text-uppercase" style="letter-spacing: 1px; background: #f8f9fa; padding: 6px 16px; border-radius: 40px;">
                <i class="fas fa-edit me-2"></i>Mode Édition
            </span>
        </div>
    </div>

    <!-- Form Card -->
    <div class="row justify-content-center">
        <div class="col-md-10 col-lg-8">
            <div class="card card-premium">
                <div class="card-header-clean">
                    <h3 class="fw-bold mb-1 text-dark" style="letter-spacing: -0.02em;">Modifier le Cours</h3>
                    <p class="text-muted mb-0 small">Mettez à jour les informations de votre formation.</p>
                </div>
                <div class="card-body p-4 p-md-5">
                    <form id="coursForm" novalidate>
                        <div class="mb-4">
                            <label class="form-label">Titre du cours</label>
                            <input type="text" id="titre" name="titre" class="form-control" required>
                            <div id="titreError" class="error-message" style="display: none;">
                                <i class="fas fa-exclamation-circle"></i> Le titre est requis
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Description courte</label>
                            <textarea id="description" name="description" class="form-control" rows="2" required></textarea>
                            <div id="descriptionError" class="error-message" style="display: none;">
                                <i class="fas fa-exclamation-circle"></i> La description est requise
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Contenu détaillé</label>
                            <textarea id="contenu" name="contenu" class="form-control" rows="10" required></textarea>
                            <div id="contenuError" class="error-message" style="display: none;">
                                <i class="fas fa-exclamation-circle"></i> Le contenu ne peut pas être vide
                            </div>
                            <div class="form-text text-muted small mt-2">
                                <i class="fas fa-info-circle me-1"></i> HTML supporté pour la mise en forme
                            </div>
                        </div>

                        <div class="border-top d-flex justify-content-between align-items-center">
                            <a href="/enseignant/dashboard" class="btn-cancel">
                                <i class="fas fa-times me-1"></i> Annuler
                            </a>
                            <button type="submit" class="btn-purple" id="submitBtn" disabled>
                                <i class="fas fa-save me-2"></i>Enregistrer les modifications
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>

<script>
    const pathParts = window.location.pathname.split('/');
    const courseId = pathParts[pathParts.length - 1];

    const form = document.getElementById('coursForm');
    const titre = document.getElementById('titre');
    const description = document.getElementById('description');
    const contenu = document.getElementById('contenu');
    const submitBtn = document.getElementById('submitBtn');
    const titreError = document.getElementById('titreError');
    const descriptionError = document.getElementById('descriptionError');
    const contenuError = document.getElementById('contenuError');

    let touched = {
        titre: false,
        description: false,
        contenu: false
    };

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
        titre.value = course.titre;
        description.value = course.description || '';
        contenu.value = course.contenu || '';
        updateSubmitButton(); // Enable button if form is valid on load
    }

    function validateField(field, errorElement, fieldName) {
        const isValid = field.value.trim() !== '';

        if (touched[fieldName] && !isValid) {
            field.classList.add('error');
            errorElement.style.display = 'flex';
        } else {
            field.classList.remove('error');
            errorElement.style.display = 'none';
        }
        return isValid;
    }

    function updateSubmitButton() {
        const isTitreValid = titre.value.trim() !== '';
        const isDescValid = description.value.trim() !== '';
        const isContenuValid = contenu.value.trim() !== '';
        submitBtn.disabled = !(isTitreValid && isDescValid && isContenuValid);
    }

    // Event Listeners
    function addValidationListeners(field, errorElement, fieldName) {
        field.addEventListener('blur', () => {
            touched[fieldName] = true;
            validateField(field, errorElement, fieldName);
            updateSubmitButton();
        });
        field.addEventListener('input', () => {
            validateField(field, errorElement, fieldName);
            updateSubmitButton();
        });
    }

    addValidationListeners(titre, titreError, 'titre');
    addValidationListeners(description, descriptionError, 'description');
    addValidationListeners(contenu, contenuError, 'contenu');

    // Form submission
    form.addEventListener('submit', async (e) => {
        e.preventDefault();

        if (submitBtn.disabled) return;

        const originalText = submitBtn.innerHTML;
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Enregistrement...';

        const formData = {
            titre: titre.value.trim(),
            description: description.value.trim(),
            contenu: contenu.value.trim()
        };

        try {
            const response = await fetch(`/api/enseignant/cours/\${courseId}`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(formData)
            });

            if (!response.ok) throw new Error('Failed to update course');
            window.location.href = '/enseignant/dashboard?success=updated';
        } catch (error) {
            console.error('Error updating course:', error);
            alert('Erreur lors de la modification. Veuillez réessayer.');
            submitBtn.disabled = false;
            submitBtn.innerHTML = originalText;
        }
    });

    // Initial load
    loadCourse();
</script>

</body>
</html>