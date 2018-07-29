import 'rxjs/add/operator/catch';

import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs/Observable';

import { environment } from '../../../environments/environment';
import { PaymentProcessorError } from '../models/payment-errors';
import { AppError } from '../../shared/models/app-error';

@Injectable()
export class PaymentService {
  private paymentBaseUrl: string = environment.apiHost + "/payments/"
  constructor(private http: HttpClient) { }

  generatePaypalLink(params: {orderId: any, returnUrl: string, cancelReturnUrl: string}) {
    return this.http.post(this.paymentBaseUrl + 'generate_paypal_link', params)
      .catch(this.handleError);
  }

  createPaypalPayment(orderId: string, token: string, payerId: string) {
    return this.http.post(this.paymentBaseUrl + 'paypal_transactions', { orderId: orderId, token: token, payerId: payerId })
      .catch(this.handleError);
  }

  private handleError(response: HttpErrorResponse) {
    if (response.error.message == "payment_processor_general_error") {
      return Observable.throw(new PaymentProcessorError(response.error));
    }
    return Observable.throw(new AppError(response.error));
  }
}
