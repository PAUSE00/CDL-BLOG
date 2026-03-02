// Blog JEE - main.js

// ====================================
// CSRF Token Helper
// ====================================
function getCsrfToken() {
    const meta = document.querySelector('meta[name="csrf-token"]');
    if (meta) return meta.getAttribute('content');
    const hidden = document.querySelector('input[name="_csrf"]');
    if (hidden) return hidden.value;
    return '';
}

// ====================================
// Language Dropdown
// ====================================
document.addEventListener('click', function (e) {
    const selector = document.querySelector('.langue-selector');
    if (selector && !selector.contains(e.target)) {
        const dropdown = selector.querySelector('.langue-dropdown');
        if (dropdown) dropdown.style.display = '';
    }
});

// ====================================
// Auto-hide Alerts
// ====================================
document.querySelectorAll('.alert').forEach(function (alert) {
    setTimeout(function () {
        alert.style.opacity = '0';
        alert.style.transition = 'opacity .5s';
        setTimeout(() => alert.remove(), 500);
    }, 5000);
});

// ====================================
// Confirm Before Delete
// ====================================
document.querySelectorAll('form[data-confirm]').forEach(function (form) {
    form.addEventListener('submit', function (e) {
        if (!confirm(form.dataset.confirm)) e.preventDefault();
    });
});

// ====================================
// AJAX Like Toggle
// ====================================
document.querySelectorAll('.btn-like-ajax').forEach(function (btn) {
    btn.addEventListener('click', function (e) {
        e.preventDefault();
        const articleId = btn.dataset.articleId;
        const form = new FormData();
        form.append('articleId', articleId);
        form.append('_csrf', getCsrfToken());

        fetch(btn.dataset.action || (window.contextPath + '/like'), {
            method: 'POST',
            body: form
        }).then(response => {
            if (response.ok) {
                // Toggle UI
                const icon = btn.querySelector('i');
                const countSpan = btn.querySelector('.like-count');
                if (icon) {
                    icon.classList.toggle('fas');
                    icon.classList.toggle('far');
                }
                if (countSpan) {
                    let count = parseInt(countSpan.textContent) || 0;
                    if (icon && icon.classList.contains('fas')) {
                        countSpan.textContent = count + 1;
                    } else {
                        countSpan.textContent = Math.max(0, count - 1);
                    }
                }
            }
        }).catch(err => console.error('Erreur like:', err));
    });
});

// ====================================
// AJAX Follow Toggle
// ====================================
document.querySelectorAll('.btn-follow-ajax').forEach(function (btn) {
    btn.addEventListener('click', function (e) {
        e.preventDefault();
        const followingId = btn.dataset.followingId;
        const form = new FormData();
        form.append('followingId', followingId);
        form.append('_csrf', getCsrfToken());

        fetch(window.contextPath + '/follow', {
            method: 'POST',
            body: form
        }).then(response => {
            if (response.ok) {
                // Toggle button text
                if (btn.textContent.trim().includes('Suivre')) {
                    btn.innerHTML = '<i class="fas fa-user-check"></i> Suivi';
                    btn.classList.add('active');
                } else {
                    btn.innerHTML = '<i class="fas fa-user-plus"></i> Suivre';
                    btn.classList.remove('active');
                }
            }
        }).catch(err => console.error('Erreur follow:', err));
    });
});

// ====================================
// AJAX Save/Bookmark Toggle
// ====================================
document.querySelectorAll('.btn-save-ajax').forEach(function (btn) {
    btn.addEventListener('click', function (e) {
        e.preventDefault();
        const articleId = btn.dataset.articleId;
        const isSaved = btn.classList.contains('saved');
        const action = isSaved ? '/collection/retirer' : '/collection/sauvegarder';

        const form = new FormData();
        form.append('articleId', articleId);
        form.append('_csrf', getCsrfToken());

        fetch(window.contextPath + action, {
            method: 'POST',
            body: form
        }).then(response => {
            if (response.ok) {
                const icon = btn.querySelector('i');
                if (icon) {
                    icon.classList.toggle('fas');
                    icon.classList.toggle('far');
                }
                btn.classList.toggle('saved');
            }
        }).catch(err => console.error('Erreur sauvegarde:', err));
    });
});

// ====================================
// Image Preview Before Upload
// ====================================
document.querySelectorAll('input[type="file"][accept*="image"]').forEach(function (input) {
    input.addEventListener('change', function (e) {
        const file = e.target.files[0];
        if (!file) return;

        // Validate file type
        const allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'image/svg+xml'];
        if (!allowedTypes.includes(file.type)) {
            alert('Type de fichier non autorisé. Utilisez JPG, PNG, GIF, ou WebP.');
            input.value = '';
            return;
        }

        // Validate file size (10MB max)
        if (file.size > 10 * 1024 * 1024) {
            alert('Le fichier est trop volumineux (max 10 Mo).');
            input.value = '';
            return;
        }

        // Show preview
        let preview = input.parentElement.querySelector('.image-preview');
        if (!preview) {
            preview = document.createElement('div');
            preview.className = 'image-preview';
            preview.style.cssText = 'margin-top:10px;max-width:300px;border-radius:8px;overflow:hidden;';
            input.parentElement.appendChild(preview);
        }

        const reader = new FileReader();
        reader.onload = function (ev) {
            preview.innerHTML = '<img src="' + ev.target.result + '" style="width:100%;height:auto;display:block;" alt="Aperçu">';
        };
        reader.readAsDataURL(file);
    });
});

// ====================================
// Client-side Form Validation
// ====================================
document.querySelectorAll('form[data-validate]').forEach(function (form) {
    form.addEventListener('submit', function (e) {
        let valid = true;
        form.querySelectorAll('[required]').forEach(function (field) {
            const errorEl = field.parentElement.querySelector('.field-error');
            if (!field.value || field.value.trim() === '') {
                valid = false;
                field.style.borderColor = '#ef4444';
                if (errorEl) errorEl.textContent = 'Ce champ est obligatoire';
            } else {
                field.style.borderColor = '';
                if (errorEl) errorEl.textContent = '';
            }
        });

        // Password match validation
        const mdp = form.querySelector('[name="mot_de_passe"]');
        const mdpConfirm = form.querySelector('[name="mdp_confirm"]');
        if (mdp && mdpConfirm && mdp.value !== mdpConfirm.value) {
            valid = false;
            mdpConfirm.style.borderColor = '#ef4444';
            const errorEl = mdpConfirm.parentElement.querySelector('.field-error');
            if (errorEl) errorEl.textContent = 'Les mots de passe ne correspondent pas';
        }

        if (!valid) {
            e.preventDefault();
        }
    });
});

// ====================================
// Smooth Scroll for Anchor Links
// ====================================
document.querySelectorAll('a[href^="#"]').forEach(function (anchor) {
    anchor.addEventListener('click', function (e) {
        const targetId = this.getAttribute('href').substring(1);
        const target = document.getElementById(targetId);
        if (target) {
            e.preventDefault();
            target.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    });
});

// ====================================
// Set context path global variable
// ====================================
window.contextPath = document.querySelector('meta[name="context-path"]')
    ? document.querySelector('meta[name="context-path"]').getAttribute('content')
    : '';

console.log('Blog JEE chargé');
