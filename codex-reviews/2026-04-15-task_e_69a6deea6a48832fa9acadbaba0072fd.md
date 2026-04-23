---
task_id: task_e_69a6deea6a48832fa9acadbaba0072fd
task_url: https://chatgpt.com/codex/tasks/task_e_69a6deea6a48832fa9acadbaba0072fd
repo: Mar 3 14:27 7 files
submitted: EGOS-Inteligencia • Mar 3 14:27
fetched: 2026-04-15T18:55:23Z
status: FETCHED
files_changed: 7
additions: 361
deletions: 7
prompt: "[READY] Create documentation PR from files"
evaluated_by_claude: false
apply_decision: PENDING
---

# Codex Review — Mar 3 14:27 7 files — 2026-04-15

**Task:** [READY] Create documentation PR from files
**Changes:** +361 -7 across 7 files
**Evaluate against:** `~/.egos/guarani/CODEX_REVIEW_CRITERIA.md`

## ⚠️ DO NOT APPLY WITHOUT CLAUDE EVALUATION
This diff has NOT been reviewed yet. Claude must evaluate each suggestion
against CODEX_REVIEW_CRITERIA.md before any changes are applied.

## Diff

```diff
diff --git a/README.md b/README.md
index f018646b3d59686cd3d2147eaa34e2a88f309ea5..b68d036ebc44241a665a37b56dd19505532eeb00 100644
--- a/README.md
+++ b/README.md
@@ -1,40 +1,46 @@
 # EGOS Inteligência — Plataforma Aberta de Cruzamento de Dados Públicos
 
 <!-- RHO_BADGE --> **Rho Score:** 🟡 0.30 (WARNING) | Contributors: 4 | Commits (30d): 94 | Updated: 2026-03-02 <!-- /RHO_BADGE -->
 
 Idioma: **Português (Brasil)** | [English](#english)
 
 [![Licença: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)
 [![API Status](https://img.shields.io/badge/API-ONLINE-brightgreen)](http://217.216.95.126/health)
 [![Discord Bot](https://img.shields.io/badge/Discord-EGOS%20Intelig%C3%AAncia-7289da)](https://discord.gg/egos)
 [![Telegram Bot](https://img.shields.io/badge/Telegram-@EGOSin__bot-26A5E4)](https://t.me/EGOSin_bot)
 
 > **Em uma frase:** O EGOS Inteligência conecta dados públicos do Brasil (empresas, políticos, contratos, sanções, doações eleitorais) em um grafo interativo que mostra quem se relaciona com quem.
 
 Site: [inteligencia.egos.ia.br](https://inteligencia.egos.ia.br) | Ecossistema: [EGOS](https://egos.ia.br) | Comunidade: [@ethikin](https://t.me/ethikin)
 
+📚 **Índice de documentação:** [docs/README.md](docs/README.md)
+
+📈 **Análise de escala de stack (Python/Go/Node):** [docs/analysis/STACK_SCALING_DECISION_2026-03.md](docs/analysis/STACK_SCALING_DECISION_2026-03.md)
+
+🛡️ **Plano de não repúdio (Mycelium Audit Trail):** [docs/analysis/MYCELIUM_AUDIT_TRAIL_2026-03.md](docs/analysis/MYCELIUM_AUDIT_TRAIL_2026-03.md)
+
 ---
 
 ## Origem e Diferenças
 
 Este projeto é um **fork** do [World-Open-Graph/br-acc](https://github.com/World-Open-Graph/br-acc), uma infraestrutura open-source para dados públicos brasileiros em grafo.
 
 O EGOS Inteligência diverge significativamente do upstream:
 
 | Aspecto | Upstream (br-acc) | EGOS Inteligência |
 |---|---|---|
 | **Idioma** | Inglês | Português-BR nativo |
 | **Interface** | Desktop-only, requer login | Mobile-first, público, chatbot AI |
 | **Dados carregados** | Demo/seed | 278k nós + 53.6M empresas (ETL em andamento) |
 | **Bots AI** | Nenhum | Discord + Telegram (14 ferramentas OSINT) |
 | **Investigações** | Não | Upload, fork, compartilhamento público |
 | **Relatórios** | Não | 11 relatórios publicados (ex: Patense R$217M BNDES) |
 | **Infraestrutura** | Local/demo | Contabo VPS (12 vCPU, 48GB RAM) + Redis |
 | **LGPD** | Parcial | CPF bloqueado em todo o sistema, masking middleware |
 | **Fontes planejadas** | 13 | 79 fontes no roadmap |
 | **Algoritmos** | Básico | PageRank, Benford, HHI, Community Detection (roadmap) |
 | **Ecossistema** | Standalone | Integrado ao [EGOS Framework](https://egos.ia.br) (24 agentes AI) |
 
 Mantemos rastreamento do upstream e contribuímos PRs quando aplicável.
 
 ---
diff --git a/docs/README.md b/docs/README.md
new file mode 100644
index 0000000000000000000000000000000000000000..7dc592479a808dbb670d64d26f735e9bbc1a182b
--- /dev/null
+++ b/docs/README.md
@@ -0,0 +1,49 @@
+# Documentação do EGOS Inteligência
+
+Este diretório centraliza documentação técnica, operacional, legal e material de demonstração do projeto.
+
+## Navegação rápida
+
+### Governança e operação
+- [Política de atualização diária](DAILY_UPDATE_POLICY.md)
+- [Lições aprendidas](LESSONS_LEARNED.md)
+- [Governança de PR de IA](ai-pr-governor.md)
+
+### Dados e ETL
+- [Fontes de dados (visão geral)](data-sources.md)
+- [Contrato de onboarding de fontes](source_onboarding_contract.md)
+- [Registro de fontes (CSV)](source_registry_br_v1.csv)
+- [Contrato do dataset demo](demo/dataset-contract.md)
+
+### Release pública
+- [Checklist de release público](release/public_repo_release_checklist.md)
+- [Runbook de release](release/release_runbook.md)
+- [Política de release](release/release_policy.md)
+- [Taxonomia de labels](release/label_taxonomy.md)
+- [Matriz de endpoints públicos](release/public_endpoint_matrix.md)
+- [Matriz de boundary público (CSV)](release/public_boundary_matrix.csv)
+
+### Compliance e jurídico
+- [Índice legal (EN)](legal/legal-index.md)
+- [Pacote público de compliance](legal/public-compliance-pack.md)
+- [Índice legal (PT-BR)](pt-BR/legal-index.md)
+
+### Documentação em português
+- [README (PT-BR)](pt-BR/README.md)
+- [Contribuição (PT-BR)](pt-BR/CONTRIBUTING.md)
+- [FAQ (PT-BR)](pt-BR/FAQ.md)
+- [Download de dados (PT-BR)](pt-BR/DOWNLOAD_DADOS.md)
+
+### Relatórios e análises
+- [Relatórios](reports/)
+- [Análises](analysis/)
+- [Decisão de stack e escala (Python/Go/Node)](analysis/STACK_SCALING_DECISION_2026-03.md)
+- [Plano Mycelium Audit Trail (não repúdio)](analysis/MYCELIUM_AUDIT_TRAIL_2026-03.md)
+- [Showcase](showcase/)
+- [Planos](plans/)
+
+## Convenções
+
+- Sempre prefira Markdown para documentação textual.
+- Mantenha links relativos para funcionar no GitHub e em clones locais.
+- Ao adicionar arquivos novos, atualize este índice para manter descoberta rápida.
diff --git a/docs/analysis/MYCELIUM_AUDIT_TRAIL_2026-03.md b/docs/analysis/MYCELIUM_AUDIT_TRAIL_2026-03.md
new file mode 100644
index 0000000000000000000000000000000000000000..e426c53c540c3d6dd71b9d2d5b72785d3c32554a
--- /dev/null
+++ b/docs/analysis/MYCELIUM_AUDIT_TRAIL_2026-03.md
@@ -0,0 +1,63 @@
+# Mycelium Audit Trail (Não Repúdio) — Plano de Evolução
+
+## Problema
+
+Hoje o Mycelium/ETL já registra linhagem operacional (`IngestionRun`), mas falta o nível de prova técnica de não repúdio para contestação futura (origem + integridade do dado bruto).
+
+## Objetivo
+
+Adicionar uma camada de auditoria que permita responder:
+- de onde veio o dado (`source_url`),
+- quando foi verificado (`verified_at`),
+- qual o hash da linha bruta (`raw_line_hash`),
+- e um fingerprint da fonte/coleta (`source_fingerprint`).
+
+## Decisões de arquitetura
+
+### 1) Metadados de auditoria por registro
+No ETL, cada registro transformado passa a poder carregar:
+- `raw_line_hash` (SHA-256 da linha canônica),
+- `source_url`,
+- `source_method` (api, bulk_download, scraping),
+- `verified_at`,
+- `audit_status` (`verified`),
+- `source_fingerprint`.
+
+### 2) Nó de proveniência no grafo (fase seguinte)
+Para evitar redundância extrema em 141M nós, a próxima fase deve materializar `(:DataSource)` e relacionamentos de proveniência (`[:PROVENANCE]`) para entidades críticas.
+
+### 3) Migração legada (sem retrabalho total)
+- Marcar dados atuais como `audit_status = "legacy"` onde ainda não houver hash.
+- Reprocessar com prioridade alta fontes críticas (sanções e CNPJ/sócios).
+- Usar atualização incremental: conforme ETLs rodarem, os nós legados passam para `verified`.
+
+## Entregas desta PR
+
+- Base técnica adicionada no ETL para cálculo determinístico de hash e montagem de campos de auditoria (`bracc_etl.provenance`).
+- Método utilitário no `Pipeline` base para padronizar uso em pipelines novos e antigos.
+- Testes unitários de estabilidade do hash e dos campos de auditoria.
+
+## Exemplo de payload
+
+```json
+{
+  "name": "EMPRESA X",
+  "audit": {
+    "source_url": "https://dados.exemplo.gov.br/arquivo.csv",
+    "raw_line_hash": "...",
+    "source_method": "bulk_download",
+    "verified_at": "2026-03-03T10:00:00Z",
+    "audit_status": "verified"
+  }
+}
+```
+
+## Script de backfill sugerido (fase legada)
+
+```cypher
+MATCH (n)
+WHERE n.audit_status IS NULL
+SET n.audit_status = 'legacy';
+```
+
+> Observação: o relacionamento `[:PROVENANCE]` e `:DataSource` fica como próxima etapa de modelagem/rollout para não expandir escopo de forma arriscada.
diff --git a/docs/analysis/STACK_SCALING_DECISION_2026-03.md b/docs/analysis/STACK_SCALING_DECISION_2026-03.md
new file mode 100644
index 0000000000000000000000000000000000000000..d849d872f4b42514aa5fe423db2f158c9034a180
--- /dev/null
+++ b/docs/analysis/STACK_SCALING_DECISION_2026-03.md
@@ -0,0 +1,120 @@
+# Python vs Go vs Node.js para escalar o EGOS (2026-03)
+
+## Resposta curta
+
+- **Não migrar o core para Go ou Node.js agora.**
+- **Manter Python** no backend e ETL, e atacar primeiro os gargalos reais: Neo4j, política de consumo de APIs externas, cache e fila.
+- **Extrair para Go apenas hotspots medidos** (se houver componentes com pressão de throughput/CPU muito alta).
+- **Manter Node.js** onde já faz sentido (bots/eventos e frontend).
+
+## Quais APIs/integrações estão realmente no stack hoje
+
+### No backend/chat tools
+- Portal da Transparência (`api.portaldatransparencia.gov.br`) em tools de transparência.
+- TransfereGov (`api.transferegov.gestao.gov.br`) em tools de transferências.
+- Brave Search API (quando `BRAVE_API_KEY` existe), com fallback para DuckDuckGo HTML.
+
+### Em scripts/downloader
+- TSE (downloads por URL de dataset público).
+- OpenSanctions (download de datasets JSON).
+- ICIJ Offshore Leaks.
+- Câmara dos Deputados (arquivos CSV de dados abertos).
+- Portais com bloqueio/captcha já estão documentados com estratégia de download manual.
+
+## Limites já implementados
+
+### Entrada no EGOS API
+- Rate limit padrão para anônimos: `60/minute`.
+- Limite para autenticados configurável (`rate_limit_auth`, default `300/minute`).
+- Chave de rate limit por usuário JWT (quando houver token) com fallback para IP.
+
+### Respeito à fonte externa
+- Script do DataJud com `RATE_LIMIT_SEC=1` (1 requisição/segundo) por padrão.
+- Download batch com retries/timeouts no script geral de datasets.
+- Vários scripts ETL já tratam `429`/retentativas com backoff.
+
+
+## Inventário validado no código (Go/Python/Node/LLMs)
+
+### Linguagens/stack em uso
+- **Python** no core de API e ETL (FastAPI, pipelines e integrações de dados).
+- **Node.js** já está no ecossistema para bots e frontend (coerente com o posicionamento do projeto).
+- **Go** não aparece como stack produtiva atual no repositório.
+
+### LLMs e roteamento
+- Configuração expõe `openrouter_api_key` e `ai_model`, indicando uso de roteamento de modelo via OpenRouter no backend.
+- O risco de custo de LLM é real para MVP e precisa de orçamento/guardrails operacionais.
+
+### Limites observáveis hoje
+- Entrada da API pública: `rate_limit_anon=60/minute` e `rate_limit_auth=300/minute` (padrão).
+- Rate limit por usuário autenticado (JWT) com fallback para IP.
+- DataJud downloader com `RATE_LIMIT_SEC=1` e espera explícita entre requisições.
+- Script de download geral usa retry e timeout em `aria2c`, mas sem orçamento unificado por provedor.
+
+### Gap atual (o que ainda falta formalizar)
+- Não há matriz versionada de orçamento por fonte (`qps_max`, `req/dia`, janela de pausa).
+- Não há documento único com orçamento de custo de LLM por ferramenta/ambiente.
+
+## Onde está o risco real (e por que trocar linguagem não resolve sozinho)
+
+1. **Overload em APIs governamentais**
+   - Risco técnico e de compliance existe se o consumo não tiver orçamento por fonte.
+   - Mudar Python para Go não muda a necessidade de throttling, janelas de coleta e idempotência.
+
+2. **Custo de LLM no MVP**
+   - Existe risco de custo variável por volume e ferramentas dependentes de API externa.
+   - O controle é de produto e operação: budget mensal, fallback de modelo e roteamento por tipo de pergunta.
+
+3. **Latência de query no banco de grafo**
+   - O gargalo de escala tende a estar em modelagem/índice/query no Neo4j e cache hit-rate, não na linguagem da API.
+
+## Como contornar com menor risco
+
+### 1) Orçamento por fonte (obrigatório)
+- Definir **QPS por host** (ex.: 0.2–1 req/s em fontes sensíveis).
+- Definir **limite diário** por conector.
+- Aplicar **token bucket** por provedor e trava global.
+
+### 2) Fila e workers para ingestão
+- Colocar coleta/enriquecimento em jobs assíncronos (não no caminho síncrono do usuário).
+- Adicionar DLQ, retries com jitter e idempotência por `run_id`.
+
+### 3) Circuit breaker por provedor
+- Ao detectar 429/5xx em sequência, pausar automaticamente o conector por janela.
+- Retomar de forma gradual para evitar rajada de volta.
+
+### 4) Priorizar dumps oficiais e incremental
+- Preferir dumps/arquivos oficiais em lote quando existir.
+- Rodar apenas delta incremental por data/ID.
+
+### 5) Governança de LLM
+- Budget mensal por ambiente (dev/staging/prod).
+- Política de fallback para modelo mais barato e cache de respostas repetitivas.
+- Métrica de custo por ferramenta e por tipo de pergunta.
+
+## Previsão prática de evolução (90 dias)
+
+### Fase 1 (0–30 dias)
+- Matriz de orçamento por fonte (`qps_max`, `requests_dia`, `janela`), versãoada em repositório.
+- Métricas mínimas: erro 429/5xx por fonte, latência p95 por endpoint, hit-rate de cache.
+
+### Fase 2 (31–60 dias)
+- Circuit breaker + fila para conectores mais sensíveis.
+- SLO para API pública (disponibilidade e p95) e regra de degrade controlado.
+
+### Fase 3 (61–90 dias)
+- Benchmark de hotspots reais.
+- Somente aqui decidir extração cirúrgica para Go (se algum componente continuar gargalo).
+
+## Critério objetivo para considerar Go
+
+Migrar um componente isolado para Go **apenas se**:
+- p95/p99 seguir fora de alvo após otimização de query+cache+fila;
+- componente for claramente CPU-bound ou de altíssimo fan-out;
+- houver contrato de interface estável para separar sem reescrever domínio inteiro.
+
+## Conclusão
+
+- **Python continua a melhor base do EGOS hoje** pelo ecossistema de dados/ETL e maturidade já existente no projeto.
+- **Node.js permanece adequado para bots/eventos/frontend**.
+- **Escala segura depende mais de política de consumo externo + arquitetura operacional** do que de troca de linguagem.
diff --git a/etl/src/bracc_etl/base.py b/etl/src/bracc_etl/base.py
index 2309a6a18cc814a0cc7724e9d09f08f854b8ae54..da1c6a800d75e8c21f9f21683a4669d811827b60 100644
--- a/etl/src/bracc_etl/base.py
+++ b/etl/src/bracc_etl/base.py
@@ -1,32 +1,34 @@
 import logging
 import os
 from abc import ABC, abstractmethod
 from datetime import UTC, datetime
 
 from neo4j import Driver
 
+from bracc_etl.provenance import build_audit_fields
+
 logger = logging.getLogger(__name__)
 
 
 class Pipeline(ABC):
     """Base class for all ETL pipelines."""
 
     name: str
     source_id: str
 
     def __init__(
         self,
         driver: Driver,
         data_dir: str = "./data",
         limit: int | None = None,
         chunk_size: int = 50_000,
         neo4j_database: str | None = None,
     ) -> None:
         self.driver = driver
         self.data_dir = data_dir
         self.limit = limit
         self.chunk_size = chunk_size
         self.neo4j_database = neo4j_database or os.getenv("NEO4J_DATABASE", "neo4j")
         source_key = getattr(self, "source_id", getattr(self, "name", "unknown_source"))
         self.run_id = f"{source_key}_{datetime.now(tz=UTC).strftime('%Y%m%d%H%M%S')}"
 
@@ -48,50 +50,67 @@ class Pipeline(ABC):
         self._upsert_ingestion_run(status="running", started_at=started_at)
         try:
             logger.info("[%s] Starting extraction...", self.name)
             self.extract()
             logger.info("[%s] Starting transformation...", self.name)
             self.transform()
             logger.info("[%s] Starting load...", self.name)
             self.load()
             finished_at = datetime.now(tz=UTC).strftime("%Y-%m-%dT%H:%M:%SZ")
             self._upsert_ingestion_run(
                 status="loaded",
                 started_at=started_at,
                 finished_at=finished_at,
             )
             logger.info("[%s] Pipeline complete.", self.name)
         except Exception as exc:
             finished_at = datetime.now(tz=UTC).strftime("%Y-%m-%dT%H:%M:%SZ")
             self._upsert_ingestion_run(
                 status="quality_fail",
                 started_at=started_at,
                 finished_at=finished_at,
                 error=str(exc)[:1000],
             )
             raise
 
+
+    def build_audit_fields(
+        self,
+        *,
+        raw_row: dict[str, object],
+        source_url: str,
+        method: str,
+        collected_at: str | None = None,
+    ) -> dict[str, str]:
+        """Create standardized provenance metadata for ETL outputs."""
+        return build_audit_fields(
+            raw_row=raw_row,
+            source_url=source_url,
+            method=method,
+            collected_at=collected_at,
+        )
+
     def _upsert_ingestion_run(
         self,
         *,
         status: str,
         started_at: str | None = None,
         finished_at: str | None = None,
         error: str | None = None,
     ) -> None:
         """Persist ingestion run state for operational traceability."""
         source_id = getattr(self, "source_id", getattr(self, "name", "unknown_source"))
         query = (
             "MERGE (r:IngestionRun {run_id: $run_id}) "
             "SET r.source_id = $source_id, "
             "    r.status = $status, "
             "    r.started_at = coalesce($started_at, r.started_at), "
             "    r.finished_at = coalesce($finished_at, r.finished_at), "
             "    r.error = coalesce($error, r.error), "
             "    r.rows_in = coalesce(r.rows_in, 0), "
             "    r.rows_loaded = coalesce(r.rows_loaded, 0)"
         )
         run_id = getattr(self, "run_id", f"{source_id}_manual")
         params = {
             "run_id": run_id,
             "source_id": source_id,
             "status": status,
diff --git a/etl/src/bracc_etl/provenance.py b/etl/src/bracc_etl/provenance.py
new file mode 100644
index 0000000000000000000000000000000000000000..bef6e9043f97cee14d38adb64629de90e0e7a217
--- /dev/null
+++ b/etl/src/bracc_etl/provenance.py
@@ -0,0 +1,63 @@
+"""Helpers for provenance/non-repudiation metadata in ETL pipelines."""
+
+from __future__ import annotations
+
+from datetime import UTC, datetime
+from decimal import Decimal
+import hashlib
+import json
+from typing import Any
+
+
+def _normalize(value: Any) -> Any:
+    """Normalize values into a deterministic JSON-serializable structure."""
+    if isinstance(value, dict):
+        return {str(k): _normalize(v) for k, v in sorted(value.items(), key=lambda item: str(item[0]))}
+    if isinstance(value, list | tuple):
+        return [_normalize(v) for v in value]
+    if isinstance(value, datetime):
+        return value.astimezone(UTC).isoformat().replace("+00:00", "Z")
+    if isinstance(value, Decimal):
+        return str(value)
+    return value
+
+
+def canonical_row_json(row: dict[str, Any]) -> str:
+    """Return stable JSON representation for hashing raw rows."""
+    normalized = _normalize(row)
+    return json.dumps(normalized, ensure_ascii=False, sort_keys=True, separators=(",", ":"))
+
+
+def sha256_text(value: str) -> str:
+    """Return hex SHA-256 for a text value."""
+    return hashlib.sha256(value.encode("utf-8")).hexdigest()
+
+
+def raw_row_hash(row: dict[str, Any]) -> str:
+    """Compute a non-repudiation hash for a raw row payload."""
+    return sha256_text(canonical_row_json(row))
+
+
+def source_fingerprint(source_url: str, method: str, collected_at: str) -> str:
+    """Compute deterministic fingerprint for a data source snapshot."""
+    payload = f"{source_url.strip()}|{method.strip()}|{collected_at.strip()}"
+    return sha256_text(payload)
+
+
+def build_audit_fields(
+    *,
+    raw_row: dict[str, Any],
+    source_url: str,
+    method: str,
+    collected_at: str | None = None,
+) -> dict[str, str]:
+    """Build audit metadata to attach to transformed nodes/relationships."""
+    verified_at = collected_at or datetime.now(tz=UTC).strftime("%Y-%m-%dT%H:%M:%SZ")
+    return {
+        "raw_line_hash": raw_row_hash(raw_row),
+        "source_url": source_url.strip(),
+        "source_method": method.strip() or "unknown",
+        "verified_at": verified_at,
+        "audit_status": "verified",
+        "source_fingerprint": source_fingerprint(source_url, method, verified_at),
+    }
diff --git a/etl/tests/test_provenance.py b/etl/tests/test_provenance.py
new file mode 100644
index 0000000000000000000000000000000000000000..271d4c0782143fb4e9d3249efd087f9adabb6e8b
--- /dev/null
+++ b/etl/tests/test_provenance.py
@@ -0,0 +1,34 @@
+from datetime import datetime
+
+from bracc_etl.provenance import build_audit_fields, raw_row_hash
+
+
+def test_raw_row_hash_is_stable_for_key_order() -> None:
+    row_a = {"b": 2, "a": "x"}
+    row_b = {"a": "x", "b": 2}
+    assert raw_row_hash(row_a) == raw_row_hash(row_b)
+
+
+def test_build_audit_fields_contains_expected_metadata() -> None:
+    fields = build_audit_fields(
+        raw_row={"id": 10, "name": "Empresa X"},
+        source_url="https://dados.exemplo.gov.br/arquivo.csv",
+        method="api",
+        collected_at="2026-03-03T10:00:00Z",
+    )
+
+    assert fields["audit_status"] == "verified"
+    assert fields["source_url"] == "https://dados.exemplo.gov.br/arquivo.csv"
+    assert fields["source_method"] == "api"
+    assert fields["verified_at"] == "2026-03-03T10:00:00Z"
+    assert len(fields["raw_line_hash"]) == 64
+    assert len(fields["source_fingerprint"]) == 64
+
+
+def test_build_audit_fields_uses_current_time_when_missing_collected_at() -> None:
+    fields = build_audit_fields(
+        raw_row={"x": 1},
+        source_url="https://x",
+        method="bulk_download",
+    )
+    datetime.fromisoformat(fields["verified_at"].replace("Z", "+00:00"))
```
