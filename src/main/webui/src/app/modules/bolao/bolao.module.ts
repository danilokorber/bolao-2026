import { CommonModule, JsonPipe } from '@angular/common';
import { NgModule } from '@angular/core';
import { Card } from '@components/card/card';
import { CardContent } from '@components/card/card-content';
import { CardFooter } from '@components/card/card-footer';
import { CardHeader } from '@components/card/card-header';

@NgModule({
  declarations: [],
  imports: [CommonModule, JsonPipe, Card, CardHeader, CardContent, CardFooter],
  exports: [JsonPipe, Card, CardHeader, CardContent, CardFooter],
})
export class BolaoModule {}
