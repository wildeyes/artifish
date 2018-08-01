import { environment as prodEnvironment } from './environment.prod';

export const environment = Object.assign(
  prodEnvironment, {
    defaultLanguage: "he",
    rtl: true
  }
);
