import 'rxjs/add/observable/fromPromise';

import { Injectable } from '@angular/core';
import * as ClientOAuth2 from 'client-oauth2';
import { Observable } from 'rxjs/Observable';
import { OAuthAccessDenied, OAuthInvalidRequest, OAuthUnauthorizedClient, OAuthUnsupportedResponseType, OAuthInvalidScope, OAuthServerError, OAuthTemporarilyUnavailable, OAuthError, OAuthCanceled } from '../models/oauth-errors';

@Injectable()
export abstract class BaseAuthProvider {
  private clientAuth: ClientOAuth2;
  private _redirectUri: string;

  constructor(authConfig: ClientOAuth2.Options) {
    if (authConfig) {
      this.clientAuth = new ClientOAuth2(authConfig);
      this._redirectUri = authConfig.redirectUri;
    }
  }

  loginWithRedirect() {
    let uri = this.clientAuth.code.getUri();
    window.location.replace(uri);
  }

  getAuthCodeWithPopup(): Observable<string> {
    let uri = this.clientAuth.code.getUri();
    return Observable.fromPromise(this.openInPopup(uri, [this.codeParamName, this.errorParamName]))
      .map(callbackParams => {
        return this.getAuthCodeFromCallback(callbackParams)
      })
  }

  getAuthCodeFromCallback(callbackParams: { [key: string]: any }) {
    if (callbackParams[this.errorParamName]) {
      // throw this.errorMapping(callbackParams)
      throw new OAuthAccessDenied("Server did not respond with auth_token parameter");
    }
    return callbackParams[this.codeParamName]
  }

  abstract get providerName(): string

  public get redirectUri(): string {
    return this._redirectUri
  }

  private get codeParamName(): string {
    return 'code';
  }

  private get errorParamName(): string {
    return 'error';
  }

  private get errorDescriptionParamName(): string {
    return 'error_description';
  }

  private errorMapping(errorParams) {
    if (errorParams[this.errorParamName] == 'invalid_request')
      return new OAuthInvalidRequest(errorParams[this.errorDescriptionParamName], errorParams)
    if (errorParams[this.errorParamName] == 'unauthorized_client')
      return new OAuthUnauthorizedClient(errorParams[this.errorDescriptionParamName], errorParams)
    if (errorParams[this.errorParamName] == 'access_denied')
      return new OAuthAccessDenied(errorParams[this.errorDescriptionParamName], errorParams)
    if (errorParams[this.errorParamName] == 'unsupported_response_type')
      return new OAuthUnsupportedResponseType(errorParams[this.errorDescriptionParamName], errorParams)
    if (errorParams[this.errorParamName] == 'invalid_scope')
      return new OAuthInvalidScope(errorParams[this.errorDescriptionParamName], errorParams)
    if (errorParams[this.errorParamName] == 'server_error')
      return new OAuthServerError(errorParams[this.errorDescriptionParamName], errorParams)
    if (errorParams[this.errorParamName] == 'temporarily_unavailable')
      return new OAuthTemporarilyUnavailable(errorParams[this.errorDescriptionParamName], errorParams)

    return new OAuthError(errorParams[this.errorDescriptionParamName], errorParams)
  }


  private openInPopup(uri, paramsToExtract: string[]) {
    let self = this
    let promise = new Promise((resolve, reject) => {
      let win = this.popupCenter(uri, 'Authenticating', 800, 600)
      var pollTimer = window.setInterval(function () {
        try {
          if (!win.parent) {
            window.clearInterval(pollTimer);
            return reject(new OAuthCanceled());
          }
          if (win.document.URL.indexOf(self._redirectUri) != -1) {
            window.clearInterval(pollTimer);
            var url = win.document.URL;
            let queryParams = self.queryStringToJSON(win.location.search);
            win.close();
            return resolve(queryParams);
          }
        } catch (e) {
        }
      }, 100);
    })
    return promise;
  }

  private popupCenter(url, title, w, h) {
    // Fixes dual-screen position                         Most browsers      Firefox
    var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : (screen as any).left;
    var dualScreenTop = window.screenTop != undefined ? window.screenTop : (screen as any).top;

    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

    var left = ((width / 2) - (w / 2)) + dualScreenLeft;
    var top = ((height / 2) - (h / 2)) + dualScreenTop;
    return window.open(url, title, 'scrollbars=yes, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
  }

  private queryStringToJSON(queryString: string) {
    var search = queryString.substring(1);
    return search ? JSON.parse('{"' + search.replace(/&/g, '","').replace(/=/g, '":"') + '"}',
      function (key, value) { return key === "" ? value : decodeURIComponent(value) }) : {}
  }

  private extractParams(url, name) {
    name = name.replace(/[[]/, "\[").replace(/[]]/, "\]");
    var regexS = "[\?&]" + name + "=([^&#]*)";
    var regex = new RegExp(regexS);
    var results = regex.exec(url);
    if (!results) return null;

    return results[1];
  }
}
