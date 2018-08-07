import 'rxjs/add/observable/throw';
import 'rxjs/add/operator/catch';

import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs/Observable';

import { AppError } from '../../shared/models/app-error';
import { environment } from '../../../environments/environment';

@Injectable()
export class ContactUsService {
  private baseUrl: string = environment.apiHost + "/contact_us/"

  constructor(private http: HttpClient) { }

  create(contactUs: any): Observable<any> {
    return this.http.post(this.baseUrl, contactUs)
      .catch(this.handleError);
  }

  private handleError(response: HttpErrorResponse) {
    return Observable.throw(new AppError(response.error));
  }
}
