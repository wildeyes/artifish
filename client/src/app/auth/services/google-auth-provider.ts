import { Injectable } from '@angular/core';

import { environment } from '../../../environments/environment';
import { BaseAuthProvider } from './base-auth-provider';

@Injectable()
export class GoogleAuthProvider extends BaseAuthProvider {
  providerName: string = 'google'
  
  constructor() {
    super(environment['googleAuth']);
  }
}