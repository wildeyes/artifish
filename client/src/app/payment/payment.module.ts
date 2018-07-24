import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { RouterModule } from '@angular/router';
import { CustomFormsModule } from 'ng2-validation';

import { AuthModule } from '../auth/auth.module';
import { AuthGuard } from '../auth/services/auth-guard.service';
import { CoreModule } from '../core/core.module';
import { VerifiedUserGuard } from '../core/services/verified-user-guard.service';
import { SharedModule } from '../shared/shared.module';
import { PaypalCallbackComponent } from './components/paypal-callback/paypal-callback.component';
import { PaymentService } from './services/payment.service';
import { PaymentConfirmationComponent } from './components/payment-confirmation/payment-confirmation.component';
import { OrderService } from './services/order.service';

@NgModule({
  imports: [
    CommonModule,
    SharedModule,
    CoreModule,
    AuthModule,
    CustomFormsModule,
    RouterModule.forChild([
      { path: 'purchase/success', component: PaymentConfirmationComponent, canActivate: [AuthGuard, VerifiedUserGuard] },
      { path: 'callback/paypal', component: PaypalCallbackComponent, canActivate: [AuthGuard, VerifiedUserGuard] },
    ])
  ],
  declarations: [
    PaymentConfirmationComponent,
    PaypalCallbackComponent,
  ],
  providers: [
    PaymentService,
    OrderService,
  ]
})
export class PaymentModule { }
