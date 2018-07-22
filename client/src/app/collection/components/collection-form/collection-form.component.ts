import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

import { CollectionService } from '../../services/collection.service';

@Component({
  selector: 'app-collection-form',
  templateUrl: './collection-form.component.html',
  styleUrls: ['./collection-form.component.css']
})
export class CollectionFormComponent implements OnInit {
  collection: any = {};
  previewImageSrc: string;
  constructor(
    private collectionService: CollectionService,
    private router: Router) { }

  ngOnInit() {
  }

  readURL(event): void {
    if (event.target.files && event.target.files[0]) {
      const file = event.target.files[0];

      const reader = new FileReader();
      reader.onload = e => {
        this.previewImageSrc = reader.result;
        this.collection.workspaceImageContents = reader.result;
      };

      reader.readAsDataURL(file);
    }
  }

  createCollection() {
    this.collectionService.create(this.collection).subscribe(
      res => this.router.navigate(['collections']));
  }


}
