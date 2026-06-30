# Pinfold Website

Marketing and legal static site for **Pinfold** (`com.pinfoldai.fileexplorer`).

**Live:** https://pinfoldai.com

## Pages

| Path | Description |
|------|-------------|
| `/` | Home — product overview |
| `/features.html` | Full app feature list |
| `/contact.html` | Support, complaints, abuse reports |
| `/legal/privacy.html` | Privacy Policy |
| `/legal/terms.html` | Terms of Service |
| `/legal/acceptable-use.html` | Acceptable Use Policy |
| `/legal/license.html` | License & Disclaimer |
| `/legal/data-deletion.html` | Account & data deletion |

This site is served separately from the API (`api.pinfoldai.com`) and admin portal (`admin.pinfoldai.com`).

## Deploy (Hetzner VPS)

From this repo:

```powershell
.\scripts\deploy.ps1 -Server root@YOUR_VPS_IP
```

First-time nginx vhost install:

```powershell
.\scripts\deploy.ps1 -Server root@YOUR_VPS_IP -InstallNginx
```

Files are deployed to `/var/www/pinfold-www` on the server.

## DNS

| Record | Value |
|--------|-------|
| `pinfoldai.com` | A → VPS IP |
| `www` | A or CNAME → same |

Cloudflare proxy (orange cloud) is supported with origin TLS on the VPS.

## Related repos

- Mobile app: `ga_file_explorer_app`
- Unified API: `ga_file_explorer_social_backend`
