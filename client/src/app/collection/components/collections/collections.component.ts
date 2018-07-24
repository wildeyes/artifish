import { Component, OnInit } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';

import { AppError } from '../../../shared/models/app-error';
import { NotFoundError } from '../../../shared/models/not-found-error';
import { AlertService } from '../../../shared/services/alert.service';
import { TRANSLATE } from '../../../translation-marker';
import { CollectionService } from '../../services/collection.service';

@Component({
  selector: 'app-collections',
  templateUrl: './collections.component.html',
  styleUrls: ['./collections.component.css']
})
export class CollectionsComponent implements OnInit {
  collections: any[];
  constructor(
    private alertService: AlertService,
    private translate: TranslateService,
    private collectionService: CollectionService) { }

  ngOnInit() {
    this.collectionService.getAll().subscribe(res => this.collections = res);
  }

  deleteCollection(collection) {
    this.translate.get(TRANSLATE("collection.delete_collection_alert")).subscribe(translation => {
      if (!confirm(translation.replace("{{collection}}", collection.name)))
        return;
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
    });
  }
}
