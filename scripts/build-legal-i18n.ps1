# Build js/i18n-legal-suite.js from extracted English JSON + optional locale JSON files.
$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$jsDir = Join-Path $repoRoot "js"
$enPath = Join-Path $jsDir "i18n-legal-suite-en.json"
$outPath = Join-Path $jsDir "i18n-legal-suite.js"

function Read-JsonFile([string]$path) {
    $raw = [System.IO.File]::ReadAllText($path)
    if ($raw.Length -gt 0 -and [int][char]$raw[0] -eq 0xFEFF) { $raw = $raw.Substring(1) }
    return $raw | ConvertFrom-Json
}

$en = Read-JsonFile $enPath
$locales = @{ en = @{}; ar = @{}; fr = @{}; zh = @{} }

foreach ($prop in $en.PSObject.Properties) {
    $locales.en[$prop.Name] = $prop.Value
}

foreach ($lang in @('ar', 'fr', 'zh')) {
    $merged = @{}
    foreach ($part in @('part1', 'part2', 'part3')) {
        $partPath = Join-Path $jsDir "i18n-legal-suite-$lang-$part.json"
        if (Test-Path $partPath) {
            $data = Read-JsonFile $partPath
            foreach ($prop in $data.PSObject.Properties) {
                $merged[$prop.Name] = $prop.Value
            }
        }
    }
    if ($merged.Count -gt 0) {
        foreach ($k in $merged.Keys) { $locales[$lang][$k] = $merged[$k] }
        Write-Host "Merged $lang from parts: $($merged.Count) keys"
    } else {
        $langPath = Join-Path $jsDir "i18n-legal-suite-$lang.json"
        if (Test-Path $langPath) {
            $data = Read-JsonFile $langPath
            foreach ($prop in $data.PSObject.Properties) {
                $locales[$lang][$prop.Name] = $prop.Value
            }
            Write-Host "Merged $lang from single file: $($data.PSObject.Properties.Count) keys"
        }
    }
}

