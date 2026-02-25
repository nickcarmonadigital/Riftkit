---
description: Comprehensive exit strategy for handing over a project to a client (The "Exit Package")
---

# Client Handoff Workflow (The Exit Strategy)

**Purpose**: Execute a clean, professional transfer of ownership to a client, ensuring they are set up for success and you are safely removed from the critical path.

> [!IMPORTANT]
> **GOAL**: Prevent "Support Hell". If the handoff is done right, the client will never need to call you for basic "how do I login" or "what is this bill" questions.

---

## 🎯 TRIGGER

- Project is "Feature Complete" and validated.
- Client has paid the final milestone.
- You are ready to "Exit" the project.

---

## 🔄 THE 4-PHASE EXIT

### Phase 1: Generate The Exit Package (The Cover Sheet)

Create `EXIT_PACKAGE.md` in the root (for the client). It serves as the index:

```markdown
# [Project Name] - Exit Package
**Date**: [Date]

## 1. Important Links
*   [Deployed Site](url)
*   [Admin Dashboard](url)
*   [Repository](GitHub URL)

## 2. Credentials & Secrets
> [!WARNING]
> See `SECRETS.md` (sent securely via Signal/1Password). **Do not commit secrets here.**

## 3. Operational Manual
*   [Client Handbook](docs/6-handoff/client-handbook.md)
*   [Runbooks](docs/6-handoff/runbooks/)

## 4. Asset Ownership
*   **Hosting**: Transferred to [Client Email]
*   **Database**: Transferred
*   **Domain**: Transferred
```

### Phase 2: Secrets & Environment Reference (The Keys)

Create a `SECRETS.md` (or strictly private PDF/Note) containing:

1. **Environment Variables**:
    - List every `ENV_VAR`.
    - Purpose of each.
    - Where to find the value (e.g., "Supabase Dashboard > Settings > API").
    - **CRITICAL**: Mark which ones are SECRET and must never be shared.

2. **Service Registry & Costs**:
    - **Supabase**: "Pro Plan ($25/mo) - Hosts Database & Auth"
    - **Vercel**: "Pro Plan ($20/mo) - Hosts Frontend"
    - **Resend**: "Free Tier (up to 3000 emails) - Emails"
    - **OpenAI**: "Pay-as-you-go - Intelligence"
    - **Total Estimated Monthly Cost**: ~$50/mo + usage.

### Phase 3: Operational Handoff (The Manual)

Ensure the `client-handbook.md` exists and covers:

1. **"Break Glass" Procedure**:
    - "Site is down? Check Vercel status."
    - "Database error? Check Supabase logs."
    - "AI not working? Check OpenAI credit balance."

2. **Admin Runbooks**:
    - How to add a new user.
    - How to view analytics.
    - How to export data.

### Phase 4: Asset Transfer (The Title)

Transfer ownership of the actual accounts.

1. **GitHub**: Transfer repository to Client Organization.
2. **Vercel**:
    - Invite Client as Team Member (Owner).
    - Promote to Owner.
    - Leave Team (or stay as Admin if retained).
3. **Supabase**:
    - Invite Client as Owner.
    - Transfer Billing to Client.
4. **API Keys**:
    - **Rotate Keys**: Generate NEW keys for the client.
    - Delete YOUR personal keys.
    - Update Env Vars with new keys.

### Phase 5: Builder Exit (The Goodbye)

1. **Revoke Access**:
    - Remove yourself from production database access (if not retained).
    - Remove your personal credit cards from ALL accounts.
2. **Final Walkthrough Recording**:
    - Record a 5-minute Loom: "Here is your new house".
    - Show them where the Docs are.
    - Show them the Service Registry.
3. **The "Good Luck" Email**:
    - Send final artifacts.
    - State clearly: "Project is now transferred. Standard support period ends on [Date]."

---

## ✅ HANDOFF CHECKLIST

- [ ] `EXIT_PACKAGE.md` created (Cover Sheet).
- [ ] `SECRETS.md` created (and securely transmitted, NOT committed).
- [ ] Cost of Ownership model explained to client.
- [ ] All billing transferred to client cards.
- [ ] GitHub Repo transferred.
- [ ] Vercel/Hosting transferred.
- [ ] Supabase/DB transferred.
- [ ] **YOUR ACCESS REVOKED** (Protect yourself).
- [ ] Final Walkthrough sent.
- [ ] Client confirms receipt and access.

---

## ⚠️ ERROR HANDLING

- **Client refuses to create accounts**: Do NOT use your personal accounts for their production. Stop and wait.
- **Client loses keys**: This is why `SECRETS.md` is crucial. Tell them to store it in 1Password/LastPass immediately.

---

*Workflow Version: 1.0 | Created: January 2026*
