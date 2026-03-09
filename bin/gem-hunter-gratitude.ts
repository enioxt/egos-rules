import { readFileSync, existsSync, appendFileSync } from "fs";
import { join } from "path";

/**
 * EGOS Open Source Gratitude Automator
 * Parses a given Gem Hunter report, extracts GitHub repositories, 
 * automatically stars them (if GITHUB_TOKEN is available), and 
 * appends them to the EGOS public gratitude log.
 */

const ROOT_DIR = join(import.meta.dir, "../../egos-lab");
const GRATITUDE_LOG = join(ROOT_DIR, "docs/OPEN_SOURCE_GRATITUDE.md");

async function starRepository(owner: string, repo: string, token: string): Promise<boolean> {
    try {
        const response = await fetch(`https://api.github.com/user/starred/${owner}/${repo}`, {
            method: "PUT",
            headers: {
                "Authorization": `Bearer ${token}`,
                "Accept": "application/vnd.github.v3+json",
                "X-GitHub-Api-Version": "2022-11-28"
            }
        });
        return response.ok || response.status === 304; // 204 No Content == Success, 304 == Already starred
    } catch (e) {
        return false;
    }
}

async function run() {
    console.log("🙏 EGOS Open Source Gratitude Engine");

    const reportPath = process.argv[2];
    if (!reportPath || !existsSync(reportPath)) {
        console.error("❌ Usage: bun gem-hunter-gratitude.ts <path-to-markdown-report>");
        process.exit(1);
    }

    const githubToken = process.env.GITHUB_TOKEN;
    if (!githubToken) {
        console.warn("⚠️  GITHUB_TOKEN not found. Repositories will be logged but not automatically starred.");
    }

    // Ensure gratitude log exists
    if (!existsSync(GRATITUDE_LOG)) {
        appendFileSync(GRATITUDE_LOG, "# 🙏 EGOS Open Source Gratitude Log\n\n> \"Reconhecer, agradecer, colaborar com o que for necessário, nos colocar a disposição. Esta é a regra de ouro do EGOS.\"\n\nThis document automatically tracks and acknowledges the brilliant open-source projects discovered by our **Gem Hunter AI** that inspire and power our ecosystem.\n\n---\n\n");
    }

    const reportContent = readFileSync(reportPath, "utf-8");
    const githubRegex = /github\.com\/([a-zA-Z0-9_-]+)\/([a-zA-Z0-9_.-]+)(?:\/|\s|\)|$)/g;

    const foundRepos = new Set<string>();
    let match;

    while ((match = githubRegex.exec(reportContent)) !== null) {
        // match[1] is owner, match[2] is repo
        const fullName = `${match[1]}/${match[2]}`.replace(/\.git$/, '');
        foundRepos.add(fullName);
    }

    if (foundRepos.size === 0) {
        console.log("ℹ️  No GitHub repositories found in the report to acknowledge.");
        return;
    }

    console.log(`🔍 Found ${foundRepos.size} projects to acknowledge...`);
    const dateStr = new Date().toISOString().split('T')[0];
    let newLogEntries = `\n### 🌟 Gems Discovered on ${dateStr}\n`;
    let starredCount = 0;

    for (const repoFullName of foundRepos) {
        const [owner, repo] = repoFullName.split("/");

        let starred = false;
        if (githubToken) {
            starred = await starRepository(owner, repo, githubToken);
            if (starred) {
                console.log(`   ⭐ Starred: ${repoFullName}`);
                starredCount++;
            } else {
                console.log(`   ❌ Failed to star: ${repoFullName} (Check token scopes)`);
            }
        }

        newLogEntries += `- [${repoFullName}](https://github.com/${repoFullName}) — Discovered by Gem Hunter.\n`;
    }

    appendFileSync(GRATITUDE_LOG, newLogEntries);
    console.log(`\n✅ Gratitude process complete. Starred ${starredCount} projects.`);
    console.log(`📄 Appended to: ${GRATITUDE_LOG}`);
}

run().catch(console.error);
