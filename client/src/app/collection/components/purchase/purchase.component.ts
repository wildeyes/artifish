import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

import { AuthService } from '../../../auth/services/auth.service';
import { OrderService } from '../../../payment/services/order.service';
import { PaymentService } from '../../../payment/services/payment.service';
import { AppError } from '../../../shared/models/app-error';
import { CollectionItemService } from '../../services/collection-item.service';
import { CollectionService } from '../../services/collection.service';

@Component({
  selector: 'app-purchase',
  templateUrl: './purchase.component.html',
  styleUrls: ['./purchase.component.css']
})
export class PurchaseComponent implements OnInit {
  collection: any;
  collectionItems: any[];
  totalAmount: number = 0;
  currencyCode: string;
  isLoading: boolean = false;
  isLoadingPaypal: boolean = false;
  order: any = {};

  constructor(
    private route: ActivatedRoute,
    private authService: AuthService,
    private collectionService: CollectionService,
    private collectionItemService: CollectionItemService,
    private orderService: OrderService,
    private paymentSerivce: PaymentService) { }

  ngOnInit() {
    this.order.firstName = this.authService.currentUser.first_name;
    this.order.lastName = this.authService.currentUser.last_name;

    let id = this.route.snapshot.paramMap.get('id');
    this.collectionService.get(id).subscribe(res => {
      this.collection = res;
      this.collectionItemService.getAll(this.collection.id)
        .subscribe(items => {
          this.collectionItems = items;
          this.sumTotalAmount();
          this.currencyCode = 'USD';
          if (this.collectionItems.length > 0) this.currencyCode = this.collectionItems[0].currencyCode
          this.isLoading = false;
        })
    });
  }

  saveOrder() {
    this.order.itemsAttributes = this.collectionItems;
    this.orderService.create(this.order).subscribe(order => {
      this.generatePaypalLink(order.id);
    })
  }

  generatePaypalLink(orderId) {
    this.isLoadingPaypal = true;
    let currentUrl = window.location.href;
    let amount = this.totalAmount / 100.0;
    let currencyCode = this.currencyCode;
    let params = {
      amount: amount,
      returnUrl: window.location.origin + `/callback/paypal?amount=${amount}&currency_code=${currencyCode}&order=${orderId}&returnUrl=${currentUrl}`,
      cancelReturnUrl: currentUrl
    }
    this.paymentSerivce.generatePaypalLink(params).subscribe(
      res => window.location.href = res['paypal_express_url'],
      (error: AppError) => {
        this.isLoadingPaypal = false;
        throw error;
      }
    )
  };

  private sumTotalAmount() {
    for (let i = 0; i < this.collectionItems.length; i++) {
      const collectionItem = this.collectionItems[i];
      this.totalAmount += collectionItem.priceCents;
    }
  }

}
