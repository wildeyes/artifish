import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { AuthService } from '../../../auth/services/auth.service';
import { AlertService } from '../../../shared/services/alert.service';
import { AuthError } from '../../../auth/models/auth-error';
import { UnauthorizedError } from '../../../auth/models/unauthorized-error';
import { TRANSLATE } from '../../../translation-marker';
import { Observable } from '../../../../../node_modules/rxjs/Observable';
import { OAuthAccessDenied, OAuthCanceled } from '../../../auth/models/oauth-errors';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {
  model: any = {};
  isLoading = false;
  loggingIn = false;
  returnUrl: string;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private authService: AuthService,
    private alertService: AlertService) { }

  ngOnInit() {
    // reset login status
    if (this.authService.isLoggedIn())
      this.router.navigate(['/']);

    // get return url from route parameters or default to '/'
    this.returnUrl = this.route.snapshot.queryParams['returnUrl'] || '/';
  }

  login() {
    this.loggingIn = true;
    this.authService.loginWithUserCredential(this.model)
      .subscribe(
        data => {
          if (!this.authService.currentUser.verified)
            this.router.navigate(['unverified']);
          else
            this.router.navigateByUrl(this.returnUrl);
        },
        (error: AuthError) => {
          this.loggingIn = false;
          if (error instanceof UnauthorizedError) {
            this.alertService.error(TRANSLATE("login.invalid_credentials"));
          } else throw error;
        });
  }

  loginWithGooglePopup() {
    this.isLoading = true;
    this.loginWithPopup(this.authService.loginWithGooglePopup())
  }

  loginWithGoogleRedirect() {
    this.authService.loginWithGoogleRedirect();
  }

  loginWithFacebookPopup() {
    this.isLoading = true;
    this.loginWithPopup(this.authService.loginWithFacebookPopup())
  }

  loginWithFacebookRedirect() {
    this.authService.loginWithFacebookRedirect();
  }

  private loginWithPopup(login$: Observable<void>) {
    login$.subscribe(
      () => {
        this.isLoading = false;
        let returnUrl = this.route.snapshot.queryParamMap.get('returnUrl');
        this.router.navigate([returnUrl || '/'])
      },
      error => {
        this.isLoading = false;
        if (error instanceof OAuthAccessDenied ||
          error instanceof OAuthCanceled) {
          this.alertService.error('You must grant permissions to this application in order to login');
        } else throw error
      }
    );
  }
}
