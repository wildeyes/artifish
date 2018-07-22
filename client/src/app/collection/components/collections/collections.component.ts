import { Component, OnInit } from '@angular/core';
import { CollectionService } from '../../services/collection.service';
import { AppError } from '../../../shared/models/app-error';
import { NotFoundError } from '../../../shared/models/not-found-error';
import { AlertService } from '../../../shared/services/alert.service';
import { TRANSLATE } from '../../../translation-marker';
import { templateJitUrl } from '../../../../../node_modules/@angular/compiler';

@Component({
  selector: 'app-collections',
  templateUrl: './collections.component.html',
  styleUrls: ['./collections.component.css']
})
export class CollectionsComponent implements OnInit {
  collections: any[];
  constructor(
    private alertService: AlertService,
    private collectionService: CollectionService) { }

  ngOnInit() {
    this.collectionService.getAll().subscribe(res => this.collections = res);
  }

  deleteCollection(collection) {
    let index = this.collections.indexOf(collection);
    if (index == -1) return;

    this.collections.splice(index, 1);
    this.collectionService.delete(collection.id).subscribe(
      null,
      (error: AppError) => {
        if (error instanceof NotFoundError) {
          // Do nothing
        } else {
          this.alertService.error(TRANSLATE("collection.failed_to_delete_collection"), false);
          this.collections.splice(index, 0, collection);
        }
      }
    );
  }

}
