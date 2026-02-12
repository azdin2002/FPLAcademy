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

    <hr class="mb-4" style="border-top: 1px solid #e9ecef; opacity: 1;">

    <div class="row mb-4 justify-content-end">
        <div class="col-md-4">
            <div class="input-group">
                <input type="text" class="form-control" id="courseSearch" placeholder="Rechercher un cours...">
                <span class="input-group-text"><i class="fas fa-search"></i></span>
            </div>
        </div>
    </div>

    <div class="row mb-5" id="catalogueContainer">
        <!-- JS will populate this -->
    </div>
</div>

<%@ include file="../common/footer.jsp" %>

<script>
// Global variables to store original data
let allCoursesData = [];
let allInscriptionsData = [];

async function loadCatalogue() {
    try {
        const resCours = await fetch('/api/cours');
        if (!resCours.ok) throw new Error('Failed to fetch courses');
        const courses = await resCours.json();

        const resInsc = await fetch('/api/inscriptions/etudiant');
        if (!resInsc.ok) throw new Error('Failed to fetch inscriptions');
        const inscriptions = await resInsc.json();

        allCoursesData = courses;
        allInscriptionsData = inscriptions;

        document.getElementById('coursesCount').textContent = allCoursesData.length;

        displayCourses(allCoursesData, allInscriptionsData);

    } catch (e) {
        console.error(e);
        document.getElementById('catalogueContainer').innerHTML =
            '<div class="col-12 text-center py-5"><div class="alert alert-danger">Erreur de chargement du catalogue.</div></div>';
    }
}

function displayCourses(coursesToDisplay, inscriptions) {
    const container = document.getElementById('catalogueContainer');

    let html = '';

    if (coursesToDisplay.length === 0) {
        html = `<div class="col-12 text-center py-5"><h4 class="text-muted">Aucun cours trouvé.</h4></div>`;
    } else {
        coursesToDisplay.forEach(course => {
            const inscription = inscriptions.find(i => i.cours.id === course.id);
            const isEnrolled = !!inscription;
            const courseUrl = '/etudiant/cours/' + course.id;

            html += `
                <div class="col-md-6 col-lg-4 mb-4">
                    <div class="card course-card h-100">
                        <div class="card-body d-flex flex-column">
                            <div class="mb-3">
                                <a href="\${courseUrl}" class="course-link">
                                    <h5 class="card-title fw-bold text-dark mb-1" style="font-size: 1.25rem;">\${escapeHtml(course.titre)}</h5>
                                </a>
                                <div class="text-muted small" style="font-size: 0.8rem; letter-spacing: 0.5px;">
                                    PAR <span class="fw-bold text-secondary text-uppercase">\${escapeHtml(course.enseignant ? course.enseignant.username : 'Inconnu')}</span>
                                </div>
                            </div>
                            <p class="card-text text-muted small text-truncate mb-4">
                                \${escapeHtml(course.description)}
                            </p>

                            <div class="mt-auto">
                                \${isEnrolled ?
                                    `<button class="btn btn-unsubscribe" onclick="unsubscribe(\${inscription.id})">Se désinscrire</button>` :
                                    `<button class="btn btn-primary-custom" onclick="enrollCourse(\${course.id})" id="btn-\${course.id}">S'inscrire</button>`
                                }
                            </div>
                        </div>
                    </div>
                </div>
            `;
        });
    }

    container.innerHTML = html;
}

async function enrollCourse(id) {
    const btn = document.getElementById('btn-' + id);
    btn.disabled = true;
    btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Traitement...';

    const res = await fetch('/api/inscriptions/inscrire/' + id, { method: 'POST' });

    if (res.ok) {
        window.location.href = '/etudiant/dashboard';
    } else {
        alert('Erreur lors de l\'inscription');
        btn.disabled = false;
        btn.textContent = "S'inscrire";
    }
}

async function unsubscribe(inscriptionId) {
    if (!confirm("Êtes-vous sûr de vouloir vous désinscrire de ce cours ?")) return;

    try {
        const res = await fetch('/api/inscriptions/' + inscriptionId, { method: 'DELETE' });
        if (res.ok) {
            loadCatalogue();
        } else {
            alert("Erreur lors de la désinscription.");
        }
    } catch (e) {
        console.error(e);
        alert("Erreur lors de la désinscription.");
    }
}

function escapeHtml(text) {
    if (text === null || text === undefined) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

document.addEventListener('DOMContentLoaded', () => {
    loadCatalogue();

    const courseSearchInput = document.getElementById('courseSearch');
    if (courseSearchInput) {
        courseSearchInput.addEventListener('input', (event) => {
            const searchTerm = event.target.value.toLowerCase();
            const filteredCourses = allCoursesData.filter(course => {
                const title = course.titre ? course.titre.toLowerCase() : '';
                const description = course.description ? course.description.toLowerCase() : '';
                const instructor = course.enseignant && course.enseignant.username ? course.enseignant.username.toLowerCase() : '';

                return title.includes(searchTerm) ||
                       description.includes(searchTerm) ||
                       instructor.includes(searchTerm);
            });
            displayCourses(filteredCourses, allInscriptionsData);
        });
    }
});
</script>

</body>
</html>