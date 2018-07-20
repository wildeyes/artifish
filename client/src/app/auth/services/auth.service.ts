import 'rxjs/add/observable/throw';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/switchMap';
import 'rxjs/add/operator/catch';

import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { JwtHelper, tokenNotExpired } from 'angular2-jwt';
import { Observable } from 'rxjs/Observable';

import { AuthError } from '../models/auth-error';
import { OAuthError } from '../models/oauth-errors';
import { UnauthorizedError } from '../models/unauthorized-error';
import { BaseAuthProvider } from './base-auth-provider';
import { FacebookAuthProvider } from './facebook-auth-provider';
import { GoogleAuthProvider } from './google-auth-provider';
import { environment } from '../../../environments/environment';

@Injectable()
export class AuthService {
  private apiAuthUrl = environment.apiHost + "/auth/";
  private googleAuth: GoogleAuthProvider = new GoogleAuthProvider();
  private facebookAuth: FacebookAuthProvider = new FacebookAuthProvider();

  constructor(private http: HttpClient) {
  }


  logout() {
    localStorage.removeItem('token');
  }

  isLoggedIn() {
    return tokenNotExpired();
  }

  refreshToken() {
    return this.http.get(this.apiAuthUrl + 'refresh_token')
      .map(this.setToken)
  }

  public get currentUser() {
    let token = localStorage.getItem('token');
    if (!token) return null;

    return new JwtHelper().decodeToken(token);
  }

  public get token(): string {
    return localStorage.getItem('token');
  }

  loginWithUserCredential(credentials: {email: string, password: string}): Observable<void> {
    return this.http.post(this.apiAuthUrl + 'login', credentials)
      .map(this.setToken)
      .catch(this.handleError)
  }

  loginWithGoogleRedirect() {
    this.googleAuth.loginWithRedirect();
  }

  loginWithGoogleCallback(callbackParams: { [key: string]: any }) {
    return this.loginWithCallback(callbackParams, this.googleAuth)
  }

  loginWithGooglePopup() {
    return this.googleAuth.getAuthCodeWithPopup()
      .switchMap(authCode => this.loginWithAuthCode(authCode, this.googleAuth))
  }

  loginWithFacebookRedirect() {
    this.facebookAuth.loginWithRedirect();
  }

  loginWithFacebookCallback(callbackParams: { [key: string]: any }) {
    return this.loginWithCallback(callbackParams, this.facebookAuth)
  }

  loginWithFacebookPopup() {
    return this.facebookAuth.getAuthCodeWithPopup()
      .switchMap(authCode => this.loginWithAuthCode(authCode, this.facebookAuth))
  }

  private loginWithCallback(callbackParams: { [key: string]: any }, provider: BaseAuthProvider): Observable<void> {
    let authorizationCode = null;
    try {
      authorizationCode = provider.getAuthCodeFromCallback(callbackParams)
    } catch (error) {
      return Observable.throw(error)
    }
    return this.loginWithAuthCode(authorizationCode, provider);
  }

  private loginWithAuthCode(authorizationCode: string, provider: BaseAuthProvider) {
    return this.http.post(this.apiAuthUrl + provider.providerName, { auth_code: authorizationCode, redirect_uri: provider.redirectUri })
      .map(response => {
        if (!response || !response['auth_token']) {
          throw new OAuthError("Server did not respond with auth_token parameter");
        }

        localStorage.setItem("token", response['auth_token']);
      });
  }

  private setToken(response: Object) {
    if (!response || !response['auth_token']) {
      throw new OAuthError("Server did not respond with auth_token parameter");
    }

    localStorage.setItem("token", response['auth_token']);
  }

  private handleError(response: HttpErrorResponse) {
    if (response.status === 401)
      return Observable.throw(new UnauthorizedError(response.error));

    return Observable.throw(new AuthError(response.error));
  }
}
