---
name: Hermes Agent — Deep Dive Investigation (2026-04-07)
description: Complete analysis of Hermes Agent ecosystem, why it was proposed, status in EGOS, and deployment roadmap
type: project
---

# HERMES AGENT — DEEP DIVE INVESTIGATION

**Date:** 2026-04-07 | **Context:** Proposed P30/P31, never deployed  
**Why this matters:** Hermes is the missing piece between "always-on execution" (VPS) and "heavy reasoning" (Claude Code)

---

## 🔍 WHAT IS HERMES AGENT?

### Official Definition (from Nous Research)

**Hermes Agent** = Open-source (MIT) autonomous agent framework by Nous Research

**Core capabilities:**
- Lives on your server (Docker, VPS, cloud, local)
- Persistent memory (SQLite + full-text search)
- Auto-creates skills from tasks (YAML-based, reusable)
- Self-evolution: reflects on failures, optimizes itself
- Multi-model: works with Claude, OpenAI, MiniMax, local Hermes-3
- Multi-channel: Telegram, Discord, Slack, WhatsApp, CLI
- No hallucination about capabilities (knows what it can/can't do)

**Key difference from Claude Code:**
| Aspect | Claude Code | Hermes |
|--------|------------|--------|
| Runtime | Session-based (dies when you close) | Always-on (24/7 on VPS) |
| Memory | Context within session | Persistent SQLite |
| Skills | Manual (you write skills) | Auto-creates from tasks |
| Self-improvement | No | GEPA (self-optimizing YAML) |
| Cost model | Pay per session | Pay only when executing |
| Activation | IDE-based | API, CLI, Telegram, etc. |
| Learning | None (stateless) | Learns across runs |

---

## 📊 WHY GROK PROPOSED HERMES (P30-P31)

### The Problem Grok Identified

```
Status quo (2026-03-30):
├─ Enio pays R$550/month (Claude Code)
├─ Enio pays R$100/month (ChatGPT)
├─ VPS Hetzner (R$25-40/month) → SITTING IDLE
│
├─ Workflow: Manual → Claude Code → Manual again
└─ Result: Expensive, manual, session-bound, forgetful
```

### Grok's Hypothesis (from lines 305-450 of conversagrok.md)

**"If you run Hermes 24/7 on your VPS:**
- You pay ALMOST NOTHING extra (VPS already costs R$25/month)
- Hermes handles all the 'always-on' tasks (monitoring, research, log collection)
- Claude Code (R$550) is freed for heavy reasoning
- Learning persists across runs (Hindsight + SQLite)
- You can activate from Telegram/CLI, not just IDE"

**Grok's specific proposal:**
```
P0 (2026-03-31): Deploy Hermes MVP to Hetzner
  - 1 docker-compose (generated lines 778-817)
  - 6 profiles (1:1 with egos agents)
  - GEPA self-improvement enabled
  - Multi-Profiles for agent segregation
  
P1: Test with 5 prompts (the A/B test)
P2: Scale to production (Hindsight sync, full automation)
```

---

## ❌ WHY IT NEVER HAPPENED (Analysis)

### The Gap

**Proposed:** 2026-03-30, 2026-03-31, 2026-04-01, 2026-04-02  
**Deployed:** NEVER

**Why?**
1. **Research mode vs execution mode**
   - Grok was in "exploration" (proposing lots of ideas)
   - Enio was in "filtering" (validating what matters)
   - Hermes was deemed "good but not blocker"

2. **Other priorities won**
   - P32: Guard Brasil v0.2.2 (revenue path)
   - P33: Doc-Drift Shield L1 (governance)
   - P34: Doc-Drift Shield L2-L3 (ongoing)

3. **Uncertainty about ROI**
   - "Is it really worth deploying another agent framework?"
   - "How much does Hermes cost to run?"
   - "Will it actually learn better than stateless Claude?"

4. **RAM constraints on VPS** (discovered today)
   - 15GB total, 7.3GB used, 622MB free
   - Would need cleanup before adding Hermes
   - Chicken-and-egg: "Clean first, then deploy"

---

## 🔗 HERMES vs EGOS ARCHITECTURE

### How Hermes Fits Into EGOS

```
TODAY (P34):
┌─────────────────────────────────────┐
│  Enio (Developer)                   │
└────────────────┬────────────────────┘
                 │
                 ├─→ Claude Code (R$550/mo)     [Heavy reasoning]
                 │   └─ Windsurf IDE [Code editing]
                 │
                 └─→ VPS Hetzner (R$25/mo)      [Idle]
                     ├─ 19 Docker containers
                     ├─ 23 agents (agents.json)
                     ├─ Watchdog (monitoring)
                     └─ Dream cycle (logs)

PROPOSED (with Hermes):
┌─────────────────────────────────────┐
│  Enio (Developer)                   │
└────────────────┬────────────────────┘
                 │
                 ├─→ Claude Code (R$550)        [Heavy reasoning only]
                 │   └─ Windsurf IDE           [Code editing only]
                 │
                 └─→ VPS Hetzner (R$25)         [FULLY UTILIZED]
                     ├─ 19 Docker containers
                     ├─ 23 agents (agents.json)
                     ├─ Watchdog (monitoring) ✅ Already running
                     ├─ Dream cycle (logs)    ✅ Already running
                     ├─ Hermes Agent          ❌ NOT HERE (yet)
                     │   ├─ 6 profiles (egos-kernel, egos-strategy, etc.)
                     │   ├─ SQLite state store
                     │   └─ GEPA self-learning
                     └─ Scheduled tasks
                         ├─ Gem Hunter (Monday 06:00)
                         ├─ Log Harvester (Daily 02:00)
                         └─ Hermes routines (new)
```

### Division of Labor

**Claude Code (Heavy lifting):**
- Architecture decisions
- Complex refactors
- Research + analysis
- Problem solving
- Context synthesis

**Hermes (Routine execution):**
- Monitor services (watchdog already does this)
- Harvest logs (dream-cycle already does this)
- Run scheduled tasks (gem-hunter already does this)
- Execute learned patterns
- Report findings
- **NEW:** Learn from past runs, improve its own skills

**EGOS Kernel (Governance):**
- Define rules (BLUEPRINT, frozen zones)
- Allocate agents
- Monitor cost/benefit
- Governance gates (who can do what)

---

## 📈 HERMES CAPABILITIES RELEVANT TO EGOS

### 1. Multi-Profiles (Critical for EGOS)

```bash
hermes profile create egos-kernel \
  --model claude-3-7-sonnet-20250219 \
  --system-prompt "$(cat BLUEPRINT-EGOS)" \
  --memory-db /data/egos-kernel.sqlite

hermes profile create egos-strategy \
  --model claude-3-7-sonnet-20250219

hermes profile create egos-governance \
  --model claude-3-7-sonnet-20250219

# ... repeat for 6 profiles total
```

**Why this matters:**
- Each profile = isolated agent context
- Different system prompts (governance rules)
- Separate SQLite databases (no cross-contamination)
- Can run in parallel

### 2. Auto-Skill Creation (Self-Evolution)

When you ask Hermes to do something, it:
1. Executes the task
2. Reflects on success/failure
3. **Generates a YAML skill** for future use
4. Persists the skill

Example:
```yaml
# auto-generated skill after first run
name: "Collect Guard Brasil Metrics"
description: "Gather API metrics from Guard Brasil service"
trigger: "collect-metrics"
steps:
  - run: "curl -s http://localhost:3099/metrics | jq '.'"
  - parse: "Extract: calls, errors, latency"
  - store: "Save to /data/metrics-{date}.json"
  - notify: "Send summary to Telegram"
```

**Why this matters:**
- Repetitive tasks become **optimized patterns**
- Learns what works, discards what doesn't
- Reduces token usage (skill YAML < full reasoning)

### 3. Persistent Memory (Hindsight Integration)

```
Hermes SQLite schema:
├─ tasks (id, description, status, created_at)
├─ runs (task_id, output, errors, learning)
├─ skills (name, yaml, success_rate, last_used)
├─ world_facts (category, fact, confidence)
└─ experiences (event, outcome, timestamp)
```

**Hindsight can sync with this:**
- `Retain`: Store new facts from runs
- `Recall`: Look up similar past runs before executing
- `Reflect`: Improve skills based on outcomes

### 4. GEPA Self-Optimization (Experimental)

Hermes can run this loop:
```
1. Task fails
2. Generate hypothesis for why it failed
3. Create YAML decision tree (why failed? how to improve?)
4. Test the improved version
5. Persist the learning
6. Next run uses improved version
```

**From Grok's notes (line 388):**
> "Hermes Agent construindo seu próprio módulo DSPy GEPA 
> (abductive trees + YAML recursive self-improvement)"

---

## 💰 COST ANALYSIS (Hermes MVP)

### Infrastructure Cost
```
Software:           R$ 0/month  (Open-source)
VPS marginal:       R$ 0/month  (Already paying)
Inference cost:
  ├─ Claude 3.7:    Variable (depends on usage)
  ├─ MiniMax-M2.7:  ~R$40/month (flat rate plan)
  └─ Local Hermes-3: R$ 0 (if using local model)

TOTAL MARGINAL:     ~R$0-40/month
```

### Usage Pattern (Estimated)
```
Morning:   Hermes wakes (1 min init, 2KB tokens)
02:00:     Dream cycle harvester (5min, 10KB tokens)
02:30:     Process logs + report (3min, 5KB tokens)
06:00-06:15: Gem Hunter run (15min, 50KB tokens if using Hermes)
Evening:   Idle

DAILY:     ~70KB tokens → ~R$0.10/day on MiniMax
MONTHLY:   ~2MB tokens → ~R$3/month
```

**Comparison:**
| Tool | Cost | Value |
|------|------|-------|
| Claude Code (R$550/mo) | Expensive | Heavy reasoning |
| Hermes (R$0-40/mo) | Cheap | 24/7 execution |
| Together = | ~R$590/mo | Optimal split |

---

## 🏗️ HERMES MVP DEPLOYMENT PLAN

### Phase 1: Prep (1 hour)
- [ ] Free 2-4GB RAM on VPS (clean `/opt/backups/`)
- [ ] Verify VPS has 5GB free RAM total
- [ ] Check Docker/compose versions

### Phase 2: Build (1 hour)
```bash
# SSH to VPS
ssh -i ~/.ssh/hetzner_ed25519 root@204.168.217.125

# Clone Hermes
cd /opt && git clone https://github.com/NousResearch/hermes-agent.git

# Build image
cd hermes-agent && docker build -t hermes:latest .

# Create docker-compose (we have skeleton)
cp hermes-docker-compose.yml docker-compose.yml
```

### Phase 3: Configure (30 min)
```bash
# Create 1st profile
hermes profile create egos-kernel \
  --model claude-3-7-sonnet-20250219 \
  --user-prompt-file /opt/egos/GOVERNANCE.md

# Create .env
cat > .env << EOF
HERMES_MODEL=claude-3-7-sonnet-20250219
HERMES_TELEGRAM_TOKEN=... (from egos-watchdog)
HERMES_SQLITE_PATH=/data/egos-kernel.sqlite
HERMES_LOG_LEVEL=info
EOF
```

### Phase 4: Test (2 hours)
```bash
# Start container
docker-compose up -d

# Wait 30s for startup
sleep 30

# Run test task
hermes task --profile egos-kernel "list /opt/egos/agents"

# Check logs
docker logs hermes | tail -50

# Test Telegram push
# (should send message to your chat_id)
```

### Phase 5: Trial (1 week)
- Run Hermes in production
- Monitor resource usage (CPU, RAM, disk)
- Measure token consumption
- Validate: "Is learning actually happening?"
- Decision: Keep or remove

---

## ⚠️ RISKS & MITIGATIONS

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|-----------|
| OOM crash | High | VPS freezes | Free 2-4GB RAM first |
| Hermes hangs | Medium | Loss of monitoring | Add watchdog for Hermes itself |
| Token overspend | Low | Unexpected costs | Set quotas in .env |
| Skill bloat | Medium | Disk fills | Auto-cleanup old skills (>30 days) |
| Telegram spam | Low | Notification fatigue | Rate-limit alerts |
| Integration bugs | Medium | Agents conflict | Run MVP isolated for 1 week |

---

## 🎯 SUCCESS METRICS (MVP Week)

After deploying Hermes, measure:

**Uptime:**
- [ ] Hermes process uptime > 95% (allow 1 crash max)
- [ ] All profiles responsive

**Learning:**
- [ ] At least 1 auto-generated skill created
- [ ] Skill can be invoked and works

**Cost:**
- [ ] Actual token cost < R$10 for the week
- [ ] No unexpected charges

**Integration:**
- [ ] Telegram alerts arriving (test manually)
- [ ] Log harvester still runs independently

**Performance:**
- [ ] RAM usage < 600MB
- [ ] No CPU spikes
- [ ] Response time < 10s for simple tasks

**Decision Gate:**
```
IF all metrics met:
  → APPROVE for next phase (6 profiles)
ELSE IF minor issues:
  → CONTINUE 1 more week with fixes
ELSE IF critical blocker:
  → REMOVE, try again next quarter
```

---

## 🔗 HOW HERMES CONNECTS TO GEM HUNTER v7

Recall from prior research: **Gem Hunter v7 needs:**
1. ✅ CLI-first (can run via Hermes CLI)
2. ✅ 24/7 scheduling (Hermes runs crons)
3. ✅ Cross-repo analysis (Hermes has access to all /opt/ repos)
4. ✅ Proof-of-work output (Hermes logs everything to SQLite)

**Integration path:**
```
Hermes can execute:
1. Create Gem Hunter skill: `analyze-cross-repo-patterns`
2. Schedule: `0 2 * * * hermes task --profile egos-kernel "analyze-cross-repo-patterns"`
3. Learn: Persist findings to SQLite
4. Report: Push to Telegram when patterns found
5. Improve: Auto-optimize the skill based on results

Gem Hunter becomes a "Hermes job" not a "Claude Code research project"
```

---

## 📋 DECISION MATRIX

**Should we deploy Hermes MVP this week?**

| Factor | Status | Recommendation |
|--------|--------|-----------------|
| **Infrastructure ready?** | ✅ Yes (19 containers stable) | GO |
| **Design documented?** | ✅ Yes (docker-compose skeleton ready) | GO |
| **RAM available?** | ⚠️ No (only 622MB free) | **WAIT 1 day** (clean backups first) |
| **Cost justified?** | ✅ Yes (R$0-40/month marginal) | GO |
| **Risk acceptable?** | ⚠️ Medium (OOM possible) | **MITIGATE** (add swap, monitor) |
| **Time budget?** | ✅ Yes (4-5 hours) | GO |
| **Blocker for P35?** | ❌ No (defer doesn't delay Doc-Drift) | Nice-to-have |

**Verdict:** 🟡 **DEPLOY MVP THIS WEEK** with precautions:
1. Cleanup backups (1 hour) — free 15GB
2. Monitor RAM aggressively (add alerting)
3. Run 1-week trial with go/no-go gate
4. If successful → scale to 6 profiles in P35

---

## 🚀 TIMELINE

```
TODAY (2026-04-07):      VPS audit complete, Hermes plan finalized
TOMORROW (04-08):        Clean backups, prep infrastructure
NEXT 3 DAYS (04-09..11): Deploy Hermes MVP, run basic tests
WEEK OF 04-12:           Trial period (observe + measure)
2026-04-19:              Go/no-go decision meeting
IF GO:                   Scale to 6 profiles, add Hindsight
IF NO-GO:                Document learnings, retry P36
```

---

## 📚 REFERENCES

- Hermes GitHub: https://github.com/NousResearch/hermes-agent
- Docker Hub: https://hub.docker.com/r/nousresearch/hermes
- Grok proposal (2026-03-30): conversagrok.md lines 305-450
- VPS audit: vps_hetzner_complete_infrastructure_map_2026-04-07.md
- CLAUDE.md §23 (GTM-first): Know your ROI before shipping

