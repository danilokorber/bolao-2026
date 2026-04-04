# How to Use .claude Directory with Claude Code

## What is .claude?

The `.claude` directory is a special folder that Claude Code automatically reads when you start it in your project. Any files in this directory are automatically included as context for Claude.

## Setup Instructions

### 1. Copy the .claude directory to your project root

```bash
# Navigate to your project directory
cd /path/to/your/worldcup-pool-project

# Copy the .claude directory
cp -r /home/claude/.claude .
```

### 2. Verify the files are there

```bash
ls -la .claude/
# You should see:
# - project_context.md (complete project documentation)
# - V1__initial_schema.sql (database migration)
```

### 3. Start Claude Code

```bash
# In your project root directory
claude-code
```

## What Happens Automatically

When Claude Code starts, it will:
1. ✅ Read all files in `.claude/` directory
2. ✅ Use them as context for all responses
3. ✅ Reference them when generating code
4. ✅ Keep consistency with your project rules

## Example Commands to Use

Once Claude Code is running with the `.claude` context:

### Initial Setup
```
"Create the Quarkus project structure based on the context"
```

### Create Entities
```
"Create all JPA entities as defined in project_context.md"
```

### Create Repositories
```
"Create Panache repositories for all entities"
```

### Create REST APIs
```
"Create REST endpoints for pool management"
```

### Create Services
```
"Create the scoring calculation service based on the business rules"
```

## Files in .claude Directory

### project_context.md
Complete project documentation including:
- Business rules
- Scoring system
- Database schema
- Technology stack
- Implementation phases

### V1__initial_schema.sql
Complete Flyway migration script with:
- All tables
- All constraints
- All indexes
- Comments

## Tips

1. **Don't ask Claude Code to read files** - It does this automatically
2. **Reference the context naturally** - "According to the business rules..." or "Based on the schema..."
3. **Update .claude files** - When requirements change, update files in `.claude/` and restart Claude Code
4. **Keep it organized** - Use clear filenames like `project_context.md`, `api_conventions.md`, etc.

## Alternative: Use .claudeignore

Create a `.claudeignore` file to exclude files from context:

```
node_modules/
target/
.git/
*.log
```

This keeps Claude Code focused on relevant files only.
