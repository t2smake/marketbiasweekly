# MARKET BIAS WEEKLY — Technical Studies & Weekly Market Briefs

Weekly SPY technical analysis with Fibonacci confluence scoring, directional bias, and actionable trade setups.

**Live site:** [marketbiasweekly.netlify.app](https://marketbiasweekly.netlify.app) (or your custom domain)
**Follow:** [x.com/t2smbw](https://x.com/t2smbw) · [x.com/t2make](https://x.com/t2make)

---

## Setup — First Time (15 minutes)

### 1. Create the GitHub repo

```bash
cd ~/marketbiasweekly-site
git init
git add .
git commit -m "Initial site: landing page + first reports"
```

Go to [github.com/new](https://github.com/new) and create a repo called `marketbiasweekly-site` (public or private — both work with Netlify).

```bash
git remote add origin https://github.com/YOUR_USERNAME/marketbiasweekly-site.git
git branch -M main
git push -u origin main
```

### 2. Connect to Netlify

1. Go to [app.netlify.com](https://app.netlify.com) and sign up / log in
2. Click **"Add new site"** → **"Import an existing project"**
3. Select **GitHub** and authorize Netlify
4. Choose your `marketbiasweekly-site` repository
5. Build settings:
   - **Branch to deploy:** `main`
   - **Build command:** (leave empty — no build needed)
   - **Publish directory:** `.`
6. Click **"Deploy site"**

Your site will be live at `https://random-name.netlify.app` within 60 seconds.

### 3. Set your site name (optional)

In Netlify dashboard → Site settings → Domain management → Change site name to `marketbiasweekly`

Your URL becomes: **https://marketbiasweekly.netlify.app**

### 4. Custom domain (optional)

In Netlify dashboard → Domain management → Add custom domain → Enter `marketbiasweekly.com`

Netlify will give you DNS records to add at your domain registrar. Free HTTPS is automatic.

---

## Weekly Workflow — Publishing a New Report

### Option A: Manual (2 minutes)

```bash
# 1. Copy your new report into the site
cp ~/ta-dashboard/spy_weekly_latest.html ~/marketbiasweekly-site/reports/2026-04-13.html
cp ~/ta-dashboard/spy_weekly_latest.html ~/marketbiasweekly-site/reports/latest.html

# 2. Edit index.html to add the new report to the archive
#    (add a new <a class="archive-card"> block at the top of the archive list)
nano ~/marketbiasweekly-site/index.html

# 3. Push to GitHub — Netlify auto-deploys
cd ~/marketbiasweekly-site
git add .
git commit -m "Weekly brief: Apr 13-17, 2026"
git push
```

Live in ~30 seconds.

### Option B: Automated script (30 seconds)

```bash
./publish.sh
```

The `publish.sh` script handles everything — see below.

---

## File Structure

```
marketbiasweekly-site/
├── index.html              ← Landing page + report archive
├── netlify.toml            ← Netlify config + redirects
├── publish.sh              ← One-command publish script
├── README.md               ← This file
├── reports/
│   ├── latest.html         ← Always points to newest report
│   ├── 2026-04-06.html     ← Individual weekly reports
│   ├── 2026-03-29.html
│   └── ...
├── social/
│   ├── og-default.png      ← Default social preview image
│   └── ...                 ← Weekly social card images
└── assets/
    └── ...                 ← Shared assets (if any)
```

## URLs

| URL | What it shows |
|-----|--------------|
| `/` | Landing page with archive |
| `/latest` | Redirects to newest report |
| `/this-week` | Same as /latest |
| `/reports/2026-04-06.html` | Specific week's report |

---

## Updating a Past Report

```bash
# Edit the file directly
nano ~/marketbiasweekly-site/reports/2026-03-29.html

# Or replace it
cp ~/ta-dashboard/fixed_report.html ~/marketbiasweekly-site/reports/2026-03-29.html

# Push — same URL, updated content
cd ~/marketbiasweekly-site
git add .
git commit -m "Fix: corrected levels in Mar 29 report"
git push
```

Netlify redeploys in ~30 seconds. Same URL, updated content, no cache issues.

---

## License

Content © MARKET BIAS WEEKLY. Not financial advice.
