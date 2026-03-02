<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Configuration i18n --%>
<fmt:setLocale value="${sessionScope.langue == 'en' ? 'en' : 'fr'}" />
<fmt:setBundle basename="messages" var="msg" />

<!DOCTYPE html>
<html lang="${sessionScope.langue}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CDL BLOG - <fmt:message key="connexion.titre" bundle="${msg}"/></title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['Inter', 'sans-serif'],
                        display: ['Space Grotesk', 'sans-serif'],
                    },
                    colors: {
                        neon: { cyan: '#00f3ff', purple: '#b026ff', pink: '#ff2d95', green: '#39ff14' },
                        dark: { 700: '#1a1a2e', 800: '#12121f', 900: '#0a0a14' },
                    }
                }
            }
        }
    </script>
    <style>
        body { font-family: 'Inter', sans-serif; background: #0a0a14; color: #fff; }

        /* Split image panel */
        .login-hero {
            position: relative;
            background: url('https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=800&q=80') center/cover no-repeat;
        }
        .login-hero::after {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, rgba(0,0,0,0.55) 0%, rgba(10,10,20,0.7) 100%);
        }
        .login-hero-content { position: relative; z-index: 2; }

        /* Gradient button */
        .btn-gradient {
            background: linear-gradient(90deg, #00f3ff 0%, #b026ff 50%, #ff2d95 100%);
            background-size: 200% auto;
            transition: background-position .4s ease, box-shadow .3s;
        }
        .btn-gradient:hover {
            background-position: right center;
            box-shadow: 0 4px 30px rgba(176,38,255,0.35);
        }

        /* Input focus glow */
        .input-login:focus {
            border-color: #00f3ff;
            box-shadow: 0 0 0 3px rgba(0,243,255,0.15);
        }

        /* Neon logo icon */
        .logo-icon-glow {
            box-shadow: 0 0 30px rgba(0,243,255,0.3), 0 0 60px rgba(176,38,255,0.2);
        }

        @keyframes float { 0%,100%{transform:translateY(0)} 50%{transform:translateY(-8px)} }
        .float-anim { animation: float 4s ease-in-out infinite; }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(24px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .fade-in-up { animation: fadeInUp .6s ease-out both; }
        .fade-in-up-d1 { animation-delay: .1s; }
        .fade-in-up-d2 { animation-delay: .2s; }
        .fade-in-up-d3 { animation-delay: .3s; }
        .fade-in-up-d4 { animation-delay: .4s; }
    </style>
</head>
<body class="antialiased">

    <div class="min-h-screen flex flex-col lg:flex-row">

        <!-- ===== LEFT PANEL — Hero Image + Branding ===== -->
        <div class="login-hero hidden lg:flex lg:w-1/2 items-end p-12">
            <div class="login-hero-content w-full">
                <!-- Logo -->
                <div class="w-20 h-20 rounded-2xl bg-gradient-to-br from-cyan-400 via-purple-500 to-pink-500 flex items-center justify-center mb-8 logo-icon-glow float-anim">
                    <i class="fas fa-bolt text-white text-3xl"></i>
                </div>
                <h1 class="text-5xl font-display font-bold text-white mb-3 leading-tight">
                    <span class="bg-clip-text text-transparent bg-gradient-to-r from-cyan-300 via-purple-300 to-pink-300">CDL BLOG</span>
                </h1>
                <p class="text-xl text-gray-300/90 font-light">Partagez votre monde en n&eacute;on</p>
            </div>
        </div>

        <!-- ===== RIGHT PANEL — Login Form ===== -->
        <div class="flex-1 flex items-center justify-center p-6 lg:p-12 bg-dark-900">
            <div class="w-full max-w-md fade-in-up">

                <!-- Mobile logo (hidden on desktop) -->
                <div class="lg:hidden flex items-center gap-3 mb-10 justify-center">
                    <div class="w-12 h-12 rounded-xl bg-gradient-to-br from-cyan-400 via-purple-500 to-pink-500 flex items-center justify-center">
                        <i class="fas fa-bolt text-white text-xl"></i>
                    </div>
                    <span class="text-2xl font-display font-bold bg-clip-text text-transparent bg-gradient-to-r from-cyan-300 to-purple-300">CDL BLOG</span>
                </div>

                <!-- Title -->
                <h2 class="text-3xl font-bold font-display text-white mb-10 fade-in-up fade-in-up-d1">
                    <fmt:message key="connexion.titre" bundle="${msg}"/>
                </h2>

                <!-- Error / Success Messages -->
                <c:if test="${not empty erreur}">
                    <div class="mb-6 p-4 rounded-xl bg-red-500/10 border border-red-500/30 text-red-400 text-sm flex items-center gap-3 fade-in-up">
                        <i class="fas fa-exclamation-circle text-lg"></i>
                        ${erreur}
                    </div>
                </c:if>
                <c:if test="${not empty param.registered}">
                    <div class="mb-6 p-4 rounded-xl bg-green-500/10 border border-green-500/30 text-green-400 text-sm flex items-center gap-3 fade-in-up">
                        <i class="fas fa-check-circle text-lg"></i>
                        Compte cr&eacute;&eacute; ! Vous pouvez maintenant vous connecter.
                    </div>
                </c:if>

                <!-- Login Form -->
                <form method="post" action="${pageContext.request.contextPath}/connexion" class="space-y-5">
                    ${csrfField}
                    <input type="hidden" name="redirect" value="${param.redirect}">

                    <!-- Email -->
                    <div class="fade-in-up fade-in-up-d1">
                        <label class="block text-sm text-gray-400 mb-2 font-medium">Email</label>
                        <div class="relative">
                            <span class="absolute left-4 top-1/2 -translate-y-1/2 text-gray-500">
                                <i class="fas fa-envelope"></i>
                            </span>
                            <input type="email" name="email" placeholder="user@neonblog.com" required autocomplete="email"
                                class="input-login w-full pl-12 pr-4 py-3.5 rounded-xl bg-dark-700 border border-white/10 text-white placeholder-gray-500 focus:outline-none transition-all">
                        </div>
                    </div>

                    <!-- Password -->
                    <div class="fade-in-up fade-in-up-d2">
                        <label class="block text-sm text-gray-400 mb-2 font-medium">Mot de passe</label>
                        <div class="relative">
                            <span class="absolute left-4 top-1/2 -translate-y-1/2 text-gray-500">
                                <i class="fas fa-lock"></i>
                            </span>
                            <input type="password" name="mot_de_passe" id="loginPassword" placeholder="&#8226;&#8226;&#8226;&#8226;&#8226;&#8226;&#8226;&#8226;" required autocomplete="current-password"
                                class="input-login w-full pl-12 pr-12 py-3.5 rounded-xl bg-dark-700 border border-white/10 text-white placeholder-gray-500 focus:outline-none transition-all">
                            <button type="button" onclick="togglePassword()" class="absolute right-4 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-300 transition-colors">
                                <i class="fas fa-eye" id="toggleIcon"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Remember me + Forgot -->
                    <div class="flex items-center justify-between text-sm fade-in-up fade-in-up-d3">
                        <label class="flex items-center gap-2 cursor-pointer group">
                            <input type="checkbox" class="rounded bg-dark-700 border-white/20 text-neon-cyan focus:ring-neon-cyan w-4 h-4">
                            <span class="text-gray-400 group-hover:text-gray-300 transition-colors">Se souvenir de moi</span>
                        </label>
                        <a href="#" class="text-neon-pink hover:text-pink-300 font-medium transition-colors">Mot de passe oubli&eacute; ?</a>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" class="w-full py-4 mt-2 rounded-xl btn-gradient text-white font-bold text-lg tracking-wide flex items-center justify-center gap-3 group fade-in-up fade-in-up-d3">
                        Se connecter
                        <i class="fas fa-arrow-right group-hover:translate-x-2 transition-transform duration-300"></i>
                    </button>
                </form>

                <!-- Divider -->
                <div class="flex items-center gap-4 my-8 fade-in-up fade-in-up-d4">
                    <div class="flex-1 h-px bg-white/10"></div>
                    <span class="text-gray-500 text-sm font-medium uppercase tracking-wider">ou</span>
                    <div class="flex-1 h-px bg-white/10"></div>
                </div>

                <!-- Social Login Buttons -->
                <div class="grid grid-cols-2 gap-4 fade-in-up fade-in-up-d4">
                    <button class="flex items-center justify-center gap-3 py-3.5 rounded-xl border border-white/10 bg-dark-700 hover:bg-white/5 transition-all group">
                        <svg class="w-5 h-5" viewBox="0 0 24 24"><path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92a5.06 5.06 0 01-2.2 3.32v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.1z" fill="#4285F4"/><path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/><path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05"/><path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/></svg>
                        <span class="text-gray-300 font-medium group-hover:text-white transition-colors">Google</span>
                    </button>
                    <button class="flex items-center justify-center gap-3 py-3.5 rounded-xl border border-white/10 bg-dark-700 hover:bg-white/5 transition-all group">
                        <i class="fab fa-apple text-xl text-gray-300 group-hover:text-white transition-colors"></i>
                        <span class="text-gray-300 font-medium group-hover:text-white transition-colors">Apple</span>
                    </button>
                </div>

                <!-- Sign up link -->
                <p class="mt-8 text-center text-gray-400 text-sm fade-in-up fade-in-up-d4">
                    Pas encore de compte ?
                    <a href="${pageContext.request.contextPath}/inscription" class="text-neon-cyan hover:text-cyan-300 font-semibold transition-colors ml-1">S'inscrire</a>
                </p>
            </div>
        </div>
    </div>

    <script>
        function togglePassword() {
            const input = document.getElementById('loginPassword');
            const icon = document.getElementById('toggleIcon');
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.replace('fa-eye', 'fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.replace('fa-eye-slash', 'fa-eye');
            }
        }
    </script>
</body>
</html>
