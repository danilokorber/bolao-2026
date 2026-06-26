export interface RouteVisitRequest {
  sessionId: string;
  path: string;
  screenWidth?: number;
  screenHeight?: number;
  viewportWidth?: number;
  viewportHeight?: number;
  devicePixelRatio?: number;
  browserName?: string;
  browserVersion?: string;
  osName?: string;
  language?: string;
  timezone?: string;
  referrer?: string;
  userAgent?: string;
}
