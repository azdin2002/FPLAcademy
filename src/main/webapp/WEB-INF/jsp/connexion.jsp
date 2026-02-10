<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - FPL Academy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
        }
        .login-card {
            background: white;
            padding: 2.5rem;
            border-radius: 1rem;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 400px;
        }
        .login-card h2 {
            font-weight: 700;
            color: #333;
            margin-bottom: 0.5rem; /* Reduced margin */
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        .logo-icon {
            color: #764ba2;
            font-size: 1.8rem;
        }
        .btn-primary {
            background: #764ba2;
            border: none;
            padding: 0.8rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            background: #5a377d;
            transform: translateY(-2px);
        }
        .form-control:focus {
            border-color: #764ba2;
            box-shadow: 0 0 0 0.25rem rgba(118, 75, 162, 0.25);
        }
        .input-group-text {
            background-color: #f8f9fa;
            border-right: none;
            color: #764ba2;
        }
        .form-control {
            border-left: none;
            border-right: none; /* Remove right border for password input */
        }
        .form-control:focus {
            border-color: #ced4da;
            box-shadow: none;
            border-left: none;
            border-right: none;
        }
        .input-group:focus-within {
            box-shadow: 0 0 0 0.25rem rgba(118, 75, 162, 0.25);
            border-radius: 0.375rem;
        }
        .input-group:focus-within .form-control,
        .input-group:focus-within .input-group-text {
            border-color: #764ba2;
        }

        /* Eye Icon Styling */
        #togglePassword {
            background: transparent;
            border-left: none;
            border-right: 1px solid #ced4da; /* Keep outer border */
            color: #6c757d; /* Gray color */
            cursor: pointer;
        }
        #togglePassword:hover {
            color: #495057;
        }
        /* Fix for password input border */
        input[type="password"], input[type="text"]#password {
             border-right: none;
        }
    </style>
</head>
<body>

<div class="login-card">
    <h2><i class="fas fa-graduation-cap logo-icon"></i> FPL Academy</h2>
    <p class="text-center text-muted mb-4">Ravie de vous revoir !</p>

    <c:if test="${param.error != null}">
        <div class="alert alert-danger py-2 small text-center">
            Utilisateur ou mot de passe incorrect.
        </div>
    </c:if>
    <c:if test="${param.inscriptionSuccess != null}">
        <div class="alert alert-success py-2 small text-center">
            Inscription réussie ! Vous pouvez maintenant vous connecter.
        </div>
    </c:if>

    <form action="/login" method="post">
        <div class="mb-3">
            <label class="form-label small fw-bold">Nom d'utilisateur</label>
            <div class="input-group">
                <span class="input-group-text"><i class="fas fa-user"></i></span>
                <input type="text" name="username" class="form-control" placeholder="votre nom" required style="border-right: 1px solid #ced4da;">
            </div>
        </div>
        
        <div class="mb-4">
            <label class="form-label small fw-bold">Mot de passe</label>
            <div class="input-group">
                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                <input type="password" name="password" id="password" class="form-control" placeholder="••••••••" required>
                <span class="input-group-text" id="togglePassword">
                    <i class="fas fa-eye" id="eye-icon"></i>
                </span>
            </div>
        </div>

        <button type="submit" class="btn btn-primary w-100 mb-3">
            <i class="fas fa-sign-in-alt me-2"></i>Se connecter
        </button>
    </form>

    <div class="text-center">
        <p class="small text-muted">
            Pas encore de compte ? <a href="/inscription" class="text-decoration-none fw-bold" style="color: #764ba2;">S'inscrire</a>
        </p>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const togglePassword = document.getElementById('togglePassword');
    const passwordInput = document.getElementById('password');
    const eyeIcon = document.getElementById('eye-icon');

    togglePassword.addEventListener('click', function () {
        const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
        passwordInput.setAttribute('type', type);

        eyeIcon.classList.toggle('fa-eye');
        eyeIcon.classList.toggle('fa-eye-slash');
    });
</script>
</body>
</html>