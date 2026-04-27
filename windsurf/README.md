# EGOS Windsurf Profile

Configurações sincronizadas do Windsurf via `~/.egos`. Funciona em Linux, WSL2 e Windows.

## Arquivos

| Arquivo | Descrição |
|---------|-----------|
| `settings.json` | Configurações do editor (sem secrets) |
| `mcp.template.json` | Template dos servidores MCP (com `${VAR}` no lugar das chaves) |
| `extensions.list` | IDs das extensões instaladas |
| `install.sh` | Instalador Linux / WSL2 |
| `install.ps1` | Instalador Windows (PowerShell) |
| `.env.local.example` | Exemplo do arquivo de secrets local |
| `.env.local` | **NÃO commitado** — suas chaves reais aqui |

## Instalação em nova máquina

### Linux / WSL2
```bash
git clone git@github.com:enioxt/egos-rules.git ~/.egos
cd ~/.egos
cp windsurf/.env.local.example windsurf/.env.local
nano windsurf/.env.local  # preencha as chaves
bash windsurf/install.sh
```

### Windows (PowerShell como Admin)
```powershell
git clone git@github.com:enioxt/egos-rules.git $env:USERPROFILE\.egos
cd $env:USERPROFILE\.egos
Copy-Item windsurf\.env.local.example windsurf\.env.local
notepad windsurf\.env.local  # preencha as chaves
.\windsurf\install.ps1
```

## Opções de setup no Windows

| Opção | Prós | Contras | Recomendado para |
|-------|------|---------|-----------------|
| **WSL2 + Windsurf** | Idêntico ao Linux, todos os scripts funcionam | Precisa instalar WSL2 | Desenvolvimento ativo |
| **SSH → VPS** | Zero setup, mesmo ambiente | Precisa internet | Sessões rápidas |
| **Windows nativo** | Sem WSL | .sh quebram, Bun instável | Não recomendado |

## .windsurfrules

O arquivo global de regras fica em `~/.egos/.windsurfrules` e é aplicado como symlink em `~/.windsurfrules`.

Contém regras de governança, estilo de código, patterns proibidos e comportamentos esperados do Cascade AI.
