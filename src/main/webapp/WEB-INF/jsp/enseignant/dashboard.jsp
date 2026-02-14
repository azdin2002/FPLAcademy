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
            background-color: #f8f9fa;
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

        /* --- Nouveau Cours Button --- */
        .btn-new-course {
            background-color: #764ba2;
            color: white;
            border: none;
            font-weight: 600;
            padding: 10px 24px;
            border-radius: 25px;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 0.95rem;
        }

        .btn-new-course:hover {
            background-color: #61398a;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(118, 75, 162, 0.2);
        }

        /* --- Stats Card - Fixed alignment --- */
        .stats-wrapper {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 24px;
        }

        .stats-block {
            display: flex;
            align-items: baseline;
            background: white;
            padding: 8px 20px;
            border-radius: 12px;
            border: 1px solid #e9ecef;
        }

        .stat-number {
            font-size: 2.2rem;
            font-weight: 700;
            color: #764ba2;
            line-height: 1;
            margin-right: 8px;
        }
        .stat-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #6c757d;
            font-weight: 600;
        }

        /* --- Table Container --- */
        .table-container {
            background-color: #ffffff;
            border: 1px solid #e9ecef;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            padding: 0 2rem;
        }

        /* --- Unified Table Styling --- */
        .table {
            margin-bottom: 0;
            width: 100%;
        }

        .table thead th {
            background-color: #ffffff;
            color: #6c757d;
            border-bottom: 1px solid #e9ecef;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 1px;
            padding: 1.2rem 0;
        }

        .table tbody tr {
            transition: background-color 0.2s ease;
            cursor: pointer;
        }

        .table tbody tr:hover {
            background-color: #fcfaff;
        }

        .table td {
            border-top: 1px solid #e9ecef;
            vertical-align: middle;
            padding: 1.5rem 0;
        }

        /* --- Content Styling --- */
        .course-title {
            font-weight: 700;
            color: #212529;
            font-size: 1.1rem;
            margin-bottom: 0.2rem;
        }

        .course-description-text {
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

        .divider {
            border-top: 1px solid #e9ecef;
            opacity: 1;
            margin: 2rem 0;
        }

        @media (max-width: 768px) {
            .stats-wrapper {
                flex-direction: column-reverse;
                align-items: flex-end;
                gap: 12px;
                margin-top: 1rem;
            }

            .btn-new-course {
                width: 100%;
                justify-content: center;
            }

            .stats-block {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>

<%@ include file="../common/header.jsp" %>

<div class="container mt-5 main-content">
    <!-- Header with better aligned elements -->
    <div class="row mb-4 align-items-center">
        <div class="col-md-6">
            <h2 class="fw-bold text-dark mb-2">Tableau de bord Enseignant</h2>
            <p class="text-muted mb-0" style="font-size: 1rem;">
                Gérez vos contenus et suivez la progression de vos étudiants.
            </p>
        </div>
        <div class="col-md-6 mt-4 mt-md-0">
            <div class="stats-wrapper">
                <a href="/enseignant/publier" class="btn-new-course">
                    <i class="fas fa-plus"></i> Nouveau Cours
                </a>
                <div class="stats-block">
                    <span class="stat-number" id="totalCourses">0</span>
                    <span class="stat-label">Cours Publiés</span>
                </div>
            </div>
        </div>
    </div>

    <hr class="divider">

    <div id="successMessage" class="alert alert-success border-0 shadow-sm mb-4" style="display:none; background-color: #d1e7dd; color: #0f5132;"></div>

    <div class="table-container mb-5">
        <table class="table">
            <thead>
            <tr>
                <th>Détails du Cours</th>
                <th class="text-center">Communauté</th>
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
    function escapeHtml(text) {
        if (text === null || text === undefined) return '';
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    async function loadCours() {
        try {
            const response = await fetch('/api/enseignant/cours');

            if (response.status === 401) {
                window.location.href = '/connexion';
                return;
            }

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
            tbody.innerHTML =
                `<tr>
                    <td colspan="3" class="text-center py-5 text-muted">
                        Vous n'avez pas encore publié de cours.
                    </td>
                 </tr>`;
            return;
        }

        tbody.innerHTML = courses.map(cours => {

            const studentCount = cours.nombreInscrits || 0;
            const studentText = studentCount <= 1 ? 'Étudiant' : 'Étudiants';

            return `
                <tr onclick="window.location.href='/enseignant/cours/\${cours.id}'">
                    <td>
                        <div class="course-title">\${escapeHtml(cours.titre)}</div>
                        <div class="course-description-text">\${escapeHtml(cours.description) || 'Aucune description.'}</div>
                    </td>
                    <td class="text-center">
                        <a href="/enseignant/cours/\${cours.id}/inscriptions"
                           class="stat-badge"
                           onclick="event.stopPropagation()">
                            <i class="fas fa-user-friends"></i>
                            \${studentCount} \${studentText}
                        </a>
                    </td>
                    <td class="text-end">
                        <div class="action-buttons"
                             onclick="event.stopPropagation()">
                            <a href="/enseignant/modifier/\${cours.id}"
                               title="Modifier">
                                <i class="fas fa-pen"></i>
                            </a>
                            <button class="btn-delete"
                                    onclick="deleteCours(\${cours.id}, event)"
                                    title="Supprimer">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </div>
                    </td>
                </tr>
            `;
        }).join('');
    }

    async function deleteCours(id, event) {
        event.stopPropagation();

        if (!confirm('Êtes-vous sûr de vouloir supprimer ce cours ?')) return;

        try {
            const response = await fetch(`/api/enseignant/cours/\${id}`, {
                method: 'DELETE'
            });

            if (!response.ok) throw new Error('Failed to delete course');

            window.location.href =
                '/enseignant/dashboard?success=deleted';

        } catch (error) {
            console.error('Error deleting course:', error);
            alert('Erreur lors de la suppression.');
        }
    }

    function showSuccessMessage(message) {
        const msgDiv = document.getElementById('successMessage');
        msgDiv.textContent = message;
        msgDiv.style.display = 'block';

        setTimeout(() => {
            msgDiv.style.display = 'none';
        }, 4000);
    }

  

    document.addEventListener('DOMContentLoaded', loadCours);
</script>

</body>
</html>