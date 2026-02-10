<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Liste des &eacute;tudiants - FPL Academy</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        :root {
            --accent-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --bg-dark: #0f1113;
            --card-bg: #1a1d20;
        }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: var(--bg-dark);
            color: #e2e8f0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .main-content { flex: 1; padding-bottom: 3rem; }

        /* Premium Card Header */
        .page-header {
            border-bottom: 1px solid rgba(255,255,255,0.05);
            padding-bottom: 1.5rem;
            margin-bottom: 2rem;
        }

        .card-custom {
            background-color: var(--card-bg);
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            overflow: hidden;
        }

        /* Table Styling */
        .table { color: #cbd5e0; margin-bottom: 0; }
        
        .table-dark-header th {
            background-color: rgba(255,255,255,0.02);
            color: #718096;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 1px;
            padding: 1.25rem 1rem;
        }

        .table td { 
            padding: 1.25rem 1rem; 
            border-bottom: 1px solid rgba(255,255,255,0.03);
            vertical-align: middle;
        }

        .table-hover tbody tr:hover { 
            background-color: rgba(255,255,255,0.02);
            transition: background 0.2s ease;
        }

        /* User Avatar */
        .avatar-circle {
            background: var(--accent-gradient);
            font-weight: 700;
            box-shadow: 0 4px 10px rgba(118, 75, 162, 0.3);
        }

        /* Progress Bar */
        .progress { 
            height: 6px; 
            background-color: #2d3748; 
            border-radius: 10px; 
            overflow: visible;
        }
        .progress-bar { 
            border-radius: 10px; 
            box-shadow: 0 0 10px rgba(102, 126, 234, 0.5);
        }

        /* Badges */
        .badge-premium {
            padding: 0.5em 1em;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.7rem;
        }
        .bg-success-subtle { background: rgba(72, 187, 120, 0.1); color: #48bb78; border: 1px solid rgba(72, 187, 120, 0.2); }
        .bg-warning-subtle { background: rgba(237, 137, 54, 0.1); color: #ed8936; border: 1px solid rgba(237, 137, 54, 0.2); }
    </style>
</head>
<body>

<%@ include file="../common/header.jsp" %>

<div class="container mt-5 main-content">
    <div class="d-flex justify-content-between align-items-center page-header">
        <div>
            <h3 class="fw-bold text-white mb-1">&Eacute;tudiants inscrits</h3>
            <p class="text-muted small mb-0">Gestion et suivi de la progression en temps r&eacute;el</p>
        </div>
        <a href="/enseignant/dashboard" class="btn btn-outline-light btn-sm rounded-pill px-3">
            <i class="fas fa-arrow-left me-2"></i> Retour
        </a>
    </div>

    <div class="card card-custom">
        <div class="table-responsive">
            <table class="table table-hover">
                <thead class="table-dark-header">
                <tr>
                    <th class="ps-4">&Eacute;tudiant</th>
                    <th>Progression</th>
                    <th>Statut</th>
                    <th class="text-end pe-4">Date d'inscription</th>
                </tr>
                </thead>
                <tbody id="etudiantsBody">
                    <tr>
                        <td colspan="4" class="text-center py-5">
                            <div class="spinner-border text-primary" role="status"></div>
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
            const res = await fetch(`/api/enseignant/cours/${coursId}/inscriptions`);
            if (!res.ok) throw new Error();
            const inscriptions = await res.json();
            const tbody = document.getElementById("etudiantsBody");

            if (inscriptions.length === 0) {
                tbody.innerHTML = `
                    <tr>
                        <td colspan="4" class="text-center py-5 text-muted">
                            <i class="fas fa-user-friends fa-3x mb-3 opacity-20"></i><br>
                            Aucun &eacute;tudiant n'est encore inscrit.
                        </td>
                    </tr>`;
                return;
            }

            tbody.innerHTML = inscriptions.map(i => {
                // Unicode for accents to prevent Eclipse bugs
                const statusLabel = i.termine ? 'Termin\u00E9' : 'En cours';
                const statusClass = i.termine ? 'bg-success-subtle' : 'bg-warning-subtle';
                const icon = i.termine ? 'fa-check-circle' : 'fa-clock';
                
                return `
                <tr>
                    <td class="ps-4">
                        <div class="d-flex align-items-center">
                            <div class="avatar-circle rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 40px; height: 40px; color: white;">
                                \${i.etudiant.username.charAt(0).toUpperCase()}
                            </div>
                            <div>
                                <div class="fw-bold text-white">\${escapeHtml(i.etudiant.username)}</div>
                                <div style="font-size: 0.7rem; color: #718096;">ID #\${i.etudiant.id}</div>
                            </div>
                        </div>
                    </td>
                    <td style="width: 25%;">
                        <div class="d-flex align-items-center">
                            <div class="progress flex-grow-1 me-3">
                                <div class="progress-bar" role="progressbar" 
                                     style="width: \${i.progression}%; background: var(--accent-gradient);"></div>
                            </div>
                            <span class="fw-bold small">\${i.progression}%</span>
                        </div>
                    </td>
                    <td>
                        <span class="badge-premium \${statusClass}">
                            <i class="fas \${icon} me-1"></i> \${statusLabel}
                        </span>
                    </td>
                    <td class="text-end pe-4 text-muted small">
                        \${new Date().toLocaleDateString('fr-FR', { day: 'numeric', month: 'short', year: 'numeric' })}
                    </td>
                </tr>`;
            }).join("");
        } catch (e) {
            document.getElementById("etudiantsBody").innerHTML = `
                <tr><td colspan="4" class="text-center text-danger py-5">
                <i class="fas fa-exclamation-triangle mb-2"></i><br>Erreur de chargement des donn&eacute;es</td></tr>`;
        }
    }

    function escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    loadInscriptions();
</script>
</body>
</html>