<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Espace Enseignant - FPL Academy</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
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

        /* --- Header Styling --- */
        .btn-purple {
            background-color: #764ba2;
            border-color: #764ba2;
            color: white;
            font-weight: 600;
            transition: all 0.2s ease;
        }
        .btn-purple:hover {
            background-color: #5a377d;
            border-color: #5a377d;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(118, 75, 162, 0.2);
        }
        
        /* --- Updated Header Button to match stat-badge style --- */
			.btn-new-course {
			    background-color: rgba(118, 75, 162, 0.08); /* Light purple tint */
			    color: #764ba2; /* Dark purple text */
			    border: 1px solid rgba(118, 75, 162, 0.1); /* Subtle border */
			    font-weight: 600;
			    padding: 10px 24px;
			    border-radius: 25px;
			    transition: all 0.2s ease;
			    text-decoration: none;
			    display: inline-flex;
			    align-items: center;
			    gap: 8px;
			}
			
			.btn-new-course:hover {
			    background-color: #764ba2; /* Switches to solid purple on hover */
			    color: white;
			    transform: translateY(-2px);
			    box-shadow: 0 4px 12px rgba(118, 75, 162, 0.2);
			}

        /* --- Table Container (Matches Student Cards) --- */
        .table-container {
            background-color: #ffffff;
            border: 1px solid #e9ecef;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }

        /* --- Unified Table Styling --- */
        .table { margin-bottom: 0; }
        
        .table thead th {
            background-color: #ffffff; 
            color: #6c757d;
            border-bottom: 1px solid #e9ecef;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 1px;
            padding: 1.2rem 1.5rem;
        }

        .table tbody tr {
            transition: background-color 0.2s ease;
            cursor: pointer;
        }

        .table tbody tr:hover {
            background-color: #fcfaff; /* Subtle purple-tinted hover */
        }

        .table td {
            border-top: 1px solid #e9ecef;
            vertical-align: middle;
            padding: 1.5rem;
        }

        /* --- Content Styling --- */
        .course-title {
            font-weight: 700;
            color: #212529;
            font-size: 1.1rem;
            margin-bottom: 0.2rem;
        }
        
        .course-desc {
            color: #6c757d;
            font-size: 0.85rem;
            max-width: 400px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .stat-badge {
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
        }

        .stat-badge:hover {
            background-color: #764ba2;
            color: white;
            transform: scale(1.05);
        }

        .action-buttons a, .action-buttons button {
            color: #adb5bd;
            background: none;
            border: none;
            padding: 0.5rem;
            margin-left: 0.3rem;
            transition: all 0.2s ease;
        }

        .action-buttons a:hover { color: #764ba2; }
        .action-buttons .btn-delete:hover { color: #dc3545; }

        /* Unified Stats Header */
        .stat-number {
            font-size: 3rem;
            font-weight: 800;
            color: #764ba2;
            line-height: 1;
        }
        .stat-label {
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #6c757d;
            font-weight: 600;
        }
    </style>
</head>
<body>

<%@ include file="../common/header.jsp" %>

<div class="container mt-5 main-content">
    <div class="row mb-4 align-items-end">
        <div class="col-md-8">
            <h2 class="fw-bold text-dark mb-2">Tableau de bord Enseignant</h2>
            <p class="text-muted lead mb-0" style="font-size: 1.1rem;">
                G&eacute;rez vos contenus et suivez la progression de vos &eacute;tudiants.
            </p>
        </div>
        <div class="col-md-4 text-md-end mt-4 mt-md-0">
             <div class="d-inline-block text-end me-4">
                <div class="stat-number" id="totalCourses">0</div>
                <div class="stat-label">Cours Publi&eacute;s</div>
             </div>
             <a href="/enseignant/publier" class="btn-new-course shadow-sm">
    			<i class="fas fa-plus"></i> Nouveau Cours
			</a>
        </div>
    </div>

    <hr class="mb-5" style="border-top: 1px solid #e9ecef; opacity: 1;">

    <div id="successMessage" class="alert alert-success border-0 shadow-sm mb-4" style="display:none; background-color: #d1e7dd; color: #0f5132;"></div>

    <div class="table-container mb-5">
        <table class="table">
            <thead>
                <tr>
                    <th>D&eacute;tails du Cours</th>
                    <th class="text-center">Communaut&eacute;</th>
                    <th class="text-end">Gestion</th>
                </tr>
            </thead>
            <tbody id="coursTableBody">
                </tbody>
        </table>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>

<script>
    // This function MUST exist in the global scope for the template literal to work
    function escapeHtml(text) {
        if (text === null || text === undefined) return '';
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    async function loadCours() {
        try {
            const response = await fetch('/api/enseignant/cours');
            if (!response.ok) throw new Error('Failed to load courses');

            const courses = await response.json();
            displayCours(courses);

            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('success') === 'created') {
                showSuccessMessage('Cours publié avec succès !');
            } else if (urlParams.get('success') === 'deleted') {
                showSuccessMessage('Cours supprimé avec succès !');
            }
        } catch (error) {
            console.error('Error loading courses:', error);
            showError();
        }
    }

    function displayCours(courses) {
        const tbody = document.getElementById('coursTableBody');
        const countElement = document.getElementById('totalCourses');

        countElement.textContent = courses ? courses.length : 0;

        if (!courses || courses.length === 0) {
            tbody.innerHTML = `<tr><td colspan="3" class="text-center py-5 text-muted">Vous n'avez pas encore publié de cours.</td></tr>`;
            return;
        }

        tbody.innerHTML = courses.map(cours => {
            const studentCount = cours.nbEtudiants || 0;
            const studentText = studentCount <= 1 ? 'Étudiant' : 'Étudiants';

            return `
                <tr onclick="window.location.href='/enseignant/cours/\${cours.id}'">
                    <td>
                        <div class="course-title">\${escapeHtml(cours.titre)}</div>
                        <div class="small text-muted course-description-text">\${escapeHtml(cours.description) || 'Aucune description.'}</div>
                    </td>
                    <td class="text-center">
                        <a href="/enseignant/cours/\${cours.id}/inscriptions" class="stat-badge" onclick="event.stopPropagation()">
                            <i class="fas fa-user-friends"></i> \${studentCount} \${studentText}
                        </a>
                    </td>
                    <td class="text-end">
                        <div class="action-buttons" onclick="event.stopPropagation()">
                            <a href="/enseignant/modifier/\${cours.id}" title="Modifier">
                                <i class="fas fa-pen"></i>
                            </a>
                            <button class="btn-delete" onclick="deleteCours(\${cours.id})" title="Supprimer">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </div>
                    </td>
                </tr>
            `;
        }).join('');
    }

    async function deleteCours(id) {
        event.stopPropagation();
        if (!confirm('Êtes-vous sûr de vouloir supprimer ce cours ? Cette action est irréversible.')) return;

        try {
            const response = await fetch(`/api/enseignant/cours/\${id}`, { method: 'DELETE' });
            if (!response.ok) throw new Error('Failed to delete course');
            window.location.href = '/enseignant/dashboard?success=deleted';
        } catch (error) {
            console.error('Error deleting course:', error);
            alert('Erreur lors de la suppression du cours.');
        }
    }

    function showSuccessMessage(message) {
        const msgDiv = document.getElementById('successMessage');
        msgDiv.textContent = message;
        msgDiv.style.display = 'block';
        setTimeout(() => { msgDiv.style.display = 'none'; }, 5000);
    }

    function showError() {
        document.getElementById('coursTableBody').innerHTML = `<tr><td colspan="3" class="text-center py-5 text-danger">Erreur lors du chargement des cours.</td></tr>`;
    }

    document.addEventListener('DOMContentLoaded', loadCours);
</script>
</body>
</html>