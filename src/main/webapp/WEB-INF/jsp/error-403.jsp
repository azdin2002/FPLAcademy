<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Accès Refusé - FPL Academy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #f8f9fa;
        }
        .error-container {
            text-align: center;
            max-width: 500px;
            padding: 40px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        .icon-lock {
            font-size: 80px;
            color: #dc3545;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

    <div class="error-container">
        <div class="icon-lock">🔒</div>
        <h1 class="display-5 fw-bold text-danger">403</h1>
        <h2 class="mb-3">Accès Interdit</h2>
        <p class="text-muted mb-4">
            Désolé, vous n'avez pas les permissions nécessaires pour accéder à cette page. 
            Cette zone est réservée exclusivement aux enseignants.
        </p>
        <div class="d-grid gap-2">
            <a href="/" class="btn btn-primary">Retour à l'accueil</a>
            <a href="/deconnexion" class="btn btn-outline-secondary">Changer de compte</a>
        </div>
    </div>

</body>
</html>