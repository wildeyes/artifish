import { ErrorHandler, Injectable, Injector } from '@angular/core';
import { AlertService } from '../../shared/services/alert.service';
import { TRANSLATE } from '../../translation-marker';

@Injectable()
export class AppErrorHandler implements ErrorHandler {

  constructor(private injector: Injector) { }

  handleError(error) {
    this.alertService.error(TRANSLATE('an_unexpected_error_occurred'));
    console.error(error);
  }


  private get alertService() : AlertService {
    return this.injector.get(AlertService);
  }

}
