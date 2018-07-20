import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';

import { AuthService } from '../../../auth/services/auth.service';
import { AppError } from '../../../shared/models/app-error';
import { AlertService } from '../../../shared/services/alert.service';
import { TRANSLATE } from '../../../translation-marker';
import { IncorrectVerificationCodeError } from '../../models/verification-errors';
import { UserService } from '../../services/user.service';

@Component({
  selector: 'app-verify-user',
  templateUrl: './verify-user.component.html',
  styleUrls: ['./verify-user.component.css']
})
export class VerifyUserComponent implements OnInit {
  phoneNumber: string = '';
  verificationCode: string = '';
  isLoading: boolean = false;
  verificationSent: boolean = false;

  constructor(
    private router: Router,
    private route: ActivatedRoute,
    private alertService: AlertService,
    private authService: AuthService,
    private userService: UserService) { }

  ngOnInit() {
    this.isLoading = true;
    var verificationCodePayload = this.route.snapshot.queryParamMap.get("p");
    if (!verificationCodePayload) {
      this.router.navigate(['/']);
      return;
    }

    this.userService.verify(verificationCodePayload).subscribe(
      res => {
        this.alertService.success(TRANSLATE("verify.user_was_verified"), true);
        this.authService.logout();
        this.router.navigate(['login']);
      },
      (error: AppError) => {
        this.isLoading = false;
        if (error instanceof IncorrectVerificationCodeError) {
          this.alertService.error(TRANSLATE("verify.verification_code_is_incorrect"));
        } else throw error;
      }
    );
  }

  private navigate() {
    let returnUrl = this.route.snapshot.queryParams['returnUrl'];
    this.router.navigateByUrl(returnUrl || '/');
  }
}
