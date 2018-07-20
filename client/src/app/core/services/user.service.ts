import 'rxjs/add/operator/catch';

import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs/Observable';

import { environment } from '../../../environments/environment';
import { AppError } from '../../shared/models/app-error';
import { ValidationError } from '../../shared/models/validation-error';
import { IncorrectVerificationCodeError } from '../models/verification-errors';

@Injectable()
export class UserService {
  private baseUrl: string = environment.apiHost + "/users"

  constructor(private http: HttpClient) { }

  create(user): Observable<any> {
    return this.http.post(this.baseUrl, user)
      .catch(this.handleError);
  }

  verify(verificationCode: string) {
    let params = { p: verificationCode };
    return this.http.post(this.baseUrl + '/verify', params)
      .catch(this.handleError);
  }

  private handleError(response: HttpErrorResponse) {
    if (response.status == 422 && response.error.validations) {
      return Observable.throw(new ValidationError(response.error));
    }
    if (response.error.message == "incorrect_verification_code") {
      return Observable.throw(new IncorrectVerificationCodeError(response.error));
    }
    return Observable.throw(new AppError(response.error));
  }
}
