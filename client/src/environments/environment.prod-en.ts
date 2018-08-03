import { environment as prodEnvironment } from './environment.prod';

export const environment = Object.assign(
  prodEnvironment, {
    siteVirtualDirectory: "/artifish",
    defaultLanguage: "en",
    rtl: false
  }
);
