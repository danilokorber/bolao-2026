import { CommonModule, JsonPipe } from '@angular/common';
import { NgModule } from '@angular/core';

@NgModule({
  declarations: [],
  imports: [CommonModule, JsonPipe],
  exports: [JsonPipe],
})
export class BolaoModule {}
