<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détail du Cours - FPL Academy</title>

    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        /* ===== COMPLETE BOOTSTRAP OVERRIDE (From Student Page) ===== */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8fafc;
            color: #1e293b;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
        }

        .course-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem 1.5rem;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            color: #475569;
            font-size: 0.875rem;
            font-weight: 500;
            text-decoration: none;
        }

        .back-link:hover {
            background: #f8fafc;
            border-color: #94a3b8;
            color: #0f172a;
        }

        .course-card {
            background: white;
            border-radius: 16px;
            padding: 2rem;
            border: 1px solid #e2e8f0;
            height: 100%;
        }

        .course-title {
            font-size: 1.75rem;
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 1.5rem;
        }

        .course-content {
            color: #334155;
            font-size: 0.9375rem;
            line-height: 1.7;
        }

        .sidebar-card {
            background: white;
            border-radius: 16px;
            padding: 1.5rem;
            border: 1px solid #e2e8f0;
            margin-bottom: 1.5rem;
            position: relative;
        }

        .card-header {
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            color: #64748b;
            margin-bottom: 1.25rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0;
            background: none;
            border: none;
        }

        .card-header i {
            color: #64748b;
        }

        .instructor-wrapper {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .instructor-avatar {
            width: 48px;
            height: 48px;
            background: #f1f5f9;
            color: #475569;
            font-weight: 600;
            font-size: 1.125rem;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
        }

        .instructor-name {
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 0.125rem;
        }

        .instructor-title {
            font-size: 0.75rem;
            color: #64748b;
        }

        .sticky-sidebar {
            position: sticky;
            top: 100px;
        }

        .btn-edit {
            background-color: #764ba2;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 0.5rem 1rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: background-color 0.2s;
        }
        .btn-edit:hover {
            background-color: #613a88;
            color: white;
        }

        .btn-icon-delete {
            color: #ef4444;
            background: none;
            border: none;
            padding: 0.5rem;
            margin-right: 0.5rem;
            transition: color 0.2s;
        }
        .btn-icon-delete:hover {
            color: #b91c1c;
        }
    </style>
</head>
<body>

<%@ include file="../common/header.jsp" %>

<div class="main-content">
    <div class="course-container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <a class="back-link mb-0" href="/enseignant/dashboard">
                <i class="fas fa-arrow-left"></i>
                Retour au dashboard
            </a>
            <div>
                <button id="deleteBtn" class="btn-icon-delete" title="Supprimer">
                    <i class="fas fa-trash-alt"></i>
                </button>
                <a href="#" id="editLink" class="btn-edit">
                    <i class="fas fa-pen"></i> Modifier le cours
                </a>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-lg-8">
                <div class="course-card">
                    <h2 class="course-title" id="coursTitle">Chargement...</h2>
                    <div class="course-content" id="coursContent">
                        <div class="d-flex justify-content-center py-5">
                            <div class="spinner-border" style="color: #94a3b8;" role="status">
                                <span class="visually-hidden">Chargement...</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="sticky-sidebar">
                    <div class="sidebar-card">
                        <div class="card-header">
                            <i class="fas fa-user"></i>
                            Instructeur
                        </div>
                        <div id="instructorInfo" class="instructor-wrapper"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>

<script>
    const courseId = '${coursId}';

    document.addEventListener('DOMContentLoaded', () => {
        loadCourseDetails();
        document.getElementById('deleteBtn').addEventListener('click', deleteCours);
    });

    async function loadCourseDetails() {
        try {
            // Fetch single course directly using the teacher API
            const response = await fetch('/api/enseignant/cours/' + courseId);

            if (response.ok) {
                const course = await response.json();
                renderCourse(course);
            } else {
                throw new Error('Course not found or access denied');
            }
        } catch (e) {
            console.error(e);
            showError();
        }
    }

    function renderCourse(course) {
        document.title = course.titre + ' - FPL Academy';
        document.getElementById('coursTitle').textContent = course.titre;
        document.getElementById('coursContent').innerHTML = course.contenu || '<p class="text-muted">Aucun contenu disponible.</p>';
        document.getElementById('editLink').href = '/enseignant/modifier/' + course.id;

        // Render Instructor (Self)
        const teacher = course.enseignant;
        const username = (teacher && teacher.username) ? teacher.username : 'Moi';
        const initial = username.charAt(0).toUpperCase();

        document.getElementById('instructorInfo').innerHTML = `
            <div class="instructor-avatar">\${initial}</div>
            <div>
                <div class="instructor-name">\${escapeHtml(username)}</div>
                <div class="instructor-title">Enseignant (Vous)</div>
            </div>
        `;
    }

    async function deleteCours() {
        if (!confirm('Êtes-vous sûr de vouloir supprimer ce cours ? Cette action est irréversible.')) return;

        try {
            const response = await fetch(`/api/enseignant/cours/\${courseId}`, { method: 'DELETE' });
            if (!response.ok) throw new Error('Failed to delete course');
            window.location.href = '/enseignant/dashboard?success=deleted';
        } catch (error) {
            console.error('Error deleting course:', error);
            alert('Erreur lors de la suppression du cours.');
        }
    }

    function showError() {
        document.getElementById('coursContent').innerHTML =
            '<div class="text-center py-5">' +
            '<i class="fas fa-exclamation-circle" style="color: #94a3b8; font-size: 2.5rem; margin-bottom: 1rem;"></i>' +
            '<h5 style="color: #475569;">Erreur de chargement</h5>' +
            '<p style="color: #64748b;">Impossible de charger les détails du cours.</p>' +
            '</div>';
    }

    function escapeHtml(text) {
        if (!text) return '';
        var div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
</script>

</body>
</html>