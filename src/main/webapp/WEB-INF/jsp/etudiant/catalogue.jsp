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
            background-color: #121212; /* Dark background */
            color: #e0e0e0; /* Light text */
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .main-content {
            flex: 1;
        }
        .card {
            background-color: #1e1e1e; /* Darker card background */
            border: 1px solid #333;
        }
        .text-dark { color: #e0e0e0 !important; }
        .text-muted { color: #adb5bd !important; }
        .course-card { border: none; transition: transform 0.2s, box-shadow 0.2s; border-radius: 12px; }
        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(118, 75, 162, 0.2);
        }
        .btn-status {
            background-color: #2c3e50;
            color: #adb5bd;
            font-weight: bold;
            padding: 8px;
            border-radius: 8px;
            text-align: center;
            border: 1px solid #343a40;
        }
        .btn-primary {
            background-color: #764ba2;
            border-color: #764ba2;
        }
        .btn-primary:hover {
            background-color: #5a377d;
            border-color: #5a377d;
        }
    </style>
</head>
<body>

<%@ include file="../common/header.jsp" %>

<div class="container mt-5 main-content">
    <div class="row mb-4">
        <div class="col-md-12">
            <h2 class="fw-bold text-dark">Catalogue des formations</h2>
            <p class="text-muted">Découvrez nos nouveaux cours et développez vos compétences.</p>
        </div>
    </div>

    <div class="row" id="catalogueContainer">
        <!-- JS will populate this -->
    </div>
</div>

<%@ include file="../common/footer.jsp" %>

<script>
async function loadCatalogue() {
    try {
        console.log("📡 load catalogue");

        const resCours = await fetch('/api/cours');
        const courses = await resCours.json();

        const resInsc = await fetch('/api/inscriptions/etudiant');
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
    let html = '';

    if (courses.length === 0) {
        container.innerHTML = `
            <div class="col-12 text-center py-5">
                <div class="display-1 text-muted">📚</div>
                <h4 class="text-muted mt-3">Aucun cours disponible pour le moment.</h4>
            </div>
        `;
        return;
    }

    courses.forEach(course => {
        const isEnrolled = inscriptions.some(i => i.cours.id === course.id);

        html +=
            '<div class="col-md-6 col-lg-4 mb-4">' +
            '  <div class="card course-card h-100 shadow-sm">' +
            '    <div class="card-body">' +
            '      <h5 class="fw-bold text-dark">' + escapeHtml(course.titre) + '</h5>' +
            '      <p class="text-muted small">' + escapeHtml(course.description) + '</p>' +
            '      <div class="mt-4">';

        if (isEnrolled) {
            html +=
                '<div class="btn-status"><i class="fas fa-check-circle me-2"></i>Déjà inscrit</div>';
        } else {
            html +=
                '<button class="btn btn-primary w-100 fw-bold rounded-pill" ' +
                'onclick="enrollCourse(' + course.id + ')" ' +
                'id="btn-' + course.id + '">S\'inscrire</button>';
        }

        html +=
            '      </div>' +
            '    </div>' +
            '  </div>' +
            '</div>';
    });

    container.innerHTML = html;
}

async function enrollCourse(id) {
    const btn = document.getElementById('btn-' + id);
    btn.disabled = true;
    btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Traitement...';

    const res = await fetch('/api/inscriptions/inscrire/' + id, {
        method: 'POST'
    });

    if (res.ok) {
        window.location.href = '/etudiant/dashboard';
    } else {
        alert('Erreur lors de l\'inscription');
        btn.disabled = false;
        btn.textContent = "S'inscrire";
    }
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text || '';
    return div.innerHTML;
}

document.addEventListener('DOMContentLoaded', loadCatalogue);
</script>

</body>
</html>
