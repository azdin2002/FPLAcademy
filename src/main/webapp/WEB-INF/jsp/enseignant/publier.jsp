<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Publier un Cours - FPL Academy</title>
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
        .card-header {
            background-color: #2c2c2c;
            border-bottom: 1px solid #333;
            color: #fff;
            border-radius: 12px 12px 0 0 !important;
        }
        .form-control {
            background-color: #2c3034;
            border: 1px solid #444;
            color: #e0e0e0;
        }
        .form-control:focus {
            background-color: #2c3034;
            border-color: #764ba2;
            color: #fff;
            box-shadow: 0 0 0 0.25rem rgba(118, 75, 162, 0.25);
        }
        .form-label { color: #adb5bd; font-weight: 500; }
        .btn-purple {
            background-color: #764ba2;
            border-color: #764ba2;
            color: white;
            font-weight: 600;
        }
        .btn-purple:hover {
            background-color: #5a377d;
            border-color: #5a377d;
            color: white;
        }
        .btn-outline-light {
            border-color: #444;
            color: #adb5bd;
        }
        .btn-outline-light:hover {
            background-color: #333;
            color: #fff;
        }
    </style>
</head>
<body>

<%@ include file="../common/header.jsp" %>

<div class="container mt-5 main-content">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card card-custom">
                <div class="card-header py-3">
                    <h4 class="mb-0 fw-bold"><i class="fas fa-plus-circle me-2 text-primary" style="color: #9b72cf !important;"></i>Nouveau Cours</h4>
                </div>
                <div class="card-body p-4">
                    <form id="coursForm">
                        <div class="mb-3">
                            <label class="form-label">Titre du cours</label>
                            <input type="text" id="titre" name="titre" class="form-control" 
                                   placeholder="Ex: Maîtriser Java Spring Boot" required />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Description courte</label>
                            <textarea id="description" name="description" class="form-control" 
                                      rows="2" placeholder="Un bref résumé de ce que les étudiants vont apprendre..." required></textarea>
                        </div>
                        <div class="mb-4">
                            <label class="form-label">Contenu détaillé (HTML possible)</label>
                            <textarea id="contenu" name="contenu" class="form-control" rows="10" placeholder="<p>Introduction au cours...</p>"></textarea>
                            <div class="form-text text-muted small mt-1">Vous pouvez utiliser des balises HTML pour formater votre cours.</div>
                        </div>
                        <div class="d-flex justify-content-between pt-3 border-top border-secondary">
                            <a href="/enseignant/dashboard" class="btn btn-outline-light">Annuler</a>
                            <button type="submit" class="btn btn-purple px-4" id="submitBtn">
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
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Publication...';
        
        const formData = {
            titre: document.getElementById('titre').value,
            description: document.getElementById('description').value,
            contenu: document.getElementById('contenu').value
        };
        
        try {
            const response = await fetch('/api/enseignant/cours', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(formData)
            });
            
            if (!response.ok) throw new Error('Failed to create course');
            
            window.location.href = '/enseignant/dashboard?success=created';
        } catch (error) {
            console.error('Error creating course:', error);
            alert('Erreur lors de la publication du cours. Veuillez réessayer.');
            submitBtn.disabled = false;
            submitBtn.innerHTML = '<i class="fas fa-paper-plane me-2"></i>Publier le cours';
        }
    });
</script>
</body>
</html>
