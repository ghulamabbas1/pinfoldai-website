# Assemble full legal HTML pages from content/*.body.html fragments.
$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$contentDir = Join-Path $repoRoot "legal\content"
$legalDir = Join-Path $repoRoot "legal"

$pages = @(
    @{ Slug = "eula"; Page = "eula"; Title = "End User License Agreement - Pinfold"; Desc = "EULA for the Pinfold AI mobile application." },
    @{ Slug = "terms"; Page = "terms"; Title = "Terms of Service - Pinfold"; Desc = "Terms of Service for Pinfold AI." },
    @{ Slug = "privacy"; Page = "privacy"; Title = "Privacy Policy - Pinfold"; Desc = "Privacy Policy for Pinfold AI." },
    @{ Slug = "cookies"; Page = "cookies"; Title = "Cookie Policy - Pinfold"; Desc = "Cookie Policy for Pinfold." },
    @{ Slug = "acceptable-use"; Page = "acceptable"; Title = "Acceptable Use Policy - Pinfold"; Desc = "Acceptable Use Policy for Pinfold AI." },
    @{ Slug = "ai-disclaimer"; Page = "ai"; Title = "AI Usage Disclaimer - Pinfold"; Desc = "AI disclaimer for Pinfold." },
    @{ Slug = "social-integration"; Page = "social"; Title = "Social Media Integration Terms - Pinfold"; Desc = "Social integration terms for Pinfold." },
    @{ Slug = "copyright"; Page = "copyright"; Title = "Copyright and IP Policy - Pinfold"; Desc = "Copyright policy for Pinfold AI." },
    @{ Slug = "data-retention"; Page = "retention"; Title = "Data Retention Policy - Pinfold"; Desc = "Data retention policy for Pinfold." },
    @{ Slug = "security"; Page = "security"; Title = "Security Disclaimer - Pinfold"; Desc = "Security disclaimer for Pinfold." },
    @{ Slug = "open-source"; Page = "opensource"; Title = "Open Source Notice - Pinfold"; Desc = "Open source notice for Pinfold." },
    @{ Slug = "third-party"; Page = "thirdparty"; Title = "Third-Party Services Disclaimer - Pinfold"; Desc = "Third-party services disclaimer." },
    @{ Slug = "community"; Page = "community"; Title = "Community Guidelines - Pinfold"; Desc = "Community guidelines for Pinfold." },
    @{ Slug = "content-ownership"; Page = "content"; Title = "Content Ownership Policy - Pinfold"; Desc = "Content ownership policy." },
    @{ Slug = "account-termination"; Page = "termination"; Title = "Account Termination Policy - Pinfold"; Desc = "Account termination policy." },
    @{ Slug = "refunds"; Page = "refunds"; Title = "Refund and Subscription Policy - Pinfold"; Desc = "Refund and subscription policy." },
    @{ Slug = "liability"; Page = "liability"; Title = "Limitation of Liability - Pinfold"; Desc = "Limitation of liability." },
    @{ Slug = "indemnification"; Page = "indemnification"; Title = "Indemnification - Pinfold"; Desc = "Indemnification clause." },
    @{ Slug = "warranty"; Page = "warranty"; Title = "Warranty Disclaimer - Pinfold"; Desc = "Warranty disclaimer." },
    @{ Slug = "governing-law"; Page = "governing"; Title = "Governing Law - Pinfold"; Desc = "Governing law and dispute resolution." },
    @{ Slug = "export-control"; Page = "export"; Title = "Export Control - Pinfold"; Desc = "Export control compliance." },
    @{ Slug = "dmca"; Page = "dmca"; Title = "DMCA Policy - Pinfold"; Desc = "DMCA copyright policy." },
    @{ Slug = "children"; Page = "children"; Title = "Children Privacy - Pinfold"; Desc = "Children privacy policy." },
    @{ Slug = "changelog"; Page = "changelog"; Title = "Legal Changelog - Pinfold"; Desc = "Legal document changelog." }
)

$header = @'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <meta name="description" content="{DESC}" />
  <title>{TITLE}</title>
  <meta name="theme-color" content="#f8fafc" />
  <script src="/js/boot.js"></script>
  <link rel="stylesheet" href="/css/site.css" />
  <link rel="canonical" href="https://pinfoldai.com/legal/{SLUG}.html" />
