import { Component, OnInit } from '@angular/core';
import { ContactUsService } from '../../services/contact-us.service';

@Component({
  selector: 'app-contact-us',
  templateUrl: './contact-us.component.html',
  styleUrls: ['./contact-us.component.css']
})
export class ContactUsComponent implements OnInit {
  model: any = {};
  loading: boolean = false;

  constructor(private contactUsService: ContactUsService) { }

  ngOnInit() {
  }

  sendContactUs() {
    this.loading = true;
    this.contactUsService.create(this.model).subscribe(
      res => this.loading = false,
      error => this.loading = false
    );
  }

}
