<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Détail du Cours - FPL Academy</title>
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #121212;
            color: #e0e0e0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .main-content { flex: 1; }
        .content-box {
            background: #1e1e1e;
            border-radius: 15px;
            min-height: 60vh;
            border: 1px solid #333;
            padding: 2rem;
        }
        .text-primary { color: #9b72cf !important; } /* Light purple */
        .btn-outline-secondary {
            color: #adb5bd;
            border-color: #adb5bd;
        }
        .btn-outline-secondary:hover {
            background-color: #adb5bd;
            color: #121212;
        }
        .meta-info {
            color: #adb5bd;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>

<%@ include file="../common/header.jsp" %>

<div class="container mt-4 main-content">
    <div class="row mb-3">
        <div class="col-12 d-flex justify-content-between align-items-center">
            <a class="btn btn-outline-secondary btn-sm" href="/enseignant/dashboard">
                <i class="fas fa-arrow-left me-1"></i> Retour au Dashboard
            </a>
            <div>
                <a href="#" id="editLink" class="btn btn-sm btn-outline-warning me-2">
                    <i class="fas fa-pen me-1"></i> Modifier
                </a>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-12">
            <div class="content-box">
                <h2 class="fw-bold mb-2 text-primary" id="coursTitle">Chargement...</h2>
                <p class="meta-info mb-4" id="coursDesc">Chargement...</p>
                <hr class="border-secondary mb-4">

                <div id="coursContent" class="lh-lg text-light" style="font-size: 1.1rem;">
                    Chargement du contenu...
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>

<script>
    const courseId = '${coursId}';

    document.addEventListener('DOMContentLoaded', loadCourseDetails);

    async function loadCourseDetails() {
        try {
            // Reusing the student API for now as it returns the same course object structure
            // Or create a specific teacher API if needed. Assuming /api/enseignant/cours/{id} exists or similar.
            // Since we don't have a specific single course API for teacher in the controller list I saw earlier,
            // I'll assume we can fetch it from the list or add an endpoint.
            // Let's try to fetch from the general list and find it, or use the student endpoint if public.
            // Actually, let's use the student endpoint for reading course details as it's likely the same data.
            // Wait, the student endpoint requires enrollment.
            // I should check if there is an API to get a single course for teacher.
            // If not, I'll fetch all teacher courses and find this one.

            const response = await fetch('/api/enseignant/cours');
            if (!response.ok) throw new Error();
            const courses = await response.json();
            const course = courses.find(c => c.id == courseId);

            if (course) {
                renderCourse(course);
            } else {
                throw new Error('Course not found');
            }

        } catch (e) {
            showError();
        }
    }

    function renderCourse(course) {
        document.title = course.titre + ' - FPL Academy';
        document.getElementById('coursTitle').textContent = course.titre;
        document.getElementById('coursDesc').textContent = course.description;
        document.getElementById('coursContent').innerHTML = course.contenu;
        document.getElementById('editLink').href = '/enseignant/modifier/' + course.id;
    }

    function showError() {
         document.getElementById('coursContent').innerHTML = '<div class="alert alert-danger">Erreur lors du chargement du cours.</div>';
    }
</script>
</body>
</html>
