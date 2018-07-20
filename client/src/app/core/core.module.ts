import { NgModule } from '@angular/core';
import { RouterModule } from '@angular/router';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { CustomFormsModule } from 'ng2-validation';

import { AuthModule } from '../auth/auth.module';
import { AuthGuard } from '../auth/services/auth-guard.service';
import { SharedModule } from '../shared/shared.module';
import { HomeComponent } from './components/home/home.component';
import { LoginComponent } from './components/login/login.component';
import { NavbarComponent } from './components/navbar/navbar.component';
import { UserService } from './services/user.service';
import { VerifiedUserGuard } from './services/verified-user-guard.service';
import { SignUpComponent } from './components/sign-up/sign-up.component';
import { SignUpSuccessComponent } from './components/sign-up/sign-up-success.component';
import { VerifyUserComponent } from './components/verify-user/verify-user.component';
import { UnverifiedComponent } from './components/unverified/unverified.component';

@NgModule({
  imports: [
    SharedModule,
    AuthModule,
    CustomFormsModule,
    NgbModule.forRoot(),
    RouterModule.forChild([
      { path: '', component: HomeComponent },
      { path: 'login', component: LoginComponent },
      { path: 'signup', component: SignUpComponent },
      { path: 'signup/success', component: SignUpSuccessComponent },
      { path: 'verify', component: VerifyUserComponent },
      { path: 'unverified', component: UnverifiedComponent },
    ])
  ],
  declarations: [
    NavbarComponent,
    HomeComponent,
    LoginComponent,
    SignUpComponent,
    SignUpSuccessComponent,
    VerifyUserComponent,
    UnverifiedComponent
  ],
  providers: [
    UserService,
    VerifiedUserGuard
  ],
  exports: [
    NavbarComponent,
  ]
})
export class CoreModule { }
