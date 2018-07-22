import 'rxjs/add/operator/catch';
import { Injectable } from '@angular/core';
import { environment } from '../../../environments/environment';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import { NotFoundError } from '../../shared/models/not-found-error';
import { AppError } from '../../shared/models/app-error';
import { ValidationError } from '../../shared/models/validation-error';

@Injectable()
export class CollectionService {
  private baseUrl: string = environment.apiHost + "/collections/"

  constructor(private http: HttpClient) { }

  getAll(): Observable<any> {
    return this.http.get(this.baseUrl)
      .catch(this.handleError);
  }

  get(id): Observable<any> {
    return this.http.get(this.baseUrl + id)
      .catch(this.handleError);
  }

  create(collection): Observable<any> {
    return this.http.post(this.baseUrl, collection)
      .catch(this.handleError);
  }

  update(collection): Observable<any> {
    return this.http.patch(this.baseUrl + collection.id, collection)
      .catch(this.handleError);
  }

  delete(id) {
    return this.http.delete(this.baseUrl + id)
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
