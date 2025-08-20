#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

// Configuration
const SCRIPT_DIR = __dirname;
const BASE_DIR = path.dirname(SCRIPT_DIR);
const RAW_DATA_DIR = path.join(BASE_DIR, 'raw-data');
const ORGANIZED_DIR = path.join(BASE_DIR, 'organized');

// Category mappings
const CATEGORIES = {
  frontend: {
    keywords: ['ui', 'react', 'frontend', 'component', 'interface', 'design', 'css', 'tailwind'],
    labels: ['frontend', 'ui', 'ux', 'design', 'react']
  },
  backend: {
    keywords: ['api', 'server', 'backend', 'endpoint', 'route', 'service'],
    labels: ['backend', 'api', 'server']
  },
  blockchain: {
    keywords: ['smart contract', 'blockchain', 'solidity', 'web3', 'ethereum', 'besu'],
    labels: ['blockchain', 'smart-contract', 'web3']
  },
  adminPanel: {
    keywords: ['admin', 'panel', 'dashboard', 'management', 'administration'],
    labels: ['admin', 'dashboard', 'admin-panel']
  },
  database: {
    keywords: ['database', 'db', 'postgresql', 'sql', 'migration', 'schema'],
    labels: ['database', 'db', 'postgresql', 'migration']
  },
  security: {
    keywords: ['security', 'auth', 'authentication', 'authorization', 'pin', 'kyc'],
    labels: ['security', 'auth', 'authentication']
  },
  performance: {
    keywords: ['performance', 'optimization', 'slow', 'cache', 'speed'],
    labels: ['performance', 'optimization']
  },
  documentation: {
    keywords: ['documentation', 'docs', 'readme', 'guide', 'tutorial'],
    labels: ['documentation', 'docs']
  },
  testing: {
    keywords: ['test', 'testing', 'spec', 'cypress', 'jest', 'e2e'],
    labels: ['testing', 'test', 'qa']
  },
  devops: {
    keywords: ['deployment', 'ci', 'cd', 'docker', 'infrastructure'],
    labels: ['devops', 'deployment', 'ci-cd']
  }
};

// Priority mappings
const PRIORITY_MAPPING = {
  critical: ['critical', 'urgent', 'security', 'down', 'broken'],
  high: ['high', 'important', 'major', 'bug'],
  medium: ['medium', 'enhancement', 'feature'],
  low: ['low', 'minor', 'nice-to-have', 'documentation']
};

function loadIssues() {
  const latestFile = path.join(RAW_DATA_DIR, 'all-issues-latest.json');
  
  if (!fs.existsSync(latestFile)) {
    console.error('❌ No issues file found. Run fetch-issues.sh first.');
    process.exit(1);
  }

  try {
    const data = fs.readFileSync(latestFile, 'utf8');
    return JSON.parse(data);
  } catch (error) {
    console.error('❌ Error reading issues file:', error.message);
    process.exit(1);
  }
}

function categorizeIssue(issue) {
  const title = issue.title.toLowerCase();
  const body = (issue.body || '').toLowerCase();
  const labels = issue.labels.map(l => l.name.toLowerCase());
  
  const categories = [];

  for (const [category, config] of Object.entries(CATEGORIES)) {
    // Check labels first
    if (labels.some(label => config.labels.includes(label))) {
      categories.push(category);
      continue;
    }

    // Check keywords in title and body
    if (config.keywords.some(keyword => 
        title.includes(keyword) || body.includes(keyword))) {
      categories.push(category);
    }
  }

  return categories.length > 0 ? categories : ['uncategorized'];
}

function determinePriority(issue) {
  const title = issue.title.toLowerCase();
  const body = (issue.body || '').toLowerCase();
  const labels = issue.labels.map(l => l.name.toLowerCase());
  
  // Check labels first
  for (const [priority, keywords] of Object.entries(PRIORITY_MAPPING)) {
    if (labels.some(label => keywords.includes(label))) {
      return priority;
    }
  }

  // Check keywords in title and body
  for (const [priority, keywords] of Object.entries(PRIORITY_MAPPING)) {
    if (keywords.some(keyword => 
        title.includes(keyword) || body.includes(keyword))) {
      return priority;
    }
  }

  return 'medium'; // default priority
}

