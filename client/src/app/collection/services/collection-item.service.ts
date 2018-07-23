import { Injectable } from '@angular/core';
import { Observable } from 'rxjs/Observable';
import { environment } from '../../../environments/environment';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { NotFoundError } from '../../shared/models/not-found-error';
import { ValidationError } from '../../shared/models/validation-error';
import { AppError } from '../../shared/models/app-error';

@Injectable()
export class CollectionItemService {
  private baseUrl: string = environment.apiHost + "/collections/{0}/items/"

  constructor(private http: HttpClient) { }

  getAll(collectionId): Observable<any> {
    return this.http.get(this.baseUrl.replace("{0}", collectionId))
      .catch(this.handleError);
  }

  get(collectionId, id): Observable<any> {
    return this.http.get(this.baseUrl.replace("{0}", collectionId) + id)
      .catch(this.handleError);
  }

  create(collectionId, collectionItem): Observable<any> {
    return this.http.post(this.baseUrl.replace("{0}", collectionId), collectionItem)
      .catch(this.handleError);
  }

  delete(collectionId, id) {
    return this.http.delete(this.baseUrl.replace("{0}", collectionId) + id)
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
