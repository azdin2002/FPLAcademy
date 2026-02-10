<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard Enseignant - FPL Academy</title>
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8f9fa; /* Light theme background */
            color: #212529; /* Dark text */
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .main-content { flex: 1; }

        /* --- Header --- */
        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }
        .btn-purple {
            background-color: #764ba2;
            border-color: #764ba2;
            color: white;
            font-weight: 600;
            transition: all 0.2s ease;
        }
        .btn-purple:hover {
            background-color: #5a377d; /* Darker purple on hover */
            border-color: #5a377d;
            color: white; /* Ensure text remains white on hover */
            transform: translateY(-2px);
        }

        /* --- Table Container --- */
        .table-container {
            background-color: #ffffff; /* White background for the table card */
            border: 1px solid #dee2e6;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        /* --- Table Styling --- */
        .table {
            margin-bottom: 0;
        }
        .table thead th {
            background-color: #e9ecef; /* Light header for the table */
            color: #495057;
            border-bottom: 1px solid #dee2e6;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.8rem;
            padding: 1rem 1.5rem;
        }
        .table tbody tr {
            transition: background-color 0.2s ease;
            cursor: pointer;
        }
        .table tbody tr:hover {
            background-color: #f1f3f5; /* Subtle gray hover for rows */
        }
        .table td {
            border-top: 1px solid #e9ecef;
            vertical-align: middle;
            padding: 1.5rem;
        }

        /* --- Interactive Elements in Table --- */
        .course-title {
            font-weight: 700; /* Bolder */
            color: #212529; /* Very dark black for clarity */
            font-size: 1.3rem; /* Significantly larger font size */
            padding-left: 0.5rem; /* Padding on the left */
        }
        .course-description-text { /* New class for description */
            padding-left: 0.5rem; /* Align with title */
        }
        .stat-badge {
            background-color: rgba(118, 75, 162, 0.1);
            color: #764ba2;
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.2s ease;
            display: inline-flex; /* For icon alignment */
            align-items: center;
            gap: 5px;
        }
        .stat-badge:hover {
            background-color: #764ba2;
            color: white;
        }
        .action-buttons a, .action-buttons button {
            color: #6c757d; /* Gray icons */
            background: none;
            border: none;
            padding: 0.5rem;
            margin-left: 0.5rem;
            cursor: pointer;
            transition: color 0.2s ease;
            font-size: 1.1rem; /* Slightly larger icons */
        }
        .action-buttons a:hover {
            color: #764ba2; /* Purple hover for edit */
        }
        .action-buttons .btn-delete:hover {
            color: #dc3545; /* Red hover for delete */
        }
    </style>
</head>
<body>

<%@ include file="../common/header.jsp" %>

<div class="container mt-5 main-content">
    <div class="dashboard-header">
        <div>
            <h2 class="fw-bold text-dark mb-1">Mes Cours Publiés</h2>
            <p class="text-muted mb-0">Gérez vos contenus et suivez vos étudiants.</p>
        </div>
        <a href="/enseignant/publier" class="btn btn-purple shadow-sm px-4 py-2 rounded-pill">
            <i class="fas fa-plus me-2"></i>Nouveau Cours
        </a>
    </div>

    <div id="successMessage" class="alert alert-success" style="display:none;"></div>

    <div class="table-container">
        <table class="table">
            <thead>
                <tr>
                    <th>Cours</th>
                    <th class="text-center">Étudiants Inscrits</th>
                    <th class="text-end">Actions</th>
                </tr>
            </thead>
            <tbody id="coursTableBody">
                <!-- JS will populate this -->
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
