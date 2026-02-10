<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

<style>
    /* Custom Header Styling - Dark Theme */
    .navbar-custom {
        background-color: #212529; /* Dark background matching footer */
        border-bottom: 1px solid #333;
        padding-top: 0.8rem;
        padding-bottom: 0.8rem;
    }

    .navbar-brand .logo-icon {
        color: #9b72cf; /* Lighter purple for better contrast on dark */
        font-size: 1.6rem;
        margin-right: 8px;
    }

    .navbar-brand .brand-text {
        color: #fff; /* White text */
        font-weight: 700;
        font-size: 1.3rem;
        letter-spacing: -0.5px;
    }

    .navbar-nav .nav-link {
        font-weight: 500;
        color: #adb5bd; /* Light gray text */
        margin: 0 15px;
        position: relative;
        transition: color 0.3s ease;
    }

    .navbar-nav .nav-link:hover {
        color: #fff;
    }

    .navbar-nav .nav-link.active {
        color: #9b72cf; /* Lighter purple */
        font-weight: 700;
    }

    .user-profile-section {
        border-left: 1px solid #495057; /* Darker border */
        padding-left: 1.5rem;
        margin-left: 1rem;
    }

    .dropdown-menu {
        background-color: #2c3034; /* Dark dropdown */
        border-radius: 0.75rem;
        box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        border: 1px solid #444;
        margin-top: 10px;
    }

    .dropdown-item {
        padding: 10px 20px;
        font-weight: 500;
        color: #e0e0e0;
    }

    .dropdown-item:hover {
        background-color: #343a40;
        color: #9b72cf;
    }

    .dropdown-item.text-danger {
        color: #ff6b6b !important;
    }

    .dropdown-item.text-danger:hover {
        background-color: #343a40;
    }

    /* Remove default button outline */
    .btn:focus, .btn:active {
        outline: none !important;
        box-shadow: none;
    }

    .dropdown-toggle::after {
        display: none;
    }
</style>

<!-- Determine Role and Links -->
<sec:authorize access="hasRole('ROLE_ETUDIANT')">
    <c:set var="homeLink" value="/etudiant/dashboard"/>
    <c:set var="roleLabel" value="Étudiant"/>
</sec:authorize>
<sec:authorize access="hasRole('ROLE_ENSEIGNANT')">
    <c:set var="homeLink" value="/enseignant/dashboard"/>
    <c:set var="roleLabel" value="Enseignant"/>
</sec:authorize>

<nav class="navbar navbar-expand-lg navbar-custom sticky-top shadow-sm">
    <div class="container">

        <!-- Logo -->
        <a class="navbar-brand d-flex align-items-center" href="${homeLink}">
            <i class="fas fa-graduation-cap logo-icon"></i>
            <span class="brand-text">FPL Academy</span>
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Centered Navigation -->
        <div class="collapse navbar-collapse justify-content-center" id="navbarNav">
            <ul class="navbar-nav">
                <!-- Student Links -->
                <sec:authorize access="hasRole('ROLE_ETUDIANT')">
                    <li class="nav-item">
                        <a class="nav-link" href="/etudiant/dashboard">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/etudiant/catalogue">Catalogue</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/etudiant/dashboard#cours">Mes Cours</a>
                    </li>
                </sec:authorize>

                <!-- Teacher Links -->
                <sec:authorize access="hasRole('ROLE_ENSEIGNANT')">
                    <li class="nav-item">
                        <a class="nav-link" href="/enseignant/dashboard">Dashboard</a>
                    </li>
                </sec:authorize>
            </ul>
        </div>

        <!-- User Profile -->
        <div class="d-flex align-items-center user-profile-section">
            <div class="dropdown">
                <a href="#" class="d-flex align-items-center text-decoration-none dropdown-toggle" id="dropdownUser" data-bs-toggle="dropdown" aria-expanded="false">

                    <!-- 1. Image on the Left -->
                    <div class="rounded-circle bg-dark d-flex align-items-center justify-content-center border border-secondary me-2" style="width: 40px; height: 40px;">
                        <i class="fas fa-user text-light"></i>
                    </div>

                    <!-- 2. Name/Role in the Middle -->
                    <div class="text-start me-2">
                        <div class="fw-bold text-light small"><sec:authentication property="principal.username"/></div>
                        <div class="text-muted small" style="font-size: 0.75rem; color: #adb5bd !important;">${roleLabel}</div>
                    </div>

                    <!-- 3. Purple Arrow on the Right -->
                    <i class="fas fa-chevron-down" style="color: #9b72cf; font-size: 0.8rem;"></i>
                </a>

                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownUser">
                    <li>
                        <a class="dropdown-item" href="#">
                            <i class="fas fa-cog me-2"></i> Paramètres
                        </a>
                    </li>
                    <li><hr class="dropdown-divider" style="border-color: #444;"></li>
                    <li>
                        <a class="dropdown-item text-danger" href="/deconnexion">
                            <i class="fas fa-sign-out-alt me-2"></i> Déconnexion
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</nav>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const links = document.querySelectorAll(".navbar-nav .nav-link");
        const currentPath = window.location.pathname;

        links.forEach(link => {
            const href = link.getAttribute('href');
            if (href === currentPath) {
                link.classList.add("active");
            }
        });
    });
</script>
