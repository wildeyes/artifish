export class OAuthError {
  constructor(public errorDescription?: string, public oauthErrorParams?: any) { }
}

export class OAuthInvalidRequest extends OAuthError { }

export class OAuthUnauthorizedClient extends OAuthError { }

export class OAuthAccessDenied extends OAuthError { }

export class OAuthUnsupportedResponseType extends OAuthError { }

export class OAuthInvalidScope extends OAuthError { }

export class OAuthServerError extends OAuthError { }

export class OAuthTemporarilyUnavailable extends OAuthError { }

export class OAuthCanceled extends OAuthError { }