<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon Espace Apprentissage - FPL Academy</title>
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
            background-color: #ffffff; /* White card background */
            border: 1px solid #e9ecef;
        }

        .course-card {
            border: none;
            transition: transform 0.2s, box-shadow 0.2s;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            position: relative; /* For badge positioning */
        }
        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(118, 75, 162, 0.15);
        }
        .progress { border-radius: 10px; height: 12px; background-color: #e9ecef; }

        .btn-dark {
            background-color: #212529;
            border-color: #212529;
        }
        .btn-dark:hover {
            background-color: #424649;
            border-color: #424649;
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
    </style>
</head>
<body>

<%@ include file="../common/header.jsp" %>

<div class="container mt-5 main-content">
    <div class="row mb-4 align-items-end">
        <div class="col-md-8">
            <h2 class="fw-bold text-dark mb-2">Tableau de bord Étudiant</h2>
            <p class="text-muted lead mb-0">
                Bienvenue <sec:authentication property="name"/> ! Prêt à apprendre quelque chose de nouveau aujourd'hui ?
            </p>
        </div>
        <div class="col-md-4 text-md-end mt-4 mt-md-0">
             <div class="d-inline-block text-end">
                <div class="stat-number" id="coursCount">0</div>
                <div class="stat-label">Cours en cours</div>
             </div>
        </div>
    </div>

    <hr class="mb-5" style="border-top: 1px solid #e9ecef; opacity: 1;">

    <div class="row mb-5" id="coursContainer">
        <!-- JS will populate this -->
    </div>
</div>

<%@ include file="../common/footer.jsp" %>

<script>
    async function loadInscriptions() {
        try {
            const response = await fetch('/api/inscriptions/etudiant');
            if (!response.ok) throw new Error('Failed to load inscriptions');

            const inscriptions = await response.json();
            displayInscriptions(inscriptions);
        } catch (error) {
            console.error('Error loading inscriptions:', error);
            showError();
        }
    }

    function displayInscriptions(inscriptions) {
        const container = document.getElementById('coursContainer');
        const countElement = document.getElementById('coursCount');

        countElement.textContent = inscriptions.length;

        if (inscriptions.length === 0) {
            container.innerHTML = `
                <div class="col-12 text-center py-5">
                    <div class="display-1 text-muted">🎓</div>
                    <h4 class="text-muted mt-3">Vous n'êtes inscrit à aucun cours pour le moment.</h4>
                    <a href="/etudiant/catalogue" class="btn mt-3" style="background-color: #764ba2; border-color: #764ba2; color: white;">Parcourir le catalogue</a>
                </div>
            `;
            return;
        }

        container.innerHTML = inscriptions.map(ins => `
            <div class="col-md-6 col-lg-4 mb-4">
                <div class="card course-card h-100">
                    <span class="badge" style="position: absolute; top: 1rem; right: 1rem; background-color: \${ins.termine ? '#198754' : '#764ba2'} !important;">
                        \${ins.termine ? 'Terminé' : 'En cours'}
                    </span>
                    <div class="card-body d-flex flex-column">
                        <div class="mb-3">
                            <h5 class="card-title fw-bold text-dark mb-1" style="font-size: 1.25rem;">\${escapeHtml(ins.titre)}</h5>
                            <div class="text-muted small" style="font-size: 0.8rem; letter-spacing: 0.5px;">
                                PAR <span class="fw-bold text-secondary text-uppercase">\${escapeHtml(ins.enseignantUsername)}</span>
                            </div>
                        </div>
                        <p class="card-text text-muted small text-truncate mb-4">
                            \${escapeHtml(ins.description || '')}
                        </p>

                        <div class="mt-auto">
                            <div class="d-flex justify-content-between mb-1">
                                <span class="small text-muted">Progression</span>
                                <span class="small fw-bold text-dark">\${ins.progression}%</span>
                            </div>
                            <div class="progress mb-3">
                                <div class="progress-bar"
                                     role="progressbar"
                                     style="width: \${ins.progression}%; background-color: #764ba2;"
                                     aria-valuenow="\${ins.progression}"
                                     aria-valuemin="0"
                                     aria-valuemax="100">
                                </div>
                            </div>
                            <a href="/etudiant/cours/\${ins.coursId}" class="btn btn-dark w-100 rounded-pill">
                                \${ins.progression === 0 ? 'Démarrer' : 'Continuer'}
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        `).join('');
    }

    function showError() {
        const container = document.getElementById('coursContainer');
        container.innerHTML = '<div class="col-12 text-center py-5"><div class="alert alert-danger">Erreur lors du chargement.</div></div>';
    }

    function escapeHtml(text) {
        if (text === null || text === undefined) {
            return '';
        }
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    document.addEventListener('DOMContentLoaded', loadInscriptions);
</script>
</body>
</html>