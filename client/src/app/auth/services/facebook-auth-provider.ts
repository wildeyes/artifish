import { Injectable } from '@angular/core';

import { environment } from '../../../environments/environment';
import { BaseAuthProvider } from './base-auth-provider';

@Injectable()
export class FacebookAuthProvider extends BaseAuthProvider {
  providerName: string = 'facebook'

  constructor() {
    super(environment['facebookAuth']);
  }
}