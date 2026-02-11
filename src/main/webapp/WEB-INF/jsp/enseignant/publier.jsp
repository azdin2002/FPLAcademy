<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Publier un Cours - FPL Academy</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8f9fa; /* Unified Light background */
            color: #212529;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .main-content { flex: 1; }

        /* --- New "Return to Dashboard" Style (Matches your stat-badge) --- */
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

        /* --- Card Styling (Matches Student Cards) --- */
        .card-premium {
            background-color: #ffffff;
            border: 1px solid #e9ecef;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        .card-header-clean {
            background-color: #ffffff;
            border-bottom: 1px solid #e9ecef;
            padding: 1.5rem 2rem;
            border-radius: 12px 12px 0 0;
        }

        /* --- Form Styling --- */
        .form-label {
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #6c757d;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        .form-control {
            border: 1.5px solid #e9ecef;
            border-radius: 10px;
            padding: 0.75rem 1rem;
            transition: border-color 0.2s;
        }
        .form-control:focus {
            border-color: #764ba2;
            box-shadow: 0 0 0 4px rgba(118, 75, 162, 0.1);
            outline: none;
        }

        /* --- Buttons --- */
        .btn-purple {
            background-color: #764ba2;
            border-color: #764ba2;
            color: white;
            font-weight: 600;
            border-radius: 25px;
            padding: 10px 25px;
            transition: all 0.2s;
        }
        .btn-purple:hover {
            background-color: #5a377d;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(118, 75, 162, 0.2);
            color: white;
        }
        .btn-cancel {
            color: #6c757d;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
        }
        .btn-cancel:hover { color: #212529; }
    </style>
</head>
<body>

<%@ include file="../common/header.jsp" %>

<div class="container mt-5 main-content">
    <div class="row mb-4 align-items-center">
        <div class="col-6">
            <a href="/enseignant/dashboard" class="btn-return">
                <i class="fas fa-arrow-left"></i> Retour au Dashboard
            </a>
        </div>
        <div class="col-6 text-end">
            <span class="text-muted small fw-bold text-uppercase" style="letter-spacing: 1px;">Espace Enseignant</span>
        </div>
    </div>

    <div class="row justify-content-center mb-5">
        <div class="col-md-10 col-lg-8">
            <div class="card card-premium">
                <div class="card-header-clean">
                    <h3 class="fw-bold mb-1 text-dark">Nouveau Cours</h3>
                    <p class="text-muted mb-0 small">Remplissez les informations pour publier votre nouvelle formation.</p>
                </div>
                <div class="card-body p-4 p-md-5">
                    <form id="coursForm">
                        <div class="mb-4">
                            <label class="form-label">Titre du cours</label>
                            <input type="text" id="titre" name="titre" class="form-control" 
                                   placeholder="Ex: Ma&icirc;triser Java Spring Boot" required />
                        </div>
                        <div class="mb-4">
                            <label class="form-label">Description courte</label>
                            <textarea id="description" name="description" class="form-control" 
                                      rows="2" placeholder="Un bref r&eacute;sum&eacute; de ce que les &eacute;tudiants vont apprendre..." required></textarea>
                        </div>
                        <div class="mb-4">
                            <label class="form-label">Contenu d&eacute;taill&eacute;</label>
                            <textarea id="contenu" name="contenu" class="form-control" rows="12" placeholder="D&eacute;veloppez votre le&ccedil;on ici..."></textarea>
                            <div class="form-text text-muted small mt-2">
                                <i class="fas fa-info-circle me-1"></i> Vous pouvez utiliser des balises HTML pour la mise en forme.
                            </div>
                        </div>

                        <div class="d-flex justify-content-between align-items-center pt-4 border-top">
                            <a href="/enseignant/dashboard" class="btn-cancel">Annuler</a>
                            <button type="submit" class="btn btn-purple" id="submitBtn">
                                <i class="fas fa-paper-plane me-2"></i>Publier le cours
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>

<script>
    document.getElementById('coursForm').addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const submitBtn = document.getElementById('submitBtn');
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Publication en cours...';
        
        const formData = {
            titre: document.getElementById('titre').value,
            description: document.getElementById('description').value,
            contenu: document.getElementById('contenu').value
        };
        
        try {
            const response = await fetch('/api/enseignant/cours', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(formData)
            });
            
            if (!response.ok) throw new Error('Failed to create course');
            
            window.location.href = '/enseignant/dashboard?success=created';
        } catch (error) {
            console.error('Error creating course:', error);
            alert('Erreur lors de la publication. Veuillez r\u00E9essayer.');
            submitBtn.disabled = false;
            submitBtn.innerHTML = '<i class="fas fa-paper-plane me-2"></i>Publier le cours';
        }
    });
</script>
</body>
</html>