function formatIssueForMarkdown(issue) {
  const categories = categorizeIssue(issue);
  const priority = determinePriority(issue);
  const assignees = issue.assignees.map(a => a.login).join(', ') || 'Unassigned';
  const milestone = issue.milestone ? issue.milestone.title : 'No milestone';
  
  return `# Issue #${issue.number}: ${issue.title}

**URL**: ${issue.url}
**Status**: ${issue.state}
**Author**: ${issue.author.login}
**Created**: ${new Date(issue.createdAt).toLocaleDateString()}
**Updated**: ${new Date(issue.updatedAt).toLocaleDateString()}
**Categories**: ${categories.join(', ')}
**Priority**: ${priority}
**Assignees**: ${assignees}
**Milestone**: ${milestone}

## Labels
${issue.labels.map(l => `- ${l.name}`).join('\n')}

## Description
${issue.body || 'No description provided.'}

---

## Integration Impact

### Admin Panel Development
${categories.includes('adminPanel') ? '✅ Directly related to admin panel development' : '⚠️ Consider impact on admin panel features'}

### Database Migration  
${categories.includes('database') ? '✅ Directly related to database migration' : '⚠️ Consider database implications'}

### PendScan Enhancement
${categories.includes('frontend') || categories.includes('blockchain') ? '✅ May impact PendScan modernization' : '⚠️ Review for PendScan relevance'}

### Mobile App Development
${categories.includes('frontend') || categories.includes('backend') ? '✅ Consider for mobile app API design' : '⚠️ Review mobile compatibility'}

## Implementation Checklist
- [ ] Review requirements against future development plans
- [ ] Estimate development effort  
- [ ] Identify dependencies
- [ ] Plan testing strategy
- [ ] Consider integration points
- [ ] Update relevant planning documents

`;
}

function organizeIssues(issues) {
  console.log('🔄 Organizing issues by category, priority, and status...');

  // Clear organized directories
  const organizedPaths = [
    path.join(ORGANIZED_DIR, 'by-category'),
    path.join(ORGANIZED_DIR, 'by-priority'), 
    path.join(ORGANIZED_DIR, 'by-status'),
    path.join(ORGANIZED_DIR, 'by-milestone')
  ];

  organizedPaths.forEach(dir => {
    if (fs.existsSync(dir)) {
      fs.rmSync(dir, { recursive: true });
    }
    fs.mkdirSync(dir, { recursive: true });
  });

  const stats = {
    categories: {},
    priorities: {},
    statuses: {},
    milestones: {}
  };

  issues.forEach(issue => {
    const categories = categorizeIssue(issue);
    const priority = determinePriority(issue);
    const status = issue.state;
    const milestone = issue.milestone ? issue.milestone.title : 'no-milestone';

    // Organize by category
    categories.forEach(category => {
      const categoryDir = path.join(ORGANIZED_DIR, 'by-category', category);
      fs.mkdirSync(categoryDir, { recursive: true });
      
      const filename = `issue-${issue.number}-${issue.title.replace(/[^a-zA-Z0-9]/g, '-')}.md`;
      const filepath = path.join(categoryDir, filename);
      fs.writeFileSync(filepath, formatIssueForMarkdown(issue));
      
      stats.categories[category] = (stats.categories[category] || 0) + 1;
    });

    // Organize by priority
    const priorityDir = path.join(ORGANIZED_DIR, 'by-priority', priority);
    fs.mkdirSync(priorityDir, { recursive: true });
    
    const priorityFilename = `issue-${issue.number}-${issue.title.replace(/[^a-zA-Z0-9]/g, '-')}.md`;
    const priorityFilepath = path.join(priorityDir, priorityFilename);
    fs.writeFileSync(priorityFilepath, formatIssueForMarkdown(issue));
    
    stats.priorities[priority] = (stats.priorities[priority] || 0) + 1;

    // Organize by status
    const statusDir = path.join(ORGANIZED_DIR, 'by-status', status);
    fs.mkdirSync(statusDir, { recursive: true });
    
    const statusFilename = `issue-${issue.number}-${issue.title.replace(/[^a-zA-Z0-9]/g, '-')}.md`;
    const statusFilepath = path.join(statusDir, statusFilename);
    fs.writeFileSync(statusFilepath, formatIssueForMarkdown(issue));
    
    stats.statuses[status] = (stats.statuses[status] || 0) + 1;

    // Organize by milestone
    const milestoneDir = path.join(ORGANIZED_DIR, 'by-milestone', milestone);
    fs.mkdirSync(milestoneDir, { recursive: true });
    
    const milestoneFilename = `issue-${issue.number}-${issue.title.replace(/[^a-zA-Z0-9]/g, '-')}.md`;
    const milestoneFilepath = path.join(milestoneDir, milestoneFilename);
    fs.writeFileSync(milestoneFilepath, formatIssueForMarkdown(issue));
    
    stats.milestones[milestone] = (stats.milestones[milestone] || 0) + 1;
  });

  return stats;
}

