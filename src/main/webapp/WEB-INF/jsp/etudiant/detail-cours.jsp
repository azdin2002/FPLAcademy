<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cours - FPL Academy</title>

    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        /* ===== COMPLETE BOOTSTRAP OVERRIDE ===== */
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
            margin-bottom: 2rem;
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

        .course-title.locked {
            color: #64748b;
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

        .progress-value {
            font-size: 2.5rem;
            font-weight: 600;
            line-height: 1;
            margin-bottom: 0.75rem;
        }

        .progress-value.gray { color: #64748b; }
        .progress-value.purple { color: #6b46c1; }
        .progress-value.green { color: #059669; }

        .progress-track {
            height: 6px;
            background: #e2e8f0;
            border-radius: 3px;
            margin: 1rem 0;
        }

        .progress-fill {
            height: 100%;
            border-radius: 3px;
            transition: width 0.2s;
        }

        .progress-fill.gray { background: #94a3b8; }
        .progress-fill.purple { background: #6b46c1; }
        .progress-fill.green { background: #059669; }

        .progress-status {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.8125rem;
            color: #475569;
        }

        .btn-mark {
            background: #6b46c1;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 0.625rem 1.25rem;
            font-size: 0.875rem;
            font-weight: 500;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            margin-top: 0.75rem;
            cursor: pointer;
        }

        .btn-mark:hover {
            background: #553c9a;
            color: white;
        }

        .btn-mark i {
            color: white;
        }

        .btn-enroll {
            background: #6b46c1;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 0.75rem 1.5rem;
            font-size: 0.9375rem;
            font-weight: 600;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            cursor: pointer;
        }

        .btn-enroll:hover {
            background: #553c9a;
            color: white;
        }

        .btn-enroll i {
            color: white;
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

        .badge-active {
            position: absolute;
            top: 1.5rem;
            right: 1.5rem;
            background: #ecfdf5;
            color: #059669;
            border: 1px solid #d1fae5;
            border-radius: 4px;
            padding: 0.25rem 0.625rem;
            font-size: 0.6875rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.375rem;
        }

        .badge-active i {
            color: #059669;
            font-size: 0.5rem;
        }

        .subscription-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 2rem 1.5rem;
            text-align: center;
        }

        .lock-icon {
            width: 56px;
            height: 56px;
            background: #ffeeee;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.25rem;
        }

        .lock-icon i {
            font-size: 1.5rem;
            color: #b91c1c;
        }

        .subscription-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: #b91c1c;
            margin-bottom: 0.75rem;
        }

        .subscription-description {
            color: #64748b;
            font-size: 0.875rem;
            margin-bottom: 1rem;
        }

        .course-preview {
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid #e2e8f0;
            text-align: left;
        }

        .preview-label {
            font-size: 0.6875rem;
            font-weight: 600;
            text-transform: uppercase;
            color: #64748b;
            margin-bottom: 0.75rem;
            display: flex;
            align-items: center;
            gap: 0.375rem;
        }

        .preview-text {
            font-size: 0.8125rem;
            color: #475569;
        }

        .completed-banner {
            background: #ecfdf5;
            border: 1px solid #d1fae5;
            border-radius: 8px;
            padding: 0.875rem 1rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-top: 1rem;
            color: #059669;
        }

        .sticky-sidebar {
            position: sticky;
            top: 100px;
        }

        @media (max-width: 768px) {
            .badge-active {
                position: static;
                margin-top: 0.75rem;
                width: fit-content;
            }
        }
    </style>
</head>
<body>

<%@ include file="../common/header.jsp" %>

<div class="main-content">
    <div class="course-container">
        <a class="back-link" href="/etudiant/dashboard">
            <i class="fas fa-arrow-left"></i>
            Retour au dashboard
        </a>

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
                    <div class="sidebar-card" id="progressCard">
                        <div class="card-header">
                            <i class="fas fa-chart-simple"></i>
                            Progression
                        </div>
                        <div id="progressContent"></div>
                    </div>

                    <div class="sidebar-card" id="instructorCard">
                        <div class="card-header">
                            <i class="fas fa-user"></i>
                            Instructeur
                        </div>
                        <div id="instructorInfo" class="instructor-wrapper"></div>
                        <div id="instructorBadgeContainer"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>

<script>
    var courseId = window.location.pathname.split('/').pop();
    var inscriptionId = null;

    document.addEventListener('DOMContentLoaded', loadCourseDetails);

    async function loadCourseDetails() {
        try {
            var response = await fetch('/api/inscriptions/etudiant/cours/' + courseId);

            if (response.ok) {
                var data = await response.json();
                inscriptionId = data.inscriptionId;
                renderEnrolledDTO(data);
            } 
            else if (response.status === 404) {
                var resCourse = await fetch('/api/cours/' + courseId);

                if (!resCourse.ok) throw new Error("Course not found");

                var course = await resCourse.json();
                renderLockedContent(course);
            } 
            else {
                throw new Error("Erreur API");
            }

        } catch (e) {
            console.error(e);
            showError();
        }
    }

    /* ===================== ENROLLED ===================== */

    function renderEnrolledDTO(data) {

        document.title = data.coursTitre + " - FPL Academy";
        document.getElementById("coursTitle").textContent = data.coursTitre;
        document.getElementById("coursTitle").classList.remove("locked");

        renderInstructor(data.enseignantUsername, true);

        document.getElementById("coursContent").innerHTML =
            '<p>' + escapeHtml(data.coursDescription || '') + '</p>';

        renderProgress(data.progression || 0);
    }

    function renderProgress(progress) {

        var isCompleted = progress === 100;

        var valueClass = progress === 0 ? 'gray'
                        : (progress === 100 ? 'green' : 'purple');

        var fillClass = valueClass;

        var statusIcon = progress === 100 ? 'circle-check'
                        : (progress === 0 ? 'clock' : 'arrow-right');

        var statusText = progress === 100
            ? "Terminé"
            : (progress === 0 ? "Non commencé" : progress + "% complété");

        var actions = "";

        if (!isCompleted) {
            actions =
                '<button class="btn-mark" onclick="updateProgress()">' +
                '<i class="fas fa-check"></i>' +
                'Marquer comme lu (+25%)' +
                '</button>';
        } else {
            actions =
                '<div class="completed-banner">' +
                '<i class="fas fa-circle-check"></i>' +
                '<span>Félicitations ! Cours terminé</span>' +
                '</div>';
        }

        document.getElementById("progressContent").innerHTML =
            '<div class="progress-value ' + valueClass + '">' + progress + '%</div>' +
            '<div class="progress-track">' +
            '<div class="progress-fill ' + fillClass + '" style="width: ' + progress + '%;"></div>' +
            '</div>' +
            '<div class="progress-status">' +
            '<i class="fas fa-' + statusIcon + '"></i>' +
            '<span>' + statusText + '</span>' +
            '</div>' +
            actions;

        document.getElementById("progressCard").style.display = "block";
    }

    /* ===================== LOCKED ===================== */

    function renderLockedContent(course) {

        document.getElementById("coursTitle").textContent = course.titre;
        document.getElementById("coursTitle").classList.add("locked");

        var teacher = course.enseignantUsername || "Inconnu";
        renderInstructor(teacher, false);

        document.getElementById("progressCard").style.display = "none";

        var description = course.description
            ? escapeHtml(course.description)
            : "Aucune description disponible.";

        document.getElementById("coursContent").innerHTML =
            '<div class="subscription-card">' +
                '<div class="lock-icon">' +
                    '<i class="fas fa-lock"></i>' +
                '</div>' +

                '<h3 class="subscription-title">Accès restreint</h3>' +

                '<p class="subscription-description">' +
                    'Vous devez vous inscrire pour accéder au contenu de ce cours.' +
                '</p>' +

                '<button class="btn-enroll" onclick="enrollCourse()">' +
                    '<i class="fas fa-graduation-cap"></i>' +
                    'S\'inscrire au cours' +
                '</button>' +

                '<div class="course-preview">' +
                    '<div class="preview-label">' +
                        '<i class="fas fa-file-lines"></i>' +
                        'À propos' +
                    '</div>' +
                    '<div class="preview-text">' + description + '</div>' +
                '</div>' +
            '</div>';
    }

    /* ===================== INSTRUCTOR ===================== */

    function renderInstructor(username, isEnrolled) {

        var initial = username.charAt(0).toUpperCase();

        document.getElementById("instructorInfo").innerHTML =
            '<div class="instructor-avatar">' + initial + '</div>' +
            '<div>' +
                '<div class="instructor-name">' + escapeHtml(username) + '</div>' +
                '<div class="instructor-title">Enseignant certifié</div>' +
            '</div>';

        if (isEnrolled) {
            document.getElementById("instructorBadgeContainer").innerHTML =
                '<div class="badge-active">' +
                    '<i class="fas fa-circle"></i>' +
                    'Actif' +
                '</div>';
        } else {
            document.getElementById("instructorBadgeContainer").innerHTML = '';
        }
    }

    /* ===================== ACTIONS ===================== */

    async function updateProgress() {
        try {
            await fetch('/api/inscriptions/' + inscriptionId + '/progression', {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ augmentation: 25 })
            });

            location.reload();

        } catch (e) {
            alert("Erreur mise à jour progression");
        }
    }

    async function enrollCourse() {
        try {
            var res = await fetch('/api/inscriptions/inscrire/' + courseId, {
                method: 'POST'
            });

            if (!res.ok) throw new Error();

            location.reload();

        } catch (e) {
            alert("Erreur lors de l'inscription");
        }
    }

    /* ===================== ERROR ===================== */

    function showError() {
        document.getElementById("coursContent").innerHTML =
            '<div class="text-center py-5">' +
                '<i class="fas fa-exclamation-circle" style="font-size:2rem;color:#94a3b8;"></i>' +
                '<h5 class="mt-3">Erreur de chargement</h5>' +
                '<p>Impossible de charger les détails du cours.</p>' +
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