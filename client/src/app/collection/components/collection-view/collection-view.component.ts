import { Component, OnInit } from '@angular/core';
import { CollectionService } from '../../services/collection.service';
import { ActivatedRoute } from '@angular/router';
import { LinkedImageService } from '../../services/linked-image.service';
import { CollectionItemService } from '../../services/collection-item.service';

@Component({
  selector: 'app-collection-view',
  templateUrl: './collection-view.component.html',
  styleUrls: ['./collection-view.component.css']
})
export class CollectionViewComponent implements OnInit {
  collection: any;
  isLoading: boolean = true;
  searchLoading: boolean = false;
  linkedImages: any[];
  collectionItems: any[] = [];

  constructor(
    private route: ActivatedRoute,
    private collectionService: CollectionService,
    private collectionItemService: CollectionItemService,
    private linkedImageService: LinkedImageService) { }

  ngOnInit() {
    let id = this.route.snapshot.paramMap.get('id');
    this.collectionService.get(id).subscribe(res => {
      this.collection = res;
      this.collectionItemService.getAll(this.collection.id)
        .subscribe(items => {
          this.collectionItems = items;
          this.isLoading = false;
        })
    });
  }

  externalSearch(keywords: string) {
    this.searchLoading = true;
    this.linkedImageService.externalSearch(keywords).subscribe(res => {
      this.linkedImages = res;
      this.searchLoading = false;
    })
  }

  imageSelected(linkedImage) {
    linkedImage.selected = linkedImage.selected === undefined ? true : !linkedImage.selected
    if (linkedImage.selected) {
      this.collectionItemService.create(this.collection.id, linkedImage)
        .subscribe(res => {
          linkedImage.id = res.id;
          this.collectionItems.push(linkedImage);
        });
    } else {
      this.removeCollectionItemById(linkedImage);
    }
  }

  removeCollectionItemById(linkedImage) {
    let index = this.collectionItems.indexOf(linkedImage);
    if (index == -1) return;
    this.collectionItems.splice(index, 1);

    this.collectionItemService.delete(this.collection.id, linkedImage.id).subscribe();
  }
}
