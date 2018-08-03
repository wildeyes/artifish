import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

import { AuthService } from '../../../auth/services/auth.service';
import { OrderService } from '../../../payment/services/order.service';
import { PaymentService } from '../../../payment/services/payment.service';
import { AppError } from '../../../shared/models/app-error';
import { CollectionItemService } from '../../services/collection-item.service';
import { CollectionService } from '../../services/collection.service';
import { environment } from '../../../../environments/environment';

@Component({
  selector: 'app-purchase',
  templateUrl: './purchase.component.html',
  styleUrls: ['./purchase.component.css']
})
export class PurchaseComponent implements OnInit {
  collection: any;
  collectionItems: any[];
  totalAmountCents: number = 0;
  currencyCode: string;
  isLoading: boolean = false;
  isLoadingPaypal: boolean = false;
  order: any = {};
  selectionPerItemMapping = new Object();

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
          for (let i = 0; i < items.length; i++) {
            const item = items[i];
            const firstPurchaseOption = item.purchaseOptions[0]
            this.selectionPerItemMapping[item.id] = {
              selectedMaterial: firstPurchaseOption,
              selectedPrice: firstPurchaseOption.prices[0],
              selectedSizeId: firstPurchaseOption.prices[0].sizeId
            };

          }
          this.sumTotalAmount();
          this.currencyCode = items[0].purchaseOptions[0].prices[0].currencyCode;
          this.isLoading = false;
        })
    });
  }

  saveOrder() {
    let orderItems = [];
    for (let i = 0; i < this.collectionItems.length; i++) {
      const collectionItem = this.collectionItems[i];
      const itemSelections = this.selectionPerItemMapping[collectionItem.id];
      const orderItem = {
        name: collectionItem.name,
        imageUrl: collectionItem.imageUrl,
        itemUrl: collectionItem.itemUrl,
        purchaseOptionId: itemSelections.selectedPrice.id,
      }
      orderItems.push(orderItem);
    }
    this.order.itemsAttributes = orderItems;
    this.orderService.create(this.order).subscribe(order => {
      this.generatePaypalLink(order.id);
    })
  }

  materialSelected(collectionItem, materialId) {
    for (let i = 0; i < collectionItem.purchaseOptions.length; i++) {
      const purchaseOption = collectionItem.purchaseOptions[i];
      if (purchaseOption.materialId == materialId) {
        this.selectionPerItemMapping[collectionItem.id].selectedMaterial = purchaseOption
        break;
      }
    }
    this.sizeSelected(collectionItem, this.selectionPerItemMapping[collectionItem.id].selectedPrice.sizeId);
    this.sumTotalAmount();
  }

  sizeSelected(collectionItem, sizeId) {
    let selectedMaterial = this.selectionPerItemMapping[collectionItem.id].selectedMaterial;
    if (!selectedMaterial)
      return;

    for (let i = 0; i < selectedMaterial.prices.length; i++) {
      const priceOption = selectedMaterial.prices[i];
      if (priceOption.sizeId == sizeId) {
        this.selectionPerItemMapping[collectionItem.id].selectedPrice = priceOption;
        break;
      }
    }
    this.sumTotalAmount();
  }

  private sumTotalAmount() {
    this.totalAmountCents = 0;
    for (const collectionItemId in this.selectionPerItemMapping) {
      if (this.selectionPerItemMapping.hasOwnProperty(collectionItemId)) {
        const itemSelections = this.selectionPerItemMapping[collectionItemId];
        this.totalAmountCents += itemSelections.selectedPrice.priceCents;
      }
    }
  }

  private generatePaypalLink(orderId) {
    this.isLoadingPaypal = true;
    let currentUrl = window.location.href;
    let amount = this.totalAmountCents / 100.0;
    let currencyCode = this.currencyCode;
    let params = {
      // amount: amount,
      orderId: orderId,
      returnUrl: window.location.origin + `${environment.siteVirtualDirectory}/callback/paypal?amount=${amount}&currency_code=${currencyCode}&order=${orderId}&returnUrl=${currentUrl}`,
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

}
