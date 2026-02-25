---
name: Video Research
description: Analyze viral videos to extract hooks, structures, and patterns
---

# Video Research Skill

> **PURPOSE**: Automate the analysis of viral content to extract proven hooks and structures.

## 🎯 When to Use

- Researching hooks for new content
- Analyzing competitor content
- Building a swipe file of proven patterns
- Preparing for long-form video topics

---

## 🔬 The 5x Rule

A video is worth studying if:

```
Views >= Followers × 5

Example: Account has 10,000 followers
→ Look for videos with 50,000+ views
→ These are OUTLIERS worth studying
```

## 📊 Manual Research Process

### Step 1: Find Outliers

1. Go to Instagram explore page
2. Search your niche keyword
3. Click "Reels" tab
4. Scroll until you find 5x rule videos
5. Save/bookmark for analysis

### Step 2: Extract Data

For each outlier video, capture:

| Field | What to Capture |
|-------|-----------------|
| Link | URL to video |
| Creator | @handle, follower count |
| Views | Total views |
| Topic | What is it about |
| Verbal Hook | First 10 words spoken |
| Written Hook | Text on screen |
| Visual Hook | What you see first 3 sec |
| Format | How it's filmed |
| Structure | Comparison, tutorial, story, etc. |
| CTA | What they ask at end |
| Notes | Why you think it worked |

### Step 3: Add to Spreadsheet

Track in a spreadsheet with columns:

```
Date | Link | Creator | Views | Topic | Verbal Hook | Written Hook | Visual Hook | Format | Structure | CTA
```

## 🤖 Automated Research (AI Tools)

### Custom Analysis Prompts

#### Prompt 1: Extract Hooks

```markdown
Analyze this video transcript and extract:

1. VERBAL HOOK (first 10 words spoken)
2. WRITTEN HOOK (text shown on screen, if mentioned)
3. VISUAL HOOK DESCRIPTION (what happens visually in first 3 seconds)
4. HOOK TYPE (curiosity, social proof, controversy, relatable, etc.)

Return as JSON:
{
  "verbal_hook": "",
  "written_hook": "",
  "visual_hook": "",
  "hook_type": "",
  "why_it_works": ""
}
```

#### Prompt 2: Analyze Content Structure

```markdown
Analyze this video transcript and identify:

1. STRUCTURE TYPE (comparison, step-by-step, story, myth-busting, etc.)
2. TIMESTAMPS (when each section starts)
3. VALUE DENSITY (how measurable/specific is the advice)
4. CTA TYPE (follow, freebie, service)
5. ENGAGEMENT TRIGGERS (what keeps people watching)

Return structured analysis with timestamps and recommendations.
```

## 📈 Research Cadence

| Frequency | Activity |
|-----------|----------|
| Daily | Save 2-3 outlier videos to analyze later |
| Weekly | Deep analyze 5-10 videos, add to database |
| Before content | Pull relevant hooks from database for topic |
| Monthly | Review what's working, update patterns |

## ✅ Research Complete When

- [ ] 10+ outlier videos analyzed this week
- [ ] All hooks extracted and categorized
- [ ] Structures identified
- [ ] Database updated
- [ ] Patterns noticed and noted
- [ ] Ready to apply to next content piece
