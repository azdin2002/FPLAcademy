<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Liste des étudiants - FPL Academy</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8f9fa;
            color: #212529;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .main-content {
            flex: 1;
            padding-bottom: 4rem;
        }

        /* --- RETURN BUTTON - LEFT --- */
        .btn-return {
            background-color: rgba(118, 75, 162, 0.08);
            color: #764ba2;
            padding: 10px 20px;
            border-radius: 100px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            font-size: 0.9rem;
            border: 1px solid rgba(118, 75, 162, 0.1);
            margin-bottom: 2rem;
        }
        .btn-return:hover {
            background-color: #764ba2;
            color: white;
            transform: translateX(-5px);
        }
        .btn-return i {
            color: #764ba2;
            font-size: 0.8rem;
        }
        .btn-return:hover i {
            color: white;
        }

        /* --- HEADER --- */
        .page-header {
            margin-bottom: 2rem;
        }

        .page-title {
            font-weight: 700;
            color: #0f172a;
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
            letter-spacing: -0.02em;
        }

        .page-subtitle {
            color: #64748b;
            font-size: 1rem;
            margin-bottom: 0;
        }

        /* --- TABLE - SIMPLE MODERN --- */
        .table-wrapper {
            background: white;
            border-radius: 16px;
            border: 1px solid #d0d6e2;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
        }

        .table {
            margin-bottom: 0;
            border-collapse: collapse;
            width: 100%;
        }

        .table thead th {
            background: white;
            color: #475569;
            font-weight: 600;
            font-size: 0.75rem;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            padding: 1.25rem 2rem; /* 32px left and right */
            border-bottom: 1px solid #d0d6e2;
            white-space: nowrap;
        }

        .table td {
            padding: 1rem 2rem !important; /*  32px left and right - NOT STICKING TO EDGE */
            border-bottom: 1px solid #f1f5f9;
            vertical-align: middle;
            font-size: 0.95rem;
            margin:0;
            color: #1e293b;

        }

        .table tbody tr:last-child td {
            border-bottom: none;
        }

        .table tbody tr {
            transition: background-color 0.15s ease;
        }

        .table tbody tr:hover {
            background-color: #faf9ff;
        }

        /* --- SIMPLE USER AVATAR - PURPLE BACKGROUND, WHITE LETTER --- */
        .user-avatar {
            width: 40px;
            height: 40px;
            background-color: #dfd4f8; /* Simple solid purple */
            color: #6b46c1;
            font-weight: 600;
            font-size: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%; /* Slightly rounded corners */
            flex-shrink: 0;
        }

        .student-cell {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .student-info {
            display: flex;
            flex-direction: column;
        }

        .student-name {
            font-weight: 600;
            color: #0f172a;
            font-size: 0.95rem;
            margin-bottom: 2px;
        }

        .student-id {
            font-size: 0.7rem;
            color: #64748b;
        }

        /* --- PROGRESS - PURPLE --- */
        .progress-cell {
            display: flex;
            align-items: center;
            gap: 16px;
            min-width: 200px;
        }

        .progress {
            flex: 1;
            height: 6px;
            background: #e2e8f0;
            border-radius: 100px;
            overflow: hidden;
            margin: 0;
        }

        .progress-bar {
            height: 100%;
            background: #6b46c1  !important; /* Simple solid purple */
            border-radius: 100px;
            transition: width 0.2s ease;
        }

        .progress-value {
            font-weight: 600;
            color: #0f172a;
            font-size: 0.85rem;
            min-width: 45px;
        }

        /* --- STATUS BADGE - SIMPLE --- */
        .status-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            padding: 4px 12px;
            border-radius: 100px;
            font-weight: 500;
            font-size: 0.75rem;
            white-space: nowrap;
        }

        .status-badge i {
            font-size: 0.7rem;
        }

        .status-ongoing {
            background: #f8f5ff;
            color: #6b46c1;
        }

        .status-completed {
            background: #ecfdf5;
            color: #059669;
        }

        /* --- DATE CELL --- */
        .date-cell {
            font-size: 0.85rem;
            color: #64748b;
            font-weight: 500;
            white-space: nowrap;
        }

        /* --- EMPTY STATE --- */
        .empty-state {
            text-align: center;
            padding: 3rem 2rem;
        }

        .empty-state i {
            font-size: 2.5rem;
            color: #cbd5e1;
            margin-bottom: 1rem;
        }

        .empty-state h4 {
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 0.25rem;
            font-size: 1.1rem;
        }

        .empty-state p {
            color: #64748b;
            font-size: 0.85rem;
        }

        /* --- ERROR STATE --- */
        .error-state {
            text-align: center;
            padding: 3rem 2rem;
        }

        .error-state i {
            font-size: 2rem;
            color: #dc2626;
            margin-bottom: 0.75rem;
        }

        .error-state h4 {
            font-weight: 600;
            color: #b91c1c;
            margin-bottom: 0.25rem;
            font-size: 1rem;
        }

        .error-state p {
            color: #b91c1c;
            font-size: 0.85rem;
            opacity: 0.9;
        }

        @media (max-width: 992px) {
            .table thead th {
                padding: 1rem 1.5rem;
            }

            .table td {
                padding: 1rem 1.5rem;
            }

            .progress-cell {
                flex-direction: column;
                align-items: flex-start;
                gap: 8px;
                min-width: auto;
            }

            .progress {
                width: 100%;
            }
        }
    </style>
