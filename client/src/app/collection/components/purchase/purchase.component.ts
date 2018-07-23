import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { CollectionService } from '../../services/collection.service';
import { CollectionItemService } from '../../services/collection-item.service';

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
  isLoading: boolean = true;

  constructor(
    private route: ActivatedRoute,
    private collectionService: CollectionService,
    private collectionItemService: CollectionItemService) { }

  ngOnInit() {
    let id = this.route.snapshot.paramMap.get('id');
    this.collectionService.get(id).subscribe(res => {
      this.collection = res;
      this.collectionItemService.getAll(this.collection.id)
        .subscribe(items => {
          this.collectionItems = items;
          this.sumTotalAmount();
          if (this.collectionItems.length > 0) this.currencyCode = this.collectionItems[0].currencyCode
          this.isLoading = false;
        })
    });
  }

  private sumTotalAmount() {
    for (let i = 0; i < this.collectionItems.length; i++) {
      const collectionItem = this.collectionItems[i];
      this.totalAmount += collectionItem.priceCents;
    }
  }

}
