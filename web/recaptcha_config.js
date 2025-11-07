// Configure invisible reCAPTCHA for Firebase Phone Auth
window.recaptchaVerifier = null;

window.initRecaptcha = function() {
  if (!firebase || !firebase.auth) {
    console.error('Firebase not initialized');
    return;
  }

  try {
    window.recaptchaVerifier = new firebase.auth.RecaptchaVerifier('recaptcha-container', {
      'size': 'invisible',
      'callback': function(response) {
        // reCAPTCHA solved, allow phone auth to proceed
        console.log('reCAPTCHA verified');
      },
      'expired-callback': function() {
        // Response expired, user needs to re-verify
        console.log('reCAPTCHA expired');
      }
    });

    window.recaptchaVerifier.render().then(function(widgetId) {
      window.recaptchaWidgetId = widgetId;
      console.log('Invisible reCAPTCHA initialized');
    });
  } catch (error) {
    console.error('Error initializing reCAPTCHA:', error);
  }
};

// Clean up on page unload
window.addEventListener('beforeunload', function() {
  if (window.recaptchaVerifier) {
    window.recaptchaVerifier.clear();
  }
});
