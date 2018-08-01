import { Injectable } from '@angular/core';
import { environment } from '../../../environments/environment';
import { HttpClient } from '@angular/common/http';
import { Observable } from '../../../../node_modules/rxjs/Observable';

@Injectable()
export class LocationService {
  private baseUrl: string = environment.apiHost + "/location/"

  constructor(private http: HttpClient) { }

  getLocale():Observable<string> {
    return this.http.get(this.baseUrl + "get_locale")
      .map(res => res['locale'] as string);
  }
}