</head>
<body data-page="{PAGE}">
  <header class="site-header">
    <div class="container inner">
      <a class="logo" href="/"><span class="logo-mark">P</span><span>Pinfold</span></a>
      <nav class="nav-desktop">
        <a href="/" data-nav="/" data-i18n="nav.home">Home</a>
        <a href="/features.html" data-nav="/features.html" data-i18n="nav.features">Features</a>
        <a href="/contact.html" data-nav="/contact.html" data-i18n="nav.contact">Contact</a>
        <a href="/legal/index.html" data-nav="/legal/index.html" data-i18n="legal.hub">Legal</a>
        <a href="/legal/privacy.html" data-nav="/legal/privacy.html" data-i18n="nav.privacy">Privacy</a>
        <a class="btn btn-primary btn-sm nav-cta" href="/features.html" data-i18n="nav.getApp">Get the app</a>
      </nav>
      <button class="nav-toggle" type="button" aria-label="Open menu" aria-expanded="false" aria-controls="nav-mobile" data-i18n="nav.menu">Menu</button>
    </div>
    <nav id="nav-mobile" class="nav-mobile container">
      <a href="/" data-i18n="nav.home">Home</a>
      <a href="/features.html" data-i18n="nav.features">Features</a>
      <a href="/contact.html" data-i18n="nav.contact">Contact</a>
      <a href="/legal/index.html" data-i18n="legal.hub">Legal</a>
      <a href="/legal/privacy.html" data-i18n="nav.privacy">Privacy</a>
    </nav>
  </header>

  <main class="legal-doc">
    <div class="container-narrow">
      <p class="legal-breadcrumb"><a href="/legal/index.html" data-i18n="legal.hub">Legal Center</a></p>
{BODY}
    </div>
  </main>

  <footer class="site-footer">
    <div class="container footer-grid">
      <div>
        <a class="logo" href="/"><span class="logo-mark">P</span> Pinfold</a>
        <p class="footer-tagline">
          <span data-i18n="footer.tagline">Productivity file management for mobile.</span><br />
          <a href="mailto:support@pinfoldai.com">support@pinfoldai.com</a>
        </p>
      </div>
      <div>
        <h4 data-i18n="footer.product">Product</h4>
        <ul>
          <li><a href="/features.html" data-i18n="footer.features">Features</a></li>
          <li><a href="/contact.html" data-i18n="footer.contactComplaints">Contact &amp; complaints</a></li>
        </ul>
      </div>
      <div>
        <h4 data-i18n="footer.legal">Legal</h4>
        <ul>
          <li><a href="/legal/index.html" data-i18n="legal.hub">Legal Center</a></li>
          <li><a href="/legal/privacy.html" data-i18n="footer.privacy">Privacy Policy</a></li>
          <li><a href="/legal/terms.html" data-i18n="footer.terms">Terms of Service</a></li>
          <li><a href="/legal/eula.html" data-i18n="legal.eula">EULA</a></li>
        </ul>
      </div>
    </div>
    <div class="container footer-bottom" data-i18n="footer.copyright">
      &copy; 2026 Pinfold. All rights reserved. Package: com.pinfoldai.fileexplorer
    </div>
  </footer>
  <script src="/js/i18n.js"></script>
  <script src="/js/i18n-legal.js"></script>
  <script src="/js/i18n-legal-suite.js"></script>
  <script src="/js/site.js"></script>
</body>
</html>
'@

foreach ($p in $pages) {
    $bodyPath = Join-Path $contentDir "$($p.Slug).body.html"
    if (-not (Test-Path $bodyPath)) {
        Write-Warning "Missing body: $bodyPath"
        continue
    }
    $body = Get-Content $bodyPath -Raw
    $html = $header.Replace('{DESC}', $p.Desc)
    $html = $html.Replace('{TITLE}', $p.Title)
    $html = $html.Replace('{SLUG}', $p.Slug)
    $html = $html.Replace('{PAGE}', $p.Page)
    $html = $html.Replace('{BODY}', $body.Trim())
    $outPath = Join-Path $legalDir "$($p.Slug).html"
    [System.IO.File]::WriteAllText($outPath, $html)
    Write-Host "Built $outPath"
}

Write-Host "Done."
