export interface BrowserInfo {
  browserName: string;
  browserVersion: string;
  osName: string;
}

interface UserAgentBrand {
  brand: string;
  version: string;
}

/** Minimal shape of the experimental `navigator.userAgentData` Client Hints API. */
export interface UserAgentDataLike {
  brands?: UserAgentBrand[];
  platform?: string;
}

const UA_BROWSER_MATCHERS: { name: string; regex: RegExp }[] = [
  // Order matters: more specific UAs (Edge/Opera/Samsung) embed "Chrome",
  // and Chrome embeds "Safari", so they must be tested first.
  { name: 'Microsoft Edge', regex: /Edg(?:e|A|iOS)?\/(\d+(?:\.\d+)?)/ },
  { name: 'Opera', regex: /(?:OPR|Opera)\/(\d+(?:\.\d+)?)/ },
  { name: 'Samsung Internet', regex: /SamsungBrowser\/(\d+(?:\.\d+)?)/ },
  { name: 'Firefox', regex: /(?:Firefox|FxiOS)\/(\d+(?:\.\d+)?)/ },
  { name: 'Chrome', regex: /(?:Chrome|CriOS)\/(\d+(?:\.\d+)?)/ },
  { name: 'Safari', regex: /Version\/(\d+(?:\.\d+)?).*Safari/ },
];

function parseUaBrowser(ua: string): { name: string; version: string } {
  for (const matcher of UA_BROWSER_MATCHERS) {
    const match = ua.match(matcher.regex);
    if (match) {
      return { name: matcher.name, version: match[1] };
    }
  }
  return { name: 'Unknown', version: '' };
}

function parseUaOs(ua: string): string {
  if (/Windows NT/.test(ua)) return 'Windows';
  // Android UA strings also contain "Linux", so test Android first.
  if (/Android/.test(ua)) return 'Android';
  if (/(iPhone|iPad|iPod)/.test(ua)) return 'iOS';
  if (/Mac OS X/.test(ua)) return 'macOS';
  if (/CrOS/.test(ua)) return 'ChromeOS';
  if (/Linux/.test(ua)) return 'Linux';
  return 'Unknown';
}

function pickBrand(brands: UserAgentBrand[]): { name: string; version: string } | undefined {
  // Drop the GREASE entry (e.g. "Not(A:Brand", "Not.A/Brand").
  const real = brands.filter((b) => !/not.*a.*brand/i.test(b.brand));
  if (real.length === 0) {
    return undefined;
  }
  // Prefer a specific brand (e.g. "Google Chrome") over generic "Chromium".
  const preferred = real.find((b) => b.brand !== 'Chromium') ?? real[0];
  return { name: preferred.brand, version: preferred.version };
}

/**
 * Best-effort, publicly-available browser/OS detection. Prefers the structured
 * `navigator.userAgentData` Client Hints when present and falls back to parsing
 * the raw user-agent string. Never throws.
 */
export function detectBrowser(userAgent: string, userAgentData?: UserAgentDataLike): BrowserInfo {
  const ua = userAgent ?? '';

  const brand = userAgentData?.brands ? pickBrand(userAgentData.brands) : undefined;
  const browser = brand ?? parseUaBrowser(ua);

  const platform = userAgentData?.platform?.trim();
  const osName = platform ? platform : parseUaOs(ua);

  return {
    browserName: browser.name || 'Unknown',
    browserVersion: browser.version || '',
    osName: osName || 'Unknown',
  };
}
