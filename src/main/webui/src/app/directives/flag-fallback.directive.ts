import { computed, Directive, ElementRef, inject, input, Input } from '@angular/core';

@Directive({
  selector: '[flag-fallback]',
  standalone: true,
})
export class FlagFallbackDirective {
  DEFAULT_IMG = 'fifawc2026.png';

  @Input() logoFallback: string = this.DEFAULT_IMG;
  @Input() imgSrc: string = this.DEFAULT_IMG;
  @Input() bgImgSrc: string = this.DEFAULT_IMG;
  size = input<number>(8);

  readonly el = inject(ElementRef);

  ngOnInit() {
    if (this.el.nativeElement.tagName === 'IMG') {
      this.setImgSrc(this.imgSrc);
    } else {
      this.setBgImgSrc(this.bgImgSrc);
    }
  }

  private sizeStyle = computed(() => this.size() / 4 + 'rem !important');

  private setImgSrc(src: string) {
    const img = this.el.nativeElement as HTMLImageElement;
    img.src = src;

    img.onerror = () => {
      img.src = this.DEFAULT_IMG;
    };
  }

  private setBgImgSrc(src: string) {
    const img = new Image();
    img.src = src;
    img.onload = () => {
      this.el.nativeElement.style.backgroundImage = `url(${src})`;
      this.el.nativeElement.style.height = this.sizeStyle();
      this.el.nativeElement.style.width = this.sizeStyle();
    };
    img.onerror = () => {
      this.el.nativeElement.style.backgroundImage = `url(${this.DEFAULT_IMG})`;
      this.el.nativeElement.style.backgroundColor = 'rgba(255, 255, 255, 0.5)';
      this.el.nativeElement.style.height = this.sizeStyle();
      this.el.nativeElement.style.width = this.sizeStyle();
    };
  }
}
