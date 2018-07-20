import { AppError } from "./app-error";

export class ValidationError extends AppError {
  validations: {}
  constructor(originalError: any) {
    super(originalError);
    this.validations = originalError.validations;
  }
}
