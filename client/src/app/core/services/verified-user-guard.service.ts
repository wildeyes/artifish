import { Injectable } from '@angular/core';
import { ActivatedRouteSnapshot, Router, RouterStateSnapshot } from '@angular/router';

import { AuthService } from '../../auth/services/auth.service';

@Injectable()
export class VerifiedUserGuard {
  constructor(
    private authService: AuthService,
    private router: Router) { }

  canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot) {
    if (this.authService.currentUser.verified) return true;

    this.router.navigate(['/unverified'])
    return false;
  }
}
