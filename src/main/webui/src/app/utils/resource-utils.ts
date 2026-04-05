import { HttpErrorResponse } from '@angular/common/http';
import { ResourceRef } from '@angular/core';

/**
 * Extracts the value from an httpResource, treating a 404 error as `null`
 * instead of an error state. Useful for endpoints that return 404
 * when no entity exists yet (e.g. first-time champion bet lookup).
 */
export function resourceValueOr404<T>(resource: ResourceRef<T | null>): T | null {
  const error = resource.error() as HttpErrorResponse | null;
  if (error && error.status === 404) return null;
  return resource.value() ?? null;
}

/**
 * Returns true when the resource has finished loading — either it has a value
 * or it received a 404 (meaning "loaded but empty").
 */
export function resourceLoadedOr404(resource: ResourceRef<unknown>): boolean {
  const error = resource.error() as HttpErrorResponse | null;
  if (error && error.status === 404) return true;
  return resource.hasValue();
}
