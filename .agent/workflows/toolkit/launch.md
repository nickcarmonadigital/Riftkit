---
description: Complete website launch checklist including DNS, analytics, and go-live verification
---

# /launch Workflow

> Use when deploying a website or app for the first time (go-live)

## Pre-Flight Checks

- [ ] All features tested?
- [ ] /ship workflow completed?
- [ ] Domain purchased?

---

## Step 1: Read Launch Skills

// turbo

```bash
view_file .agent/skills/website_launch/SKILL.md
view_file .agent/skills/ip_protection/SKILL.md
```

---

## Step 2: Pre-Launch Checklist

### Technical

- [ ] SSL certificate configured
- [ ] HTTPS enforced (no HTTP fallback)
- [ ] 404 page exists
- [ ] Favicon set
- [ ] robots.txt configured
- [ ] sitemap.xml generated

### SEO

- [ ] Title tags on all pages
- [ ] Meta descriptions on all pages
- [ ] OpenGraph tags for social sharing
- [ ] Canonical URLs set

### Legal

- [ ] Privacy policy page
- [ ] Terms of service page
- [ ] Cookie consent (if applicable)
- [ ] GDPR compliance (if EU users)

### Analytics

- [ ] Analytics installed (GA4, Plausible, etc.)
- [ ] Tracking verified
- [ ] Goals/conversions configured

---

## Step 3: IP Protection Check (ip_protection skill)

If this is a new product:

- [ ] Trademarks filed or in progress?
- [ ] Copyright notices in place?
- [ ] Trade secrets protected?
- [ ] Terms of service protect your IP?

---

## Step 4: DNS Configuration

1. Point domain to hosting (Vercel, Netlify, etc.)
2. Configure DNS records:
   - A record or CNAME for root domain
   - www redirect configured
3. Wait for propagation (can take up to 48 hours)
4. Verify SSL certificate is active

---

## Step 5: Deploy to Production

// turbo

```bash
# Example for Vercel
vercel --prod
```

---

## Step 6: Post-Launch Verification

- [ ] Site loads on custom domain
- [ ] SSL shows green lock
- [ ] All pages accessible
- [ ] Forms submit correctly
- [ ] Analytics receiving data
- [ ] Mobile view works
- [ ] No console errors

---

## Step 7: Announce (Optional)

- [ ] Social media announcement
- [ ] Email list notification
- [ ] Submit to Product Hunt / Indie Hackers
- [ ] Update LinkedIn

---

## Exit Checklist

- [ ] Site live on custom domain
- [ ] SSL working
- [ ] Analytics active
- [ ] Legal pages in place
- [ ] All critical flows tested
- [ ] Celebrate! 🎉
