// Navigation functionality
document.addEventListener('DOMContentLoaded', function() {
    const navLinks = document.querySelectorAll('.nav-link');
    const contentSections = document.querySelectorAll('.content-section');
    
    // Handle navigation clicks
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            
            // Remove active class from all links
            navLinks.forEach(navLink => navLink.classList.remove('active'));
            
            // Add active class to clicked link
            this.classList.add('active');
            
            // Hide all content sections
            contentSections.forEach(section => section.classList.remove('active'));
            
            // Show target section
            const targetId = this.getAttribute('href').substring(1);
            const targetSection = document.getElementById(targetId);
            if (targetSection) {
                targetSection.classList.add('active');
            }
        });
    });
    
    // Smooth scrolling for anchor links
    const anchorLinks = document.querySelectorAll('a[href^="#"]');
    anchorLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            const targetId = this.getAttribute('href').substring(1);
            const targetElement = document.getElementById(targetId);
            
            if (targetElement) {
                e.preventDefault();
                targetElement.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
    
    // Add loading animation for external links
    const externalLinks = document.querySelectorAll('a[target="_blank"]');
    externalLinks.forEach(link => {
        link.addEventListener('click', function() {
            this.style.opacity = '0.7';
            this.innerHTML += ' <span>↗</span>';
            
            setTimeout(() => {
                this.style.opacity = '1';
            }, 1000);
        });
    });
    
    // Simple analytics tracking for educational purposes
    function trackPageView(section) {
        console.log(`Page view: ${section} - ${new Date().toISOString()}`);
        
        // In a real deployment, you might send this to an analytics service
        // Analytics service integration would go here
    }
    
    // Track initial page load
    trackPageView('home');
    
    // Track section changes
    navLinks.forEach(link => {
        link.addEventListener('click', function() {
            const section = this.getAttribute('href').substring(1);
            trackPageView(section);
        });
    });
    
    // Add interactive elements for learning modules
    const learningModules = document.querySelectorAll('.learning-module');
    learningModules.forEach(module => {
        module.addEventListener('click', function() {
            this.classList.toggle('expanded');
        });
    });
    
    // Feature card interactions
    const featureCards = document.querySelectorAll('.feature-card');
    featureCards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-5px) scale(1.02)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
        });
    });
});

// Service worker registration for PWA capabilities (optional)
if ('serviceWorker' in navigator) {
    window.addEventListener('load', function() {
        navigator.serviceWorker.register('/sw.js')
            .then(function(registration) {
                console.log('ServiceWorker registration successful');
            }, function(err) {
                console.log('ServiceWorker registration failed: ', err);
            });
    });
}

// Error handling
window.addEventListener('error', function(e) {
    console.error('Application error:', e.error);
    
    // In production, you might want to send errors to a logging service
    // Error logging service integration would go here
});

// Responsive navigation toggle for mobile
function createMobileMenu() {
    const nav = document.querySelector('nav');
    const navUl = nav.querySelector('ul');
    
    // Create mobile menu button
    const mobileButton = document.createElement('button');
    mobileButton.innerHTML = '☰';
    mobileButton.className = 'mobile-menu-btn';
    mobileButton.style.cssText = `
        display: none;
        background: none;
        border: none;
        font-size: 1.5rem;
        cursor: pointer;
        padding: 0.5rem;
        position: absolute;
        right: 2rem;
        top: 50%;
        transform: translateY(-50%);
    `;
    
    nav.style.position = 'relative';
    nav.appendChild(mobileButton);
    
    // Mobile menu toggle functionality
    mobileButton.addEventListener('click', function() {
        navUl.classList.toggle('mobile-open');
    });
    
    // Add mobile styles
    const mobileStyles = document.createElement('style');
    mobileStyles.textContent = `
        @media (max-width: 768px) {
            .mobile-menu-btn {
                display: block !important;
            }
            
            nav ul {
                display: none;
                flex-direction: column;
                position: absolute;
                top: 100%;
                left: 0;
                right: 0;
                background: white;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                padding: 1rem 0;
            }
            
            nav ul.mobile-open {
                display: flex;
            }
        }
    `;
    document.head.appendChild(mobileStyles);
}

// Initialize mobile menu
createMobileMenu();