# Hub + meta keys (English defaults; translations in locale JSON)
$hub = @{
    en = @{
        'legal.hub' = 'Legal Center'
        'legal.hub.subtitle' = 'Production legal documents for Pinfold AI. Have counsel review before publication; translations are provided for convenience.'
        'legal.hub.contact' = 'Legal & privacy contact'
        'legal.hub.notice' = 'These documents are provided for transparency and compliance. They do not constitute legal advice. Pinfold AI operates the Pinfold mobile app (Android & iOS), Flutter client, .NET API at api.pinfoldai.com, and cloud infrastructure (including Hetzner and optional Azure services).'
        'legal.hub.section.core' = 'Core agreements'
        'legal.hub.section.use' = 'Use, content & AI'
        'legal.hub.section.data' = 'Data, security & privacy'
        'legal.hub.section.legal' = 'Legal protections'
        'legal.eula' = 'EULA'
        'legal.contact.p' = 'For legal, privacy, DMCA, export-control, and compliance inquiries: <a href="mailto:support@pinfoldai.com">support@pinfoldai.com</a>. For general support see <a href="/contact.html">Contact &amp; complaints</a>.'
        'meta.eula.title' = 'End User License Agreement - Pinfold'
        'meta.eula.description' = 'EULA for the Pinfold AI mobile application.'
        'meta.cookies.title' = 'Cookie Policy - Pinfold'
        'meta.cookies.description' = 'Cookie Policy for Pinfold.'
        'meta.ai.title' = 'AI Usage Disclaimer - Pinfold'
        'meta.ai.description' = 'AI disclaimer for Pinfold.'
        'meta.social.title' = 'Social Media Integration Terms - Pinfold'
        'meta.social.description' = 'Social integration terms for Pinfold.'
        'meta.copyright.title' = 'Copyright and IP Policy - Pinfold'
        'meta.copyright.description' = 'Copyright policy for Pinfold AI.'
        'meta.retention.title' = 'Data Retention Policy - Pinfold'
        'meta.retention.description' = 'Data retention policy for Pinfold.'
        'meta.security.title' = 'Security Disclaimer - Pinfold'
        'meta.security.description' = 'Security disclaimer for Pinfold.'
        'meta.opensource.title' = 'Open Source Notice - Pinfold'
        'meta.opensource.description' = 'Open source notice for Pinfold.'
        'meta.thirdparty.title' = 'Third-Party Services Disclaimer - Pinfold'
        'meta.thirdparty.description' = 'Third-party services disclaimer.'
        'meta.community.title' = 'Community Guidelines - Pinfold'
        'meta.community.description' = 'Community guidelines for Pinfold.'
        'meta.content.title' = 'Content Ownership Policy - Pinfold'
        'meta.content.description' = 'Content ownership policy.'
        'meta.termination.title' = 'Account Termination Policy - Pinfold'
        'meta.termination.description' = 'Account termination policy.'
        'meta.refunds.title' = 'Refund and Subscription Policy - Pinfold'
        'meta.refunds.description' = 'Refund and subscription policy.'
        'meta.liability.title' = 'Limitation of Liability - Pinfold'
        'meta.liability.description' = 'Limitation of liability.'
        'meta.indemnification.title' = 'Indemnification - Pinfold'
        'meta.indemnification.description' = 'Indemnification clause.'
        'meta.warranty.title' = 'Warranty Disclaimer - Pinfold'
        'meta.warranty.description' = 'Warranty disclaimer.'
        'meta.governing.title' = 'Governing Law - Pinfold'
        'meta.governing.description' = 'Governing law and dispute resolution.'
        'meta.export.title' = 'Export Control - Pinfold'
        'meta.export.description' = 'Export control compliance.'
        'meta.dmca.title' = 'DMCA Policy - Pinfold'
        'meta.dmca.description' = 'DMCA copyright policy.'
        'meta.children.title' = 'Children Privacy - Pinfold'
        'meta.children.description' = 'Children privacy policy.'
        'meta.changelog.title' = 'Legal Changelog - Pinfold'
        'meta.changelog.description' = 'Legal document changelog.'
        'meta.index.title' = 'Legal Center - Pinfold'
        'meta.index.description' = 'All legal documents for Pinfold AI in one place.'
    }
    ar = @{
        'legal.hub' = 'المركز القانوني'
        'legal.hub.subtitle' = 'مستندات قانونية جاهزة للإنتاج لتطبيق Pinfold AI. اطلب مراجعة مستشار قانوني قبل النشر؛ الترجمات للراحة فقط.'
        'legal.hub.contact' = 'الاتصال القانوني والخصوصية'
        'legal.hub.notice' = 'هذه المستندات للشفافية والامتثال وليست استشارة قانونية. يشغّل Pinfold AI تطبيق Pinfold (Android وiOS) وواجهة Flutter وواجهة .NET على api.pinfoldai.com والبنية السحابية (بما فيها Hetzner وخدمات Azure الاختيارية).'
        'legal.hub.section.core' = 'الاتفاقيات الأساسية'
        'legal.hub.section.use' = 'الاستخدام والمحتوى والذكاء الاصطناعي'
        'legal.hub.section.data' = 'البيانات والأمان والخصوصية'
        'legal.hub.section.legal' = 'الحماية القانونية'
        'legal.eula' = 'اتفاقية الترخيص'
        'legal.contact.p' = 'للاستفسارات القانونية والخصوصية وDMCA والامتثال: <a href="mailto:support@pinfoldai.com">support@pinfoldai.com</a>. للدعم العام راجع <a href="/contact.html">الاتصال والشكاوى</a>.'
        'meta.index.title' = 'المركز القانوني - Pinfold'
        'meta.index.description' = 'جميع المستندات القانونية لتطبيق Pinfold AI في مكان واحد.'
    }
    fr = @{
        'legal.hub' = 'Centre juridique'
        'legal.hub.subtitle' = 'Documents juridiques prêts pour la production de Pinfold AI. Faites-les examiner par un conseil avant publication ; les traductions sont fournies à titre indicatif.'
        'legal.hub.contact' = 'Contact juridique et confidentialité'
        'legal.hub.notice' = 'Ces documents visent la transparence et la conformité ; ils ne constituent pas un avis juridique. Pinfold AI exploite l''application Pinfold (Android et iOS), le client Flutter, l''API .NET sur api.pinfoldai.com et l''infrastructure cloud (dont Hetzner et des services Azure optionnels).'
        'legal.hub.section.core' = 'Accords principaux'
        'legal.hub.section.use' = 'Usage, contenu et IA'
        'legal.hub.section.data' = 'Données, sécurité et confidentialité'
        'legal.hub.section.legal' = 'Protections juridiques'
        'legal.eula' = 'CLUF'
        'legal.contact.p' = 'Pour les questions juridiques, confidentialité, DMCA et conformité : <a href="mailto:support@pinfoldai.com">support@pinfoldai.com</a>. Pour le support général, voir <a href="/contact.html">Contact et réclamations</a>.'
        'meta.index.title' = 'Centre juridique - Pinfold'
        'meta.index.description' = 'Tous les documents juridiques de Pinfold AI en un seul endroit.'
    }
    zh = @{
        'legal.hub' = '法律中心'
        'legal.hub.subtitle' = 'Pinfold AI 生产级法律文件。发布前请律师审阅；翻译仅供参考。'
        'legal.hub.contact' = '法律与隐私联系'
        'legal.hub.notice' = '本文档旨在提高透明度与合规性，不构成法律意见。Pinfold AI 运营 Pinfold 移动应用（Android 与 iOS）、Flutter 客户端、api.pinfoldai.com 上的 .NET API 以及云基础设施（含 Hetzner 及可选 Azure 服务）。'
        'legal.hub.section.core' = '核心协议'
        'legal.hub.section.use' = '使用、内容与 AI'
        'legal.hub.section.data' = '数据、安全与隐私'
        'legal.hub.section.legal' = '法律保护'
        'legal.eula' = '最终用户许可协议'
        'legal.contact.p' = '法律、隐私、DMCA 及合规咨询：<a href="mailto:support@pinfoldai.com">support@pinfoldai.com</a>。一般支持请见 <a href="/contact.html">联系与投诉</a>。'
        'meta.index.title' = '法律中心 - Pinfold'
        'meta.index.description' = 'Pinfold AI 全部法律文件一览。'
    }
}

