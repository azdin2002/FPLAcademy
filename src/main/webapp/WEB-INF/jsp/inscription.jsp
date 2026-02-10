<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription - FPL Academy</title>
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
        .form-control:focus, .form-select:focus {
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
            border-right: none;
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
            border-right: 1px solid #ced4da;
            color: #6c757d; /* Gray color */
            cursor: pointer;
        }
        #togglePassword:hover {
            color: #495057;
        }
    </style>
</head>
<body>

<div class="login-card">
    <h2><i class="fas fa-graduation-cap logo-icon"></i> FPL Academy</h2>
    <p class="text-center text-muted mb-4">Créez votre compte</p>

    <div id="errorMessage" class="alert alert-danger py-2 small text-center" style="display:none;"></div>

    <form id="registerForm">
        <div class="mb-3">
            <label class="form-label small fw-bold">Nom d'utilisateur</label>
            <div class="input-group">
                <span class="input-group-text"><i class="fas fa-user"></i></span>
                <input type="text" id="username" name="username" class="form-control" placeholder="votre nom" required style="border-right: 1px solid #ced4da;">
            </div>
        </div>
        
        <div class="mb-3">
            <label class="form-label small fw-bold">Mot de passe</label>
            <div class="input-group">
                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
                <span class="input-group-text" id="togglePassword">
                    <i class="fas fa-eye" id="eye-icon"></i>
                </span>
            </div>
        </div>
        
        <div class="mb-4">
            <label class="form-label small fw-bold">Votre profil</label>
            <div class="input-group">
                <span class="input-group-text"><i class="fas fa-id-badge"></i></span>
                <select id="role" name="role" class="form-select" required style="border-left: none; border-right: 1px solid #ced4da;">
                    <option value="ROLE_ETUDIANT">Étudiant</option>
                    <option value="ROLE_ENSEIGNANT">Enseignant</option>
                </select>
            </div>
        </div>

        <button type="submit" class="btn btn-primary w-100 mb-3" id="submitBtn">
            <i class="fas fa-user-plus me-2"></i>S'inscrire
        </button>
    </form>

    <div class="text-center">
        <p class="small text-muted">
            Déjà inscrit ? <a href="/connexion" class="text-decoration-none fw-bold" style="color: #764ba2;">Se connecter</a>
        </p>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Password Toggle Logic
    const togglePassword = document.getElementById('togglePassword');
    const passwordInput = document.getElementById('password');
    const eyeIcon = document.getElementById('eye-icon');

    togglePassword.addEventListener('click', function () {
        const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
        passwordInput.setAttribute('type', type);

        eyeIcon.classList.toggle('fa-eye');
        eyeIcon.classList.toggle('fa-eye-slash');
    });

    // Registration Form Logic
    document.getElementById('registerForm').addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const submitBtn = document.getElementById('submitBtn');
        const errorDiv = document.getElementById('errorMessage');
        
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Création...';
        errorDiv.style.display = 'none';
        
        const formData = {
            username: document.getElementById('username').value,
            password: document.getElementById('password').value,
            role: document.getElementById('role').value
        };
        
        try {
            const response = await fetch('/api/users/inscription', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(formData)
            });
            
            if (!response.ok) {
                const error = await response.json();
                throw new Error(error.error || 'Erreur lors de l\'inscription');
            }
            
            // Redirect to login page after successful registration
            window.location.href = '/connexion?inscriptionSuccess';
        } catch (error) {
            console.error('Error during registration:', error);
            errorDiv.textContent = error.message;
            errorDiv.style.display = 'block';
            submitBtn.disabled = false;
            submitBtn.innerHTML = '<i class="fas fa-user-plus me-2"></i>S\'inscrire';
        }
    });
</script>
</body>
</html>