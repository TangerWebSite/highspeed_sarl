# Intégration EmailJS pour Formulaire de Contact Statique

Ce document résume la procédure pour rendre le formulaire de contact fonctionnel via EmailJS sur un hébergement statique (GitHub Pages).

## 1. Création et Configuration du Compte EmailJS
1.  Créer un compte sur [emailjs.com](https://www.emailjs.com/).
2.  **Service** : Ajouter un nouveau service "Gmail" et connectez votre compte. **Notez le Service ID**.
3.  **Template** : Créer un nouveau modèle d'email.
    *   Utilisez les variables correspondant aux `name` de vos inputs HTML :
        *   `{{template-contactform-name}}`
        *   `{{template-contactform-email}}`
        *   `{{template-contactform-phone}}`
        *   `{{subject}}`
        *   `{{template-contactform-message}}`
    *   **Notez le Template ID**.

## 2. Intégration dans `Contact.html`

### A. Ajouter la librairie (dans le `<head>`)
```html
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/@emailjs/browser@3/dist/email.min.js"></script>
<script type="text/javascript">
   (function(){
      // Remplacer par votre Public Key (Compte > General)
      emailjs.init("VOTRE_PUBLIC_KEY");
   })();
</script>
```

### B. Ajouter le script d'envoi (avant la fermeture `</body>`)
```javascript
<script>
    window.onload = function() {
        document.getElementById('template-contactform').addEventListener('submit', function(event) {
            event.preventDefault();
            
            const btn = document.getElementById('template-contactform-submit');
            const originalText = btn.innerHTML;
            btn.innerHTML = 'Envoi en cours...';

            // Remplacer par vos IDs
            emailjs.sendForm('VOTRE_SERVICE_ID', 'VOTRE_TEMPLATE_ID', this)
                .then(function() {
                    console.log('SUCCESS!');
                    alert('Votre message a été envoyé avec succès !');
                    btn.innerHTML = originalText;
                    document.getElementById('template-contactform').reset();
                }, function(error) {
                    console.log('FAILED...', error);
                    alert('Erreur: ' + JSON.stringify(error));
                    btn.innerHTML = originalText;
                });
        });
    }
</script>
```

## 3. Nettoyage du Code HTML
*   Supprimer l'attribut `action="include/form.php"` de la balise `<form>`.
*   S'assurer que l'ID du formulaire correspond bien à `template-contactform`.
