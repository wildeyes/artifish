export const environment = {
  production: true,
  apiHost: "https://artifish.herokuapp.com/",
  defaultLanguage: "en",
  googleAuth: {
    clientId: "955755213129-fqsdd6v2jb7fpdffkm5egf2e1ggadqr8.apps.googleusercontent.com",
    authorizationUri: "https://accounts.google.com/o/oauth2/v2/auth",
    redirectUri: "https://artifish.github.io/artifish/auth/google",
    scopes: ['email', 'profile']
  },
  facebookAuth: {
    clientId: "252902028645479",
    authorizationUri: "https://www.facebook.com/v3.0/dialog/oauth",
    redirectUri: "https://artifish.github.io/artifish/auth/facebook",
    scopes: ['email', 'public_profile']
  }
};