foreach ($lang in @('en','ar','fr','zh')) {
    foreach ($k in $hub[$lang].Keys) {
        $locales[$lang][$k] = $hub[$lang][$k]
    }
}

function Escape-Js([string]$s) {
    if ($null -eq $s) { return '' }
    return $s.Replace('\', '\\').Replace("'", "\'").Replace("`r", '').Replace("`n", '\n')
}

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('(function () {')
[void]$sb.AppendLine('  if (!window.PINFOLD_I18N) window.PINFOLD_I18N = { en: {}, ar: {}, fr: {}, zh: {} };')
[void]$sb.AppendLine('  var suite = { en: {')

$first = $true
foreach ($k in ($locales.en.Keys | Sort-Object)) {
    if (-not $first) { [void]$sb.Append(',') } else { $first = $false }
    [void]$sb.Append("`n    '$k': '$(Escape-Js $locales.en[$k])'")
}
[void]$sb.AppendLine('')
[void]$sb.AppendLine('  }, ar: {')

$first = $true
foreach ($k in ($locales.ar.Keys | Sort-Object)) {
    if (-not $first) { [void]$sb.Append(',') } else { $first = $false }
    [void]$sb.Append("`n    '$k': '$(Escape-Js $locales.ar[$k])'")
}
[void]$sb.AppendLine('')
[void]$sb.AppendLine('  }, fr: {')

$first = $true
foreach ($k in ($locales.fr.Keys | Sort-Object)) {
    if (-not $first) { [void]$sb.Append(',') } else { $first = $false }
    [void]$sb.Append("`n    '$k': '$(Escape-Js $locales.fr[$k])'")
}
[void]$sb.AppendLine('')
[void]$sb.AppendLine('  }, zh: {')

$first = $true
foreach ($k in ($locales.zh.Keys | Sort-Object)) {
    if (-not $first) { [void]$sb.Append(',') } else { $first = $false }
    [void]$sb.Append("`n    '$k': '$(Escape-Js $locales.zh[$k])'")
}
[void]$sb.AppendLine('')
[void]$sb.AppendLine('  } };')
[void]$sb.AppendLine("  ['en','ar','fr','zh'].forEach(function (lang) { Object.assign(window.PINFOLD_I18N[lang], suite[lang]); });")
[void]$sb.AppendLine('})();')

[System.IO.File]::WriteAllText($outPath, $sb.ToString())
Write-Host "Wrote $outPath (en: $($locales.en.Count), ar: $($locales.ar.Count), fr: $($locales.fr.Count), zh: $($locales.zh.Count))"
