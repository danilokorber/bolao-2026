import { Component, inject, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { TranslocoPipe } from '@jsverse/transloco';

@Component({
  selector: 'post-login',
  imports: [TranslocoPipe],
  template: `
    <img src="logging-in.gif" />
    <div
      class="w-full fixed left-0 bottom-0 pb-4 flex flex-row mx-auto justify-center items-center gap-4"
    >
      <button
        class="px-6 py-3 cursor-pointer text-primary-600 font-bold! rounded transition-colors hover:bg-primary-200"
      >
        {{ 'postLogin.logout' | transloco }}
      </button>
    </div>
  `,
})
export class PostLoginPage implements OnInit {
  private readonly router = inject(Router);

  ngOnInit(): void {
    this.router.navigate(['dashboard']);
  }
}
