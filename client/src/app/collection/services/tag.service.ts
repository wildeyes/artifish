import 'rxjs/add/observable/throw';
import 'rxjs/add/operator/catch';

import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs/Observable';

import { environment } from '../../../environments/environment';
import { AppError } from '../../shared/models/app-error';

@Injectable()
export class TagService {
  private baseUrl: string = environment.apiHost + "/tags/"

  constructor(private http: HttpClient) { }

  getAll(): Observable<any> {
    return this.http.get(this.baseUrl)
      .catch(this.handleError);
  }

  private handleError(response: HttpErrorResponse) {
    return Observable.throw(new AppError(response.error));
  }
}
