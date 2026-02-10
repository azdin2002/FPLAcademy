<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title id="pageTitle">Cours - Lecture</title>
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
        .content-box {
            background: #1e1e1e;
            border-radius: 15px;
            min-height: 60vh;
            border: 1px solid #333;
        }
        .sticky-sidebar { position: sticky; top: 100px; }
        .progress { height: 10px; border-radius: 5px; background-color: #333; }
        .card {
            background-color: #1e1e1e;
            border: 1px solid #333;
        }
        .text-dark { color: #e0e0e0 !important; }
        .text-muted { color: #adb5bd !important; }
        .text-primary { color: #764ba2 !important; }
        .btn-outline-secondary {
            color: #adb5bd;
            border-color: #adb5bd;
        }
        .btn-outline-secondary:hover {
            background-color: #adb5bd;
            color: #121212;
        }
        .btn-success {
            background-color: #198754;
            border-color: #198754;
        }
    </style>
</head>
<body>

<%@ include file="../common/header.jsp" %>

<div class="container mt-4 main-content">
    <div class="row mb-3">
        <div class="col-12">
            <a class="btn btn-outline-secondary btn-sm" href="/etudiant/dashboard">
                <i class="fas fa-arrow-left me-1"></i> Retour au Dashboard
            </a>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-8 mb-4">
            <div class="content-box p-5">
                <h2 class="fw-bold mb-4 text-primary" id="coursTitle">Chargement...</h2>
                <div id="coursContent" class="lh-lg text-light" style="font-size: 1.1rem;">
                    Chargement du contenu...
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="sticky-sidebar">
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-body text-center p-4">
                        <h6 class="text-uppercase text-muted fw-bold small mb-3">Votre Progression</h6>

                        <div class="display-4 fw-bold text-primary mb-2" id="progressValue">0%</div>

                        <div class="progress mb-4">
                            <div id="progressBar"
                                 class="progress-bar bg-success progress-bar-striped progress-bar-animated"
                                 style="width:0%">
                            </div>
                        </div>

                        <div id="progressActions"></div>
                    </div>
                </div>

                <div class="card border-0 shadow-sm">
                    <div class="card-body">
                        <h6 class="fw-bold mb-3 text-dark">Instructeur</h6>
                        <div id="instructorInfo" class="d-flex align-items-center">
                            Chargement...
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>

<script>
    const courseId = window.location.pathname.split('/').pop();
    let inscriptionId = null;

    document.addEventListener('DOMContentLoaded', loadCourseDetails);

    async function loadCourseDetails() {
        try {
            const response = await fetch('/api/inscriptions/etudiant/cours/' + courseId);
            if (!response.ok) throw new Error();

            const inscription = await response.json();
            inscriptionId = inscription.id;
            renderCourse(inscription);

        } catch (e) {
            showError();
        }
    }

    function renderCourse(inscription) {
        const course = inscription.cours;
        const teacher = course.enseignant;

        document.getElementById('pageTitle').textContent = course.titre + ' - Lecture';
        document.getElementById('coursTitle').textContent = course.titre;
        document.getElementById("instructorInfo").textContent = course.enseignant.username;
        document.getElementById('coursContent').innerHTML = course.contenu;

        document.getElementById('progressValue').textContent = inscription.progression + '%';
        document.getElementById('progressBar').style.width = inscription.progression + '%';

        const actions = document.getElementById('progressActions');
        if (inscription.progression < 100) {
            actions.innerHTML =
                '<button class="btn btn-success w-100" onclick="updateProgress()">Marquer comme lu (+25%)</button>';
        } else {
            actions.innerHTML =
                '<div class="alert alert-success">Cours terminé ✔️</div>';
        }

        const instructor = document.getElementById('instructorInfo');
        const initial = teacher.username.charAt(0).toUpperCase();
        instructor.innerHTML =
            '<div class="rounded-circle bg-primary text-white d-flex justify-content-center align-items-center me-3" ' +
            'style="width:45px;height:45px; background-color: #764ba2 !important;">' + initial + '</div>' +
            '<div>' +
                '<div class="fw-bold text-dark">' + escapeHtml(teacher.username) + '</div>' +
                '<div class="text-muted small">Enseignant certifié</div>' +
            '</div>';
    }

    async function updateProgress() {
        await fetch('/api/inscriptions/' + inscriptionId + '/progression', {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ augmentation: 25 })
        });
        location.reload();
    }

    function escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
</script>
</body>
</html>
