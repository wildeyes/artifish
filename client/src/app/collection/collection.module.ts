import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { RouterModule } from '@angular/router';
import { AuthModule } from 'angular2-jwt';

import { AuthGuard } from '../auth/services/auth-guard.service';
import { VerifiedUserGuard } from '../core/services/verified-user-guard.service';
import { SharedModule } from '../shared/shared.module';
import { CollectionViewComponent } from './components/collection-view/collection-view.component';
import { CollectionsComponent } from './components/collections/collections.component';
import { PurchaseComponent } from './components/purchase/purchase.component';
import { CollectionItemService } from './services/collection-item.service';
import { SaveCollectionDataGuard } from './services/collection-view-can-deactivate.service';
import { CollectionService } from './services/collection.service';
import { LinkedImageService } from './services/linked-image.service';

@NgModule({
  imports: [
    CommonModule,
    SharedModule,
    AuthModule,
    RouterModule.forChild([
      { path: '', component: CollectionViewComponent, canDeactivate: [SaveCollectionDataGuard] },
      { path: 'collections', component: CollectionsComponent, canActivate: [AuthGuard, VerifiedUserGuard] },
      { path: 'collections/:id', component: CollectionViewComponent, canActivate: [AuthGuard, VerifiedUserGuard], canDeactivate: [SaveCollectionDataGuard] },
      { path: 'collections/:id/purchase', component: PurchaseComponent, canActivate: [AuthGuard, VerifiedUserGuard] },
    ]),
  ],
  declarations: [CollectionsComponent, CollectionViewComponent, PurchaseComponent],
  providers: [
    CollectionService,
    CollectionItemService,
    LinkedImageService,
    SaveCollectionDataGuard
  ]
})
export class CollectionModule { }