</head>
<body>

<%@ include file="../common/header.jsp" %>

<div class="container mt-5 main-content">
    <!-- RETURN BUTTON - LEFT -->
    <div class="row">
        <div class="col-12">
            <a href="/enseignant/dashboard" class="btn-return">
                <i class="fas fa-arrow-left"></i>
                Retour au Dashboard
            </a>
        </div>
    </div>

    <!-- HEADER -->
    <div class="row page-header">
        <div class="col-12">
            <h1 class="page-title">Étudiants inscrits</h1>
            <p class="page-subtitle">Suivi de la progression de vos apprenants</p>
        </div>
    </div>

    <!-- TABLE - PROPER SPACING LEFT AND RIGHT -->
    <div class="table-wrapper">
        <table class="table">
            <thead>
            <tr>
                <th>Étudiant</th>
                <th>Progression</th>
                <th class="text-center">Statut</th>
                <th class="text-end">Inscription</th>
            </tr>
            </thead>
            <tbody id="etudiantsBody">
            <tr>
                <td colspan="4" style="padding: 0;">
                    <div class="text-center py-5">
                        <div class="spinner-border" style="color: #6b46c1; width: 2.5rem; height: 2.5rem;" role="status">
                            <span class="visually-hidden">Chargement...</span>
                        </div>
                    </div>
                </td>
            </tr>
            </tbody>
        </table>
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
                        <td colspan="4">
                            <div class="empty-state">
                                <i class="fas fa-user-graduate"></i>
                                <h4>Aucun étudiant inscrit</h4>
                                <p>Ce cours n'a pas encore d'apprenants</p>
                            </div>
                        </td>
                    </tr>`;
                return;
            }

            tbody.innerHTML = inscriptions.map(i => {
                const statusLabel = i.termine ? 'Terminé' : 'En cours';
                const statusClass = i.termine ? 'status-completed' : 'status-ongoing';
                const icon = i.termine ? 'fa-circle-check' : 'fa-clock';

                const date = i.dateInscription ? new Date(i.dateInscription) : new Date();
                const formattedDate = date.toLocaleDateString('fr-FR', {
                    day: 'numeric',
                    month: 'short',
                    year: 'numeric'
                });

                return `
                    <tr>
                        <td>
                            <div class="student-cell">
                                <div class="user-avatar">
                                    \${i.etudiant.username.charAt(0).toUpperCase()}
                                </div>
                                <div class="student-info">
                                    <span class="student-name">\${escapeHtml(i.etudiant.username)}</span>
                                    <span class="student-id">ID \${i.etudiant.id}</span>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="progress-cell">
                                <div class="progress">
                                    <div class="progress-bar"
                                         role="progressbar"
                                         style="width: \${i.progression}%">
                                    </div>
                                </div>
                                <span class="progress-value">\${i.progression}%</span>
                            </div>
                        </td>
                        <td class="text-center">
                            <span class="status-badge \${statusClass}">
                                <i class="fas \${icon}"></i>
                                \${statusLabel}
                            </span>
                        </td>
                        <td class="text-end date-cell">
                            \${formattedDate}
                        </td>
                    </tr>
                `;
            }).join("");

        } catch (e) {
            console.error(e);
            document.getElementById("etudiantsBody").innerHTML = `
                <tr>
                    <td colspan="4">
                        <div class="error-state">
                            <i class="fas fa-exclamation-triangle"></i>
                            <h4>Erreur de chargement</h4>
                            <p>Impossible de charger les inscriptions</p>
                        </div>
                    </td>
                </tr>`;
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