export class AppError {
  constructor(public originalError?: any) { }

  public get message() : string {
    if (this.originalError && this.originalError['message'])
      return this.originalError['message']
  }
}