function generateSummaryReport(issues, stats) {
  const report = `# GitHub Issues Summary Report

**Generated**: ${new Date().toLocaleString()}
**Total Issues**: ${issues.length}

## Status Breakdown
${Object.entries(stats.statuses).map(([status, count]) => `- **${status}**: ${count}`).join('\n')}

## Priority Breakdown  
${Object.entries(stats.priorities).map(([priority, count]) => `- **${priority}**: ${count}`).join('\n')}

## Category Breakdown
${Object.entries(stats.categories).map(([category, count]) => `- **${category}**: ${count}`).join('\n')}

## Milestone Breakdown
${Object.entries(stats.milestones).map(([milestone, count]) => `- **${milestone}**: ${count}`).join('\n')}

## Integration with Future Development

### High Priority Items for 2025 Roadmap
${issues.filter(issue => determinePriority(issue) === 'critical' || determinePriority(issue) === 'high')
  .slice(0, 10)
  .map(issue => `- Issue #${issue.number}: ${issue.title} (${issue.state})`)
  .join('\n')}

### Admin Panel Related Issues (${stats.categories.adminPanel || 0} total)
${issues.filter(issue => categorizeIssue(issue).includes('adminPanel'))
  .slice(0, 5)
  .map(issue => `- Issue #${issue.number}: ${issue.title} (${issue.state})`)
  .join('\n')}

### Database Related Issues (${stats.categories.database || 0} total)
${issues.filter(issue => categorizeIssue(issue).includes('database'))
  .slice(0, 5)
  .map(issue => `- Issue #${issue.number}: ${issue.title} (${issue.state})`)
  .join('\n')}

### Frontend/PendScan Issues (${stats.categories.frontend || 0} total)
${issues.filter(issue => categorizeIssue(issue).includes('frontend'))
  .slice(0, 5)
  .map(issue => `- Issue #${issue.number}: ${issue.title} (${issue.state})`)
  .join('\n')}

## Next Steps

1. **Review High Priority Issues**: Focus on critical and high priority items
2. **Integrate with Planning**: Link relevant issues to future development plans
3. **Update Milestones**: Ensure issues are properly categorized by release milestones
4. **Regular Sync**: Run this analysis weekly to stay updated

---

*This report helps integrate GitHub issues with the comprehensive future development planning for the Pend ecosystem.*
`;

  fs.writeFileSync(path.join(BASE_DIR, 'ISSUES_SUMMARY.md'), report);
  return report;
}

// Main execution
function main() {
  console.log('🔍 Starting GitHub issues analysis...');
  
  const issues = loadIssues();
  console.log(`📊 Loaded ${issues.length} issues`);
  
  const stats = organizeIssues(issues);
  console.log('✅ Issues organized successfully');
  
  const report = generateSummaryReport(issues, stats);
  console.log('📝 Summary report generated');
  
  console.log('\n📊 Organization Complete!');
  console.log('\nStats:');
  console.log(`Categories: ${Object.keys(stats.categories).length}`);
  console.log(`Priorities: ${Object.keys(stats.priorities).length}`);
  console.log(`Statuses: ${Object.keys(stats.statuses).length}`);
  console.log(`Milestones: ${Object.keys(stats.milestones).length}`);
  
  console.log('\n📁 Organized files available in:');
  console.log('- organized/by-category/');
  console.log('- organized/by-priority/');
  console.log('- organized/by-status/');
  console.log('- organized/by-milestone/');
  console.log('- ISSUES_SUMMARY.md');
}

if (require.main === module) {
  main();
} 