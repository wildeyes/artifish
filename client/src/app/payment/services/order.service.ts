import { Injectable } from '@angular/core';
import { Observable } from 'rxjs/Observable';
import { environment } from '../../../environments/environment';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { NotFoundError } from '../../shared/models/not-found-error';
import { ValidationError } from '../../shared/models/validation-error';
import { AppError } from '../../shared/models/app-error';

@Injectable()
export class OrderService {
  private baseUrl: string = environment.apiHost + "/orders/"

  constructor(private http: HttpClient) { }

  create(order): Observable<any> {
    return this.http.post(this.baseUrl, order)
      .catch(this.handleError);
  }

  private handleError(response: HttpErrorResponse) {
    if (response.status == 404) {
      return Observable.throw(new NotFoundError(response.error));
    } else if (response.status == 422) {
      return Observable.throw(new ValidationError(response.error));
    }
    return Observable.throw(new AppError(response.error));
  }
}
