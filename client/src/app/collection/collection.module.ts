import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { CollectionsComponent } from './components/collections/collections.component';
import { CollectionService } from './services/collection.service';
import { SharedModule } from '../shared/shared.module';
import { AuthGuard } from '../auth/services/auth-guard.service';
import { VerifiedUserGuard } from '../core/services/verified-user-guard.service';
import { RouterModule } from '@angular/router';
import { AuthModule } from 'angular2-jwt';
import { CollectionFormComponent } from './components/collection-form/collection-form.component';
import { CollectionViewComponent } from './components/collection-view/collection-view.component';
import { LinkedImageService } from './services/linked-image.service';
import { CollectionItemService } from './services/collection-item.service';
import { PurchaseComponent } from './components/purchase/purchase.component';

@NgModule({
  imports: [
    CommonModule,
    SharedModule,
    AuthModule,
    RouterModule.forChild([
      { path: 'collections', component: CollectionsComponent, canActivate: [AuthGuard, VerifiedUserGuard] },
      { path: 'collections/new', component: CollectionFormComponent, canActivate: [AuthGuard, VerifiedUserGuard] },
      { path: 'collections/:id', component: CollectionViewComponent, canActivate: [AuthGuard, VerifiedUserGuard] },
      { path: 'collections/:id/purchase', component: PurchaseComponent, canActivate: [AuthGuard, VerifiedUserGuard] },
    ]),
  ],
  declarations: [CollectionsComponent, CollectionFormComponent, CollectionViewComponent, PurchaseComponent],
  providers: [
    CollectionService,
    CollectionItemService,
    LinkedImageService
  ]
})
export class CollectionModule { }
