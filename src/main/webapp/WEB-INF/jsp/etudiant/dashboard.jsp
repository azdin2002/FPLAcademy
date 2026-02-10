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
        .progress { border-radius: 10px; height: 12px; background-color: #333; }
        .stat-card { border-radius: 15px; border-left: 5px solid #764ba2; }
        .btn-dark {
            background-color: #343a40;
            border-color: #343a40;
        }
        .btn-dark:hover {
            background-color: #495057;
            border-color: #495057;
        }
    </style>
</head>
<body>

<%@ include file="../common/header.jsp" %>

<div class="container mt-5 main-content">
    <div class="row mb-4">
        <div class="col-md-12">
            <h2 class="fw-bold text-dark">Tableau de bord Étudiant</h2>
            <p class="text-muted">Continuez là où vous vous êtes arrêté.</p>
        </div>
    </div>

    <div class="row mb-5">
        <div class="col-md-4">
            <div class="card stat-card shadow-sm p-3 mb-2">
                <div class="text-muted small">Cours en cours</div>
                <div class="h3 fw-bold text-dark" id="coursCount">0</div>
            </div>
        </div>
    </div>

    <div class="row" id="coursContainer">
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
                <div class="card course-card shadow-sm h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="badge" style="background-color: \${ins.termine ? '#198754' : '#764ba2'} !important;">
                                \${ins.termine ? 'Terminé' : 'En cours'}
                            </span>
                        </div>
                        <h5 class="card-title fw-bold text-dark">\${escapeHtml(ins.cours.titre)}</h5>
                        <p class="card-text text-muted small text-truncate">
                            \${escapeHtml(ins.cours.description || '')}
                        </p>
                        
                        <div class="mt-4">
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
                        </div>
                    </div>
                    <div class="card-footer bg-transparent border-0 pb-3">
                        <a href="/etudiant/cours/\${ins.cours.id}" class="btn btn-dark w-100 rounded-pill">
                            \${ins.progression === 0 ? 'Démarrer' : 'Continuer'}
                        </a>
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