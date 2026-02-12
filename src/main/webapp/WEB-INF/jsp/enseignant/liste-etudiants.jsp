<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Liste des &eacute;tudiants - FPL Academy</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8f9fa; /* Unified Light background */
            color: #212529;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .main-content { flex: 1; padding-bottom: 3rem; }

        /* --- Return Button Style (Matches stat-badge) --- */
        .btn-return {
            background-color: rgba(118, 75, 162, 0.08);
            color: #764ba2;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 0.85rem;
            border: 1px solid rgba(118, 75, 162, 0.1);
        }
        .btn-return:hover {
            background-color: #764ba2;
            color: white;
            transform: translateX(-5px);
        }

        /* --- Header Section --- */
        .page-header {
            margin-bottom: 2rem;
        }

        /* --- Table Container (Matches Dashboard Cards) --- */
        .card-premium {
            background-color: #ffffff;
            border: 1px solid #e9ecef;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            overflow: hidden;
        }

        /* --- Unified Table Styling --- */
        .table { margin-bottom: 0; }
        
        .table thead th {
            background-color: #ffffff;
            color: #6c757d;
            border-bottom: 1px solid #e9ecef;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 1px;
            padding: 1.25rem 1.5rem;
        }

        .table td { 
            padding: 1.25rem 1.5rem; 
            border-top: 1px solid #f1f3f5;
            vertical-align: middle;
        }

        .table-hover tbody tr:hover { 
            background-color: #fcfaff; /* Subtle purple tint */
        }

        /* --- Progress Bar --- */
        .progress { 
            height: 8px; 
            background-color: #e9ecef; 
            border-radius: 10px; 
        }
        .progress-bar { 
            border-radius: 10px; 
            background-color: #764ba2;
        }

        /* --- Badges --- */
        .badge-status {
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.75rem;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        .status-complete { background: rgba(25, 135, 84, 0.1); color: #198754; }
        .status-ongoing { background: rgba(118, 75, 162, 0.1); color: #764ba2; }

        /* --- Avatar --- */
        .avatar-circle {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: 700;
            border-radius: 10px; /* Modern rounded-square look */
        }
    </style>
</head>
<body>

<%@ include file="../common/header.jsp" %>

<div class="container mt-5 main-content">
    <div class="row mb-4 align-items-center">
        <div class="col-md-7">
            <h2 class="fw-bold text-dark mb-1">&Eacute;tudiants Inscrits</h2>
            <p class="text-muted mb-0">Suivi d&eacute;taill&eacute; de la progression de vos apprenants.</p>
        </div>
        <div class="col-md-5 text-md-end mt-3 mt-md-0">
            <a href="/enseignant/dashboard" class="btn-return">
                <i class="fas fa-arrow-left"></i> Retour au Dashboard
            </a>
        </div>
    </div>

    <div class="card card-premium">
        <div class="table-responsive">
            <table class="table table-hover">
                <thead>
                <tr>
                    <th>&Eacute;tudiant</th>
                    <th>Progression</th>
                    <th class="text-center">Statut</th>
                    <th class="text-end">Date d'inscription</th>
                </tr>
                </thead>
                <tbody id="etudiantsBody">
                    <tr>
                        <td colspan="4" class="text-center py-5">
                            <div class="spinner-border text-primary opacity-25" role="status"></div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>

<script>
    const coursId = ${coursId};

    async function loadInscriptions() {
        try {
            const res = await fetch(`/api/enseignant/cours/\${coursId}/inscriptions`);
            if (!res.ok) throw new Error();
            const inscriptions = await res.json();
            const tbody = document.getElementById("etudiantsBody");

            if (inscriptions.length === 0) {
                tbody.innerHTML = `
                    <tr>
                        <td colspan="4" class="text-center py-5 text-muted">
                            Aucun étudiant inscrit
                        </td>
                    </tr>`;
                return;
            }

            tbody.innerHTML = inscriptions.map(i => {

                const statusLabel = i.termine ? 'Terminé' : 'En cours';
                const statusClass = i.termine ? 'status-complete' : 'status-ongoing';
                const icon = i.termine ? 'fa-check-circle' : 'fa-clock';

                const dateFormatted = i.dateInscription
                    ? new Date(i.dateInscription).toLocaleDateString('fr-FR')
                    : '';

                return `
                <tr>
                    <td>
                        <div class="fw-bold">\${i.username}</div>
                        <div class="text-muted small">ID \#${i.userId}</div>
                    </td>
                    <td>
                        <div class="progress">
                            <div class="progress-bar" 
                                 style="width: \${i.progression}%"></div>
                        </div>
                    </td>
                    <td class="text-center">
                        <span class="badge-status \${statusClass}">
                            <i class="fas \${icon}"></i> ${statusLabel}
                        </span>
                    </td>
                    <td class="text-end text-muted small">
                        \${dateFormatted}
                    </td>
                </tr>`;
            }).join("");

        } catch (e) {
            document.getElementById("etudiantsBody").innerHTML =
                `<tr><td colspan="4" class="text-danger text-center">
                    Erreur de chargement
                 </td></tr>`;
        }
    }


    function escapeHtml(text) {
        if (!text) return '';
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    loadInscriptions();
</script>
</body>
</html>