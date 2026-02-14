<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catalogue Global - FPL Academy</title>
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
        .card { background-color: #ffffff; border: 1px solid #e9ecef; }
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
        .btn-purple {
            background-color: #764ba2 !important;
            border-color: #764ba2 !important;
            color: white !important;
        }
        .btn-outline-purple {
            color: #764ba2 !important;
            border-color: #764ba2 !important;
        }
        .btn-outline-purple:hover {
            background-color: #764ba2 !important;
            color: white !important;
        }
        .stat-number { font-size: 3.5rem; font-weight: 800; color: #764ba2; line-height: 1; }
        .stat-label { font-size: 0.9rem; text-transform: uppercase; letter-spacing: 1px; color: #6c757d; font-weight: 600; margin-top: 0.5rem; }
        a.course-link { text-decoration: none; color: inherit; }
        a.course-link:hover h5 { color: #764ba2 !important; transition: color 0.2s; }
    </style>
</head>
<body>

<%@ include file="../common/header.jsp" %>

<div class="container mt-5 main-content">
    <div class="row mb-4 align-items-end">
        <div class="col-md-8">
            <h2 class="fw-bold text-dark mb-2">Catalogue Global des Cours</h2>
            <p class="text-muted lead mb-0">Explorez tous les cours disponibles sur la plateforme.</p>
        </div>
        <div class="col-md-4 text-md-end mt-4 mt-md-0">
             <div class="d-inline-block text-end">
                <div class="stat-number" id="coursesCount">0</div>
                <div class="stat-label">Cours sur la plateforme</div>
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
let allCoursesData = [];
let myCoursesData = [];

async function loadCatalogue() {
    try {
        const [allCoursesRes, myCoursesRes] = await Promise.all([
            fetch('/api/cours'),
            fetch('/api/enseignant/cours')
        ]);

        if (!allCoursesRes.ok) throw new Error('Failed to fetch all courses');
        if (!myCoursesRes.ok) throw new Error('Failed to fetch my courses');

        allCoursesData = await allCoursesRes.json();
        myCoursesData = await myCoursesRes.json();

        document.getElementById('coursesCount').textContent = allCoursesData.length;

        displayCourses(allCoursesData, myCoursesData);

    } catch (e) {
        console.error(e);
        document.getElementById('catalogueContainer').innerHTML =
            '<div class="col-12 text-center py-5"><div class="alert alert-danger">Erreur de chargement du catalogue.</div></div>';
    }
}

function displayCourses(coursesToDisplay, myCourses) {
    const container = document.getElementById('catalogueContainer');

    if (coursesToDisplay.length === 0) {
        container.innerHTML = `<div class="col-12 text-center py-5"><h4 class="text-muted">Aucun cours trouvé.</h4></div>`;
        return;
    }

    const myCourseIds = new Set(myCourses.map(c => c.id));

    container.innerHTML = coursesToDisplay.map(course => {
        const isMyCourse = myCourseIds.has(course.id);
        const courseUrl = '/enseignant/cours/' + course.id;

        let buttonsHtml = '';
        if (isMyCourse) {
            buttonsHtml = `
                <div class="d-flex gap-2">
                    <a href="/enseignant/modifier/\${course.id}" class="btn btn btn-purple w-100"><i class="fas fa-pen me-2"></i>Modifier</a>
                    <button class="btn btn btn-outline-danger w-100" onclick="deleteCours(\${course.id}, event)"><i class="fas fa-trash-alt me-2"></i>Supprimer</button>
                </div>
            `;
        } else {
            buttonsHtml = `<a href="\${courseUrl}" class="btn btn-outline-purple w-100"><i class="fas fa-eye me-2"></i>Consulter</a>`;
        }

        return `
            <div class="col-md-6 col-lg-4 mb-4">
                <div class="card course-card h-100">
                    <div class="card-body d-flex flex-column">
                        <div class="mb-3">
                            <a href="\${courseUrl}" class="course-link">
                                <h5 class="card-title fw-bold text-dark mb-1">\${escapeHtml(course.titre)}</h5>
                            </a>
                            <div class="text-muted small">
                                PAR <span class="fw-bold text-uppercase">\${escapeHtml(course.enseignant ? course.enseignant.username : 'Inconnu')}</span>
                            </div>
                        </div>
                        <p class="card-text text-muted small text-truncate mb-4">
                            \${escapeHtml(course.description)}
                        </p>
                        <div class="mt-auto">
                            \${buttonsHtml}
                        </div>
                    </div>
                </div>
            </div>
        `;
    }).join('');
}

async function deleteCours(id, event) {
    event.stopPropagation();
    if (!confirm('Êtes-vous sûr de vouloir supprimer ce cours ?')) return;

    try {
        const res = await fetch('/api/enseignant/cours/' + id, { method: 'DELETE' });
        if (res.ok) {
            loadCatalogue();
        } else {
            alert("Erreur lors de la suppression.");
        }
    } catch (e) {
        console.error(e);
        alert("Erreur lors de la suppression.");
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
            displayCourses(filteredCourses, myCoursesData);
        });
    }
});
</script>

</body>
</html>