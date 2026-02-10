<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Liste des étudiants - FPL Academy</title>
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
        .card-custom {
            background-color: #1e1e1e;
            border: 1px solid #333;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .table { color: #e0e0e0; margin-bottom: 0; }
        .table-hover tbody tr:hover { color: #e0e0e0; background-color: #2c2c2c; }
        .table-dark-header th {
            background-color: #2c2c2c;
            color: #adb5bd;
            border-bottom: 1px solid #444;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.85rem;
        }
        .table td, .table th { border-color: #333; vertical-align: middle; }
        .btn-outline-secondary {
            color: #adb5bd;
            border-color: #adb5bd;
        }
        .btn-outline-secondary:hover {
            background-color: #adb5bd;
            color: #121212;
        }
        .progress { height: 8px; background-color: #333; border-radius: 4px; }
    </style>
</head>
<body>

<%@ include file="../common/header.jsp" %>

<div class="container mt-5 main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold text-light mb-0">👥 Étudiants inscrits</h3>
        <a href="/enseignant/dashboard" class="btn btn-outline-secondary btn-sm">
            <i class="fas fa-arrow-left me-1"></i> Retour
        </a>
    </div>

    <div class="card card-custom overflow-hidden">
        <div class="table-responsive">
            <table class="table table-hover">
                <thead class="table-dark-header">
                <tr>
                    <th class="ps-4">Étudiant</th>
                    <th>Progression</th>
                    <th>Statut</th>
                    <th class="text-end pe-4">Date d'inscription</th>
                </tr>
                </thead>
                <tbody id="etudiantsBody">
                    <!-- Data loaded via JS -->
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
                            <i class="fas fa-user-slash fa-2x mb-3"></i><br>
                            Aucun étudiant n'est encore inscrit à ce cours.
                        </td>
                    </tr>
                `;
                return;
            }

            tbody.innerHTML = inscriptions.map(i => `
                <tr>
                    <td class="ps-4">
                        <div class="d-flex align-items-center">
                            <div class="rounded-circle bg-secondary d-flex align-items-center justify-content-center me-3" style="width: 35px; height: 35px; color: white;">
                                \${i.etudiant.username.charAt(0).toUpperCase()}
                            </div>
                            <div>
                                <div class="fw-bold">\${escapeHtml(i.etudiant.username)}</div>
                                <div class="small text-muted">ID: \${i.etudiant.id}</div>
                            </div>
                        </div>
                    </td>
                    <td style="width: 30%;">
                        <div class="d-flex align-items-center">
                            <div class="progress flex-grow-1 me-3">
                                <div class="progress-bar" role="progressbar" style="width: \${i.progression}%; background-color: #764ba2;"></div>
                            </div>
                            <span class="small text-muted">\${i.progression}%</span>
                        </div>
                    </td>
                    <td>
                        <span class="badge \${i.termine ? 'bg-success' : 'bg-warning text-dark'}">
                            \${i.termine ? '<i class="fas fa-check me-1"></i>Terminé' : '<i class="fas fa-spinner me-1"></i>En cours'}
                        </span>
                    </td>
                    <td class="text-end pe-4 text-muted small">
                        \${new Date().toLocaleDateString()} <!-- Placeholder date -->
                    </td>
                </tr>
            `).join("");
        } catch (e) {
            document.getElementById("etudiantsBody").innerHTML = `
                <tr><td colspan="4" class="text-center text-danger py-4">Erreur de chargement</td></tr>
            `;
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
