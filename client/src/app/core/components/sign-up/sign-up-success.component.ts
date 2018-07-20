import { Component, OnInit } from '@angular/core';
import { DataService } from '../../../shared/services/data.service';

@Component({
  selector: 'app-sign-up-success',
  templateUrl: './sign-up-success.component.html',
  styleUrls: ['./sign-up-success.component.css']
})
export class SignUpSuccessComponent implements OnInit {
  emailAddress: string;

  constructor(dataService: DataService) {
    this.emailAddress = dataService.data;
  }

  ngOnInit() {
  }

}
