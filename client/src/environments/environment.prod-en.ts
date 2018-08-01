import { environment as prodEnvironment } from './environment.prod';

export const environment = Object.assign(
  prodEnvironment, {
    defaultLanguage: "en",
    rtl: false
  }
);
