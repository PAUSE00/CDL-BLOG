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
    <title>CDL BLOG - <fmt:message key="app.nom" bundle="${msg}"/> - ${pageTitle}</title>
    <!-- Tailwind et Polices Modernes -->
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
                        neon: {
                            cyan: '#00f3ff',
                            pink: '#ff00ff',
                            purple: '#b026ff',
                            yellow: '#ffff00',
                            green: '#00ff9d',
                        },
                        dark: {
                            900: '#0a0a0f',
                            800: '#12121a',
                            700: '#1a1a2e',
                            600: '#252542',
                        }
                    },
                    animation: {
                        'pulse-neon': 'pulseNeon 2s cubic-bezier(0.4, 0, 0.6, 1) infinite',
                        'gradient-x': 'gradientX 15s ease infinite',
                        'float': 'float 6s ease-in-out infinite',
                        'spin-slow': 'spin 20s linear infinite',
                        'bounce-slow': 'bounce 3s infinite',
                        'slide-in': 'slideIn 0.3s ease-out',
                        'fade-in': 'fadeIn 0.3s ease-out',
                        'scale-in': 'scaleIn 0.2s ease-out',
                        'story-progress': 'storyProgress 5s linear',
                    },
                    keyframes: {
                        pulseNeon: {
                            '0%, 100%': { boxShadow: '0 0 20px rgba(0, 243, 255, 0.5)' },
                            '50%': { boxShadow: '0 0 40px rgba(0, 243, 255, 0.8)' },
                        },
                        gradientX: {
                            '0%, 100%': { backgroundPosition: '0% 50%' },
                            '50%': { backgroundPosition: '100% 50%' },
                        },
                        float: {
                            '0%, 100%': { transform: 'translateY(0)' },
                            '50%': { transform: 'translateY(-20px)' },
                        },
                        slideIn: {
                            '0%': { transform: 'translateX(100%)', opacity: '0' },
                            '100%': { transform: 'translateX(0)', opacity: '1' },
                        },
                        fadeIn: {
                            '0%': { opacity: '0' },
                            '100%': { opacity: '1' },
                        },
                        scaleIn: {
                            '0%': { transform: 'scale(0.9)', opacity: '0' },
                            '100%': { transform: 'scale(1)', opacity: '1' },
                        },
                        storyProgress: {
                            '0%': { width: '0%' },
                            '100%': { width: '100%' },
                        }
                    }
                }
            }
        }
    </script>
    <style>
        * { box-sizing: border-box; }
        
        body {
            background: #0a0a0f;
            color: #ffffff;
            font-family: 'Inter', sans-serif;
            overflow-x: hidden;
        }

        /* Custom Scrollbar */
        ::-webkit-scrollbar { width: 6px; height: 6px; }
        ::-webkit-scrollbar-track { background: #0a0a0f; }
        ::-webkit-scrollbar-thumb { 
            background: linear-gradient(180deg, #00f3ff, #b026ff); 
            border-radius: 3px; 
        }

        /* Glass Effects */
        .glass {
            background: rgba(26, 26, 46, 0.7);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.08);
        }

        .glass-strong {
            background: rgba(18, 18, 26, 0.9);
            backdrop-filter: blur(30px);
            -webkit-backdrop-filter: blur(30px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        /* Neon Effects */
        .neon-text {
            text-shadow: 0 0 10px rgba(0, 243, 255, 0.8),
                         0 0 20px rgba(0, 243, 255, 0.4);
        }

        .neon-border {
            box-shadow: 0 0 20px rgba(0, 243, 255, 0.3),
                        inset 0 0 20px rgba(0, 243, 255, 0.1);
        }

        .neon-ring {
            background: linear-gradient(45deg, #00f3ff, #ff00ff, #b026ff, #00f3ff);
            background-size: 400% 400%;
            animation: gradientX 3s ease infinite;
            padding: 3px;
            border-radius: 50%;
        }

        .neon-ring-story {
            background: linear-gradient(45deg, #ff00ff, #ff9900, #ff00ff);
            background-size: 400% 400%;
            animation: gradientX 3s ease infinite;
            padding: 3px;
            border-radius: 50%;
        }

        .neon-ring-viewed {
            background: #333;
            padding: 3px;
            border-radius: 50%;
        }

        /* Gradients */
        .gradient-text {
            background: linear-gradient(135deg, #00f3ff 0%, #b026ff 50%, #ff00ff 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            background-size: 200% 200%;
            animation: gradientX 5s ease infinite;
        }

        /* Buttons */
        .btn-neon {
            background: linear-gradient(135deg, #00f3ff 0%, #b026ff 100%);
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .btn-neon:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px -10px rgba(0, 243, 255, 0.5);
        }

        /* Hide scrollbar for stories */
        .no-scrollbar::-webkit-scrollbar { display: none; }
        .no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }

        /* Instagram-style bottom nav */
        .bottom-nav-item {
            position: relative;
        }
        
        .bottom-nav-item::after {
            content: '';
            position: absolute;
            bottom: -5px;
            left: 50%;
            transform: translateX(-50%) scale(0);
            width: 4px;
            height: 4px;
            background: #00f3ff;
            border-radius: 50%;
            transition: transform 0.3s ease;
            box-shadow: 0 0 10px #00f3ff;
        }
        
        .bottom-nav-item.active::after {
            transform: translateX(-50%) scale(1);
        }

        /* Post hover overlay */
        .post-overlay {
            background: rgba(0, 0, 0, 0.7);
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .post-item:hover .post-overlay {
            opacity: 1;
        }

        /* Notification badge pulse */
        .notification-badge {
            animation: pulse 2s infinite;
        }

        /* Input glow */
        .input-glow:focus {
            outline: none;
            border-color: #00f3ff;
            box-shadow: 0 0 0 3px rgba(0, 243, 255, 0.1),
                        0 0 20px rgba(0, 243, 255, 0.2);
        }

        /* Modal backdrop */
        .modal-backdrop {
            background: rgba(0, 0, 0, 0.8);
            backdrop-filter: blur(10px);
        }

        /* Message Bubble */
        .message-bubble {
            position: relative;
            max-width: 70%;
            padding: 12px 16px;
            border-radius: 20px;
            word-wrap: break-word;
        }

        .message-sent {
            background: linear-gradient(135deg, #00f3ff 0%, #b026ff 100%);
            border-bottom-right-radius: 4px;
            margin-left: auto;
        }

        .message-received {
            background: rgba(255, 255, 255, 0.1);
            border-bottom-left-radius: 4px;
        }

        /* Hide scrollbar for stories */
        .scrollbar-hidden::-webkit-scrollbar { display: none; }
        .scrollbar-hidden { -ms-overflow-style: none; scrollbar-width: none; }

    </style>
</head>
<body class="antialiased">

    <!-- MAIN APP -->
    <div id="mainApp" class="min-h-screen pb-20 lg:pb-0 lg:grid lg:grid-cols-[280px_1fr_350px]">
        
        <!-- LEFT SIDEBAR (Navigation) -->
        <aside class="hidden lg:flex flex-col h-screen sticky top-0 border-r border-white/10 bg-dark-900 z-40">
            <div class="p-6 cursor-pointer" onclick="window.location.href='${pageContext.request.contextPath}/'">
                <div class="flex items-center gap-3 mb-8">
                    <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-cyan-400 via-purple-500 to-pink-500 flex items-center justify-center">
                        <i class="fas fa-bolt text-white"></i>
                    </div>
                    <span class="text-2xl font-display font-bold gradient-text">CDL BLOG</span>
                </div>

                <nav class="space-y-2">
                    <a href="${pageContext.request.contextPath}/" class="nav-item w-full flex items-center gap-4 px-4 py-3 rounded-xl hover:text-white hover:bg-white/5 transition-all text-white bg-white/10">
                        <i class="fas fa-home text-xl w-8"></i>
                        <span class="font-medium"><fmt:message key="nav.accueil" bundle="${msg}"/></span>
                    </a>
                    <c:if test="${not empty sessionScope.membre}">
                        <a href="${pageContext.request.contextPath}/messages" class="nav-item w-full flex items-center gap-4 px-4 py-3 rounded-xl text-gray-400 hover:text-white hover:bg-white/5 transition-all relative">
                            <i class="fas fa-paper-plane text-xl w-8"></i>
                            <span class="font-medium"><fmt:message key="nav.messages" bundle="${msg}"/></span>
                        </a>
                        <a href="${pageContext.request.contextPath}/notifications" class="nav-item w-full flex items-center gap-4 px-4 py-3 rounded-xl text-gray-400 hover:text-white hover:bg-white/5 transition-all relative">
                            <i class="fas fa-heart text-xl w-8"></i>
                            <span class="font-medium"><fmt:message key="nav.notifications" bundle="${msg}"/></span>
                        </a>
                        <a href="${pageContext.request.contextPath}/articles/nouveau" class="nav-item w-full flex items-center gap-4 px-4 py-3 rounded-xl text-gray-400 hover:text-white hover:bg-white/5 transition-all">
                            <i class="fas fa-plus-square text-xl w-8"></i>
                            <span class="font-medium"><fmt:message key="nav.creer" bundle="${msg}"/></span>
                        </a>
                        <a href="${pageContext.request.contextPath}/collection" class="nav-item w-full flex items-center gap-4 px-4 py-3 rounded-xl text-gray-400 hover:text-white hover:bg-white/5 transition-all">
                            <i class="fas fa-bookmark text-xl w-8"></i>
                            <span class="font-medium"><fmt:message key="nav.collection" bundle="${msg}"/></span>
                        </a>
                    </c:if>
                    <c:if test="${empty sessionScope.membre}">
                        <a href="${pageContext.request.contextPath}/connexion" class="nav-item w-full flex items-center gap-4 px-4 py-3 rounded-xl text-gray-400 hover:text-white hover:bg-white/5 transition-all">
                            <i class="fas fa-sign-in-alt text-xl w-8"></i>
                            <span class="font-medium"><fmt:message key="nav.connexion" bundle="${msg}"/></span>
                        </a>
                    </c:if>
                </nav>
            </div>

            <div class="mt-auto p-6 border-t border-white/10">
                <c:if test="${not empty sessionScope.membre}">
                    <a href="${pageContext.request.contextPath}/deconnexion" class="w-full flex items-center gap-4 px-4 py-3 rounded-xl text-gray-400 hover:text-red-400 hover:bg-white/5 transition-all">
                        <i class="fas fa-sign-out-alt text-xl w-8"></i>
                        <span class="font-medium"><fmt:message key="nav.deconnexion" bundle="${msg}"/></span>
                    </a>
                </c:if>
            </div>
        </aside>

        <!-- MAIN CONTENT AREA starts here -->
        <main class="min-h-screen">
            <!-- PREMIUM TOP BAR -->
            <header class="sticky top-0 z-40 glass border-b border-white/10 px-4 py-3 flex items-center justify-between backdrop-blur-xl">
                <div class="flex items-center gap-3 lg:hidden">
                    <div class="w-8 h-8 rounded-xl bg-gradient-to-br from-cyan-400 via-purple-500 to-pink-500 flex items-center justify-center">
                        <i class="fas fa-bolt text-white text-sm"></i>
                    </div>
                    <span class="text-xl font-display font-bold gradient-text">CDL BLOG</span>
                </div>
                <h1 class="hidden lg:block text-xl font-bold text-white">${pageTitle}</h1>

                <div class="flex items-center gap-4 ml-auto">

                    <c:if test="${not empty sessionScope.membre}">
                        <a href="${pageContext.request.contextPath}/articles/nouveau" class="hidden md:flex items-center gap-2 btn-neon px-4 py-2 rounded-full text-sm font-medium text-white transition-transform hover:scale-105">
                            <i class="fas fa-plus"></i> <span class="hidden lg:inline"><fmt:message key="nav.creer" bundle="${msg}"/></span>
                        </a>
                        <a href="${pageContext.request.contextPath}/notifications" class="relative text-gray-400 hover:text-white transition-colors p-2">
                            <i class="fas fa-bell text-xl"></i>
                            <span class="absolute top-1 right-1 flex h-3 w-3">
                                <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-neon-pink opacity-75"></span>
                                <span class="relative inline-flex rounded-full h-3 w-3 bg-neon-pink border-2 border-dark-900"></span>
                            </span>
                        </a>
                        <a href="${pageContext.request.contextPath}/profil" class="block ml-2 hover:scale-110 transition-transform">
                            <c:if test="${empty sessionScope.membre.avatar}">
                                <div class="w-9 h-9 rounded-full bg-gradient-to-br from-cyan-400 to-purple-500 flex items-center justify-center text-xs font-bold text-white uppercase neon-ring p-0.5 shadow-lg shadow-cyan-500/20">
                                    <div class="w-full h-full bg-dark-800 rounded-full flex items-center justify-center">
                                        ${sessionScope.membre.prenom.charAt(0)}${sessionScope.membre.nom.charAt(0)}
                                    </div>
                                </div>
                            </c:if>
                            <c:if test="${not empty sessionScope.membre.avatar}">
                                <img src="${sessionScope.membre.avatar}" class="w-9 h-9 rounded-full bg-gradient-to-br from-cyan-400 to-purple-500 p-0.5 object-cover shadow-lg shadow-cyan-500/20" alt="Avatar">
                            </c:if>
                        </a>
                    </c:if>
                    <c:if test="${empty sessionScope.membre}">
                        <a href="${pageContext.request.contextPath}/connexion" class="btn-neon px-5 py-2 rounded-full text-sm font-medium text-white hover:scale-105 transition-transform"><fmt:message key="nav.connexion" bundle="${msg}"/></a>
                    </c:if>
                </div>
            </header>

