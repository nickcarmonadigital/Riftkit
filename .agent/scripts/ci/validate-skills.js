#!/usr/bin/env node
/**
 * Validate skill directories have SKILL.md with required structure.
 * Skills are organized in phase directories: skills/{phase}/{skill}/SKILL.md
 */

const fs = require('fs');
const path = require('path');

const SKILLS_DIR = path.join(__dirname, '../../skills');

// Phase directories that contain skill subdirectories (not skills themselves)
const PHASE_DIRS = [
  '0-context', '1-brainstorm', '2-design', '3-build', '4-secure',
  '5-ship', '5.5-alpha', '5.75-beta', '6-handoff', '7-maintenance', 'toolkit'
];

function validateSkills() {
  if (!fs.existsSync(SKILLS_DIR)) {
    console.log('No skills directory found, skipping validation');
    process.exit(0);
  }

  let hasErrors = false;
  let validCount = 0;
  let phaseCount = 0;

  const topEntries = fs.readdirSync(SKILLS_DIR, { withFileTypes: true });
  const topDirs = topEntries.filter(e => e.isDirectory()).map(e => e.name);

  for (const phaseDir of topDirs) {
    // Skip non-phase directories (e.g., 'learned')
    if (!PHASE_DIRS.includes(phaseDir) && phaseDir !== 'learned') {
      console.warn(`WARN: ${phaseDir}/ - Unexpected directory in skills/`);
      continue;
    }

    // Skip the learned directory (user-created patterns)
    if (phaseDir === 'learned') {
      continue;
    }

    phaseCount++;
    const phasePath = path.join(SKILLS_DIR, phaseDir);
    const skillEntries = fs.readdirSync(phasePath, { withFileTypes: true });
    const skillDirs = skillEntries.filter(e => e.isDirectory()).map(e => e.name);

    for (const skillDir of skillDirs) {
      const skillMd = path.join(phasePath, skillDir, 'SKILL.md');
      if (!fs.existsSync(skillMd)) {
        console.error(`ERROR: ${phaseDir}/${skillDir}/ - Missing SKILL.md`);
        hasErrors = true;
        continue;
      }

      let content;
      try {
        content = fs.readFileSync(skillMd, 'utf-8');
      } catch (err) {
        console.error(`ERROR: ${phaseDir}/${skillDir}/SKILL.md - ${err.message}`);
        hasErrors = true;
        continue;
      }
      if (content.trim().length === 0) {
        console.error(`ERROR: ${phaseDir}/${skillDir}/SKILL.md - Empty file`);
        hasErrors = true;
        continue;
      }

      validCount++;
    }
  }

  if (hasErrors) {
    console.error(`\nValidated ${validCount} skills across ${phaseCount} phases (with errors)`);
    process.exit(1);
  }

  console.log(`Validated ${validCount} skills across ${phaseCount} phases`);
}

validateSkills();
