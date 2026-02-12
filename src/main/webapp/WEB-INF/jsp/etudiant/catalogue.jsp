<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catalogue des Cours - FPL Academy</title>
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8f9fa; /* Light background */
            color: #212529; /* Dark text */
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .main-content {
            flex: 1;
        }
        .card {
            background-color: #ffffff;
            border: 1px solid #e9ecef;
        }
        .course-card {
            border: none;
            transition: transform 0.2s, box-shadow 0.2s;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            height: 100%;
        }
        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(118, 75, 162, 0.15);
        }

        .btn-primary-custom {
            background-color: #764ba2 !important;
            border-color: #764ba2 !important;
            color: white !important;
            border-radius: 50px;
            font-weight: 600;
            width: 100%;
            padding: 0.6rem;
            transition: all 0.2s;
        }
        .btn-primary-custom:hover {
            background-color: #5e3c82 !important;
            border-color: #5e3c82 !important;
            color: white !important;
        }

        .btn-unsubscribe {
            background-color: #e9ecef !important;
            color: #dc3545 !important; /* Red text for danger action */
            border: 1px solid #dee2e6 !important;
            border-radius: 50px;
            font-weight: 600;
            width: 100%;
            padding: 0.6rem;
            transition: all 0.2s;
        }
        .btn-unsubscribe:hover {
            background-color: #dc3545 !important;
            color: white !important;
            border-color: #dc3545 !important;
        }

        .stat-number {
            font-size: 3.5rem;
            font-weight: 800;
            color: #764ba2;
            line-height: 1;
        }
        .stat-label {
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #6c757d;
            font-weight: 600;
            margin-top: 0.5rem;
        }

        a.course-link {
            text-decoration: none;
            color: inherit;
        }
        a.course-link:hover h5 {
            color: #764ba2 !important;
            transition: color 0.2s;
        }
    </style>
</head>
<body>

<%@ include file="../common/header.jsp" %>

<div class="container mt-5 main-content">
    <div class="row mb-4 align-items-end">
        <div class="col-md-8">
            <h2 class="fw-bold text-dark mb-2">Catalogue des formations</h2>
            <p class="text-muted lead mb-0">Découvrez nos nouveaux cours et développez vos compétences.</p>
        </div>
        <div class="col-md-4 text-md-end mt-4 mt-md-0">
             <div class="d-inline-block text-end">
                <div class="stat-number" id="coursesCount">0</div>
                <div class="stat-label">Cours disponibles</div>
             </div>
        </div>
    </div>

    <hr class="mb-5" style="border-top: 1px solid #e9ecef; opacity: 1;">

    <div class="row mb-5" id="catalogueContainer">
        <!-- JS will populate this -->
    </div>
</div>

<%@ include file="../common/footer.jsp" %>

<script>
async function loadCatalogue() {
    try {
        const resCours = await fetch('/api/cours');
        if (!resCours.ok) throw new Error();
        const coursesPage = await resCours.json();
        const courses = coursesPage.content; // 🔥 VERY IMPORTANT

        const resInsc = await fetch('/api/inscriptions/etudiant');
        if (!resInsc.ok) throw new Error();
        const inscriptions = await resInsc.json();

        displayCourses(courses, inscriptions);

    } catch (e) {
        console.error(e);
        document.getElementById('catalogueContainer').innerHTML =
            '<div class="col-12 text-center py-5"><div class="alert alert-danger">Erreur de chargement du catalogue.</div></div>';
    }
}

function displayCourses(courses, inscriptions) {

    const container = document.getElementById('catalogueContainer');
    const countElement = document.getElementById('coursesCount');

    countElement.textContent = courses.length;

    if (courses.length === 0) {
        container.innerHTML = `
            <div class="col-12 text-center py-5">
                <div class="display-1 text-muted">📚</div>
                <h4 class="text-muted mt-3">Aucun cours disponible.</h4>
            </div>
        `;
        return;
    }

    let html = '';

    courses.forEach(course => {

        const inscription = inscriptions.find(i => i.coursId === course.id);
        const isEnrolled = !!inscription;

        html += `
            <div class="col-md-6 col-lg-4 mb-4">
                <div class="card course-card h-100">
                    <div class="card-body d-flex flex-column">

                        <div class="mb-3">
                            <h5 class="fw-bold">\${escapeHtml(course.coursTitre)}</h5>
                            <div class="text-muted small">
                                PAR <strong>\${escapeHtml(course.enseignantUsername)}</strong>
                            </div>
                        </div>

                        <p class="text-muted small mb-4">
                            \${escapeHtml(course.description || '')}
                        </p>

                        <div class="mt-auto">

                            \${isEnrolled ? `
                                <button class="btn btn-unsubscribe"
                                        onclick="unsubscribe(\${course.id})">
                                        Se désinscrire
                                </button>
                            ` : `
                                <button class="btn btn-primary-custom"
                                        onclick="enrollCourse(\${course.id})">
                                        S'inscrire
                                </button>
                            `}

                        </div>

                    </div>
                </div>
            </div>
        `;
    });

    container.innerHTML = html;
}

async function enrollCourse(id) {

    const res = await fetch('/api/inscriptions/inscrire/' + id, {
        method: 'POST'
    });

    if (res.ok) {
        loadCatalogue();
    } else {
        alert("Erreur lors de l'inscription");
    }
}

async function unsubscribe(coursId) {

    if (!confirm("Se désinscrire ?")) return;

    const res = await fetch('/api/inscriptions/desinscrire/' + coursId, {
        method: 'DELETE'
    });

    if (res.ok) {
        loadCatalogue();
    } else {
        alert("Erreur lors de la désinscription");
    }
}

function escapeHtml(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

document.addEventListener('DOMContentLoaded', loadCatalogue);
</script>


</body>
</html>