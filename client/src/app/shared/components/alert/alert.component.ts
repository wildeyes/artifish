import { Component, OnInit, Renderer2, ViewChild, ElementRef, NgZone } from '@angular/core';
import { AlertService } from '../../services/alert.service';

@Component({
  selector: 'alert',
  templateUrl: './alert.component.html'
})
export class AlertComponent implements OnInit {
  message: any
  @ViewChild('messageDiv') messageHtmlElement: ElementRef;


  constructor(private alertService: AlertService, private zone: NgZone) { }

  ngOnInit() {
    this.alertService.getMessage().subscribe(message => {
      this.zone.run(() => {
        this.message = message;
        if (!message) return;

        this.focusMessageElement();
      })
    });
  }

  private focusMessageElement() {
    setTimeout(() => {
      if (this.messageHtmlElement && this.messageHtmlElement.nativeElement) {
        this.messageHtmlElement.nativeElement.focus();
      }
    })
  }

}
