import 'rxjs/add/observable/throw';
import 'rxjs/add/operator/catch';
import { Injectable } from '@angular/core';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { environment } from '../../../environments/environment';
import { Observable } from 'rxjs/Observable';
import { AppError } from '../../shared/models/app-error';

@Injectable()
export class PortfolioItemService {
  private baseUrl: string = environment.apiHost + "/portfolio_items/"

  constructor(private http: HttpClient) { }

  search(filters: {tags: any[], color: string}): Observable<any> {
    let tagsParam = this.buildTagParams(filters.tags);
    let params: any = {tags: tagsParam};
    if (filters.color) params.color = filters.color
    return this.http.get(this.baseUrl, {params: params})
      .catch(this.handleError);
  }

  private handleError(response: HttpErrorResponse) {
    return Observable.throw(new AppError(response.error));
  }

  private buildTagParams(tags: any[]): string {
    let tagsQuery = '';
    for (let i = 0; i < tags.length; i++) {
      const tagObj = tags[i];
      tagsQuery += tagObj.name.replace(' ', '_');
      tagsQuery += '+';
    }
    tagsQuery = tagsQuery.slice(0, -1); //remove the last + character
    return tagsQuery;
  }
}
