// The file contents for the current environment will overwrite these during build.
// The build system defaults to the dev environment which uses `environment.ts`, but if you do
// `ng build --env=prod` then `environment.prod.ts` will be used instead.
// The list of which env maps to which file can be found in `.angular-cli.json`.

export const environment = {
  production: false,
  apiHost: "http://localhost:3000",
  siteVirtualDirectory: "",
  defaultLanguage: "en",
  rtl: false,
  googleAuth: {
    clientId: "569091726571-bvso1l18162d0oukl39utgbbd7j1kjjm.apps.googleusercontent.com",
    authorizationUri: "https://accounts.google.com/o/oauth2/v2/auth",
    redirectUri: "http://localhost:4200/auth/google",
    scopes: ['email', 'profile']
  },
  facebookAuth: {
    clientId: "2157048681220034",
    authorizationUri: "https://www.facebook.com/v3.1/dialog/oauth",
    redirectUri: "http://localhost:4200/auth/facebook",
    scopes: ['email', 'public_profile']
  }
};
