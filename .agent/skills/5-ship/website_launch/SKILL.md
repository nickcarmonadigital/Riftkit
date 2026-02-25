---
name: Website Launch Checklist
description: Complete checklist for launching websites including design, content, SEO, analytics, and go-live verification
---

# Website Launch Skill

**Purpose**: Ensure nothing is missed when launching or updating a website. Covers design review, content verification, SEO, analytics, and go-live checks.

---

## 🎯 TRIGGER COMMANDS

```text
"Prepare for website launch"
"Website launch checklist"
"Is the site ready to go live?"
"Using website_launch skill: verify [url]"
```

---

## 📋 PRE-LAUNCH CHECKLIST

### 1. Content & Copy

| Check | Status | Notes |
|-------|--------|-------|
| All pages have content (no lorem ipsum) | ☐ | |
| Headlines are compelling | ☐ | |
| CTAs are clear and actionable | ☐ | |
| Pricing is accurate | ☐ | |
| Contact information is correct | ☐ | |
| Legal pages exist (Privacy, Terms) | ☐ | |
| Copyright year is current | ☐ | |
| No spelling/grammar errors | ☐ | Grammarly check |
| All links work (no 404s) | ☐ | |
| Phone/email links formatted correctly | ☐ | `tel:`, `mailto:` |

---

### 2. Design & UX

| Check | Status | Notes |
|-------|--------|-------|
| Consistent branding throughout | ☐ | Colors, fonts, voice |
| Images are high quality | ☐ | Not pixelated/stretched |
| Images have alt text | ☐ | Accessibility |
| Favicon is set | ☐ | 16x16, 32x32, apple-touch |
| Logo displays correctly | ☐ | Header, footer |
| Mobile responsive (320px-768px) | ☐ | Test on real devices |
| Tablet responsive (768px-1024px) | ☐ | |
| No horizontal scroll | ☐ | |
| Buttons have hover states | ☐ | |
| Forms have validation feedback | ☐ | |
| Loading states for actions | ☐ | |
| 404 page exists and is styled | ☐ | |

---

### 3. Technical & Performance

| Check | Status | Notes |
|-------|--------|-------|
| HTTPS enabled | ☐ | Check certificate |
| HTTP redirects to HTTPS | ☐ | |
| Lighthouse score > 80 | ☐ | Performance |
| Images optimized (WebP preferred) | ☐ | |
| JavaScript minified | ☐ | Production build |
| CSS purged of unused styles | ☐ | |
| Fonts loaded efficiently | ☐ | font-display: swap |
| No console errors | ☐ | |
| No console.log statements | ☐ | |
| Environment variables set | ☐ | Production values |

---

### 4. SEO

| Check | Status | Notes |
|-------|--------|-------|
| Title tags unique per page | ☐ | 50-60 chars |
| Meta descriptions per page | ☐ | 150-160 chars |
| H1 on every page | ☐ | Only one per page |
| Heading hierarchy correct | ☐ | H1→H2→H3 |
| robots.txt configured | ☐ | Allow crawling |
| sitemap.xml generated | ☐ | Submit to GSC |
| Canonical URLs set | ☐ | Prevent duplicates |
| Open Graph tags | ☐ | Facebook/LinkedIn preview |
| Twitter Card tags | ☐ | Twitter preview |
| JSON-LD schema | ☐ | Organization, LocalBusiness |
| Google Search Console verified | ☐ | |

---

### 5. Analytics & Tracking

| Check | Status | Notes |
|-------|--------|-------|
| Google Analytics 4 installed | ☐ | Test events |
| Goal tracking configured | ☐ | Form submits, clicks |
| Conversion tracking (if ads) | ☐ | Google Ads, FB Pixel |
| Hotjar/Clarity (optional) | ☐ | Session recordings |

---

### 6. Forms & Lead Capture

| Check | Status | Notes |
|-------|--------|-------|
| Forms submit successfully | ☐ | Test each form |
| Email notifications working | ☐ | Check inbox |
| CRM integration working | ☐ | Leads appear |
| Thank you pages configured | ☐ | Redirect after submit |
| Spam protection enabled | ☐ | Honeypot/reCAPTCHA |
| Required field validation | ☐ | |
| Error states visible | ☐ | |

---

### 7. Security

| Check | Status | Notes |
|-------|--------|-------|
| SSL certificate valid | ☐ | Not self-signed |
| Security headers set | ☐ | CSP, X-Frame-Options |
| No sensitive data exposed | ☐ | API keys, etc. |
| Rate limiting on forms | ☐ | Prevent abuse |

---

## 🚀 GO-LIVE STEPS

### Day Before Launch

1. [ ] Final content review
2. [ ] Backup current site (if replacing)
3. [ ] Test all forms one more time
4. [ ] Verify analytics is firing
5. [ ] Prepare DNS changes if needed

### Launch Day

1. [ ] Deploy production build
2. [ ] Update DNS if needed
3. [ ] Clear CDN cache
4. [ ] Test all pages load
5. [ ] Test form submissions
6. [ ] Check mobile experience
7. [ ] Submit sitemap to Google
8. [ ] Announce on social media

### Post-Launch (24-48 hrs)

1. [ ] Monitor for errors (logs)
2. [ ] Check Google Search Console for issues
3. [ ] Review analytics for unusual patterns
4. [ ] Respond to any user feedback
5. [ ] Fix any bugs discovered

---

## ✅ EXIT CRITERIA

Before marking launch complete:

- [ ] All pages live and tested
- [ ] No console errors
- [ ] Forms working
- [ ] Analytics tracking
- [ ] Mobile responsive
- [ ] SEO basics in place
- [ ] Legal pages published
- [ ] Sitemap submitted
