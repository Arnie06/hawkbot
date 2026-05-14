# Project Context
This file guides Codex during automated PR code reviews.

## Review guidelines
- Flag any console.log or debugging statements left in production code.
- Treat missing authorization or validation middleware on new routes as a P1 issue.
- Ensure all new utility functions include clear TypeScript types.
- Flag spelling typos or poorly formatted variables as minor P3 issues.
