# Plan: Weave STAMPED principles into the book

**Status:** draft for review — nothing has been edited in the book yet.
**Branch:** `enh-stamped`
**Owner:** Yaroslav (with Russ as author-of-record on the book).
**Preprint to cite:** *STAMPED principles for reproducible research objects*,
Macdonald et al., 2026, [doi:10.31222/osf.io/f3h82_v1](https://doi.org/10.31222/osf.io/f3h82_v1)
(canonical BibTeX in §10).
**Companion artifact to reference:** interactive checklist at
<https://checklist.stamped-principles.org/>.
**Paper sources / verification base:** `/home/yoh/proj/stamped-principles/`
(paper under `stamped-paper/`, schema under `stamped-principles-schema/`,
checklist schema under `stamped-checklist-schema/`).

> How to review: leave comments inline (any lines) or add a `> yoh:` /
> `> russ:` block under a section. Sections labelled **[decision needed]**
> block the next step.
>
> **Revision status (2026-07-08):** Decisions received on all five §8
> questions. §4/§7/§8/§9 updated to reflect those decisions; the STAMPED
> preprint's canonical BibTeX (via `doiref`) is captured in §10. Ready
> for Russ's pass or for execution to begin.

---

## 1. Motivation

STAMPED formalises seven principles (**S**elf-containment, **T**racking,
**A**ctionability, **M**odularity, **P**ortability, **E**phemerality,
**D**istributability) for how research objects — code + data + environment +
provenance — ought to be structured and managed so that others can re-execute
and extend them.

The paper explicitly positions STAMPED as the **operational-layer companion to
FAIR**: FAIR is discovery/governance-oriented; STAMPED covers day-to-day
practices. The book already teaches most of the underlying practices, cites
FAIR / FAIR4RS / WCI-FW, but never names or attributes them as STAMPED.

**Goal of the integration:** give readers the vocabulary and the checklist
they need to self-assess and communicate operational maturity — without
duplicating existing content and without rewriting chapters.

---

## 2. Baseline: what the book already covers

### Cited frameworks

| Framework                                | Where                                   | Citation                                |
|------------------------------------------|-----------------------------------------|-----------------------------------------|
| FAIR (data)                              | `book/data_management.md:11–47`         | `[@Wilkinson:2016aa]`                   |
| FAIR4RS (software)                       | `book/sharing.md` (cross-refs)          | `[@Barker:2022aa]`                      |
| FAIR for workflows (WCI-FW)              | `book/workflows.md:34–47` (8-item list) | `[@Wilkinson:2025aa; @Visser:2023aa]`   |
| Reproducibility terminology (Turing Way) | `book/introduction.md:132–143`          | `[@book.the-turing-way.org]`            |
| Software citation principles             | `book/sharing.md:68–75`                 | `[@Smith:2016aa]`                       |
| DataLad                                  | `book/data_management.md:956`           | `[@Halchenko:2021aa]` (added on `main`) |

### Taught implicitly, not attributed to any principle framework

| Practice                                                 | Where                                                             | STAMPED principle it exemplifies |
|----------------------------------------------------------|-------------------------------------------------------------------|----------------------------------|
| BIDS layout / subdatasets                                | `book/project_organization.md:129–141`                            | Modularity, Self-containment     |
| Traceability & logging in workflows                      | `book/workflows.md:25`                                            | Tracking, Actionability          |
| Containers (Docker/Apptainer) as reproducibility posture | `book/project_organization.md:447–458`; `book/sharing.md:312–315` | Portability, Ephemerality        |
| Environment pinning (`uv.lock`, Docker)                  | `book/sharing.md:312+`; `book/project_organization.md`            | Portability, Distributability    |
| DataLad-based provenance                                 | `book/data_management.md:954–1000+`                               | Tracking                         |
| Zenodo / Software Heritage archiving                     | `book/sharing.md` (PIDs section)                                  | Distributability                 |

**No mentions of STAMPED anywhere in the book.**

---

## 3. Guiding constraints for the edits

1. **Complement, don't duplicate.** STAMPED enters at two anchor points
   (per §8.4): a short framing paragraph in `book/introduction.md` and a
   deeper subsection right after FAIR in `book/data_management.md`. Not
   a new chapter.
2. **Attach at existing seams.** Every principle maps 1:1 to a chapter that
   already teaches the practice. No new headings unless necessary.
3. **Push readers to the checklist** as the actionable artifact rather than
   reproducing normative text in prose. Link
   <https://checklist.stamped-principles.org/> and reference specific
   `must/NNN` / `should/NNN` IDs where useful.
4. **One PR, multiple reviewable commits** (per §7 / §8 responses) so
   Russ sees the whole solution but can drop or request changes to
   individual pieces.
5. **Follow the book's existing BibTeX convention** (`Author:YEARaa`), not
   the STAMPED paper's own natbib style (`author_word_year`).
6. **Preserve Russ's voice.** Insertions are short, prose-style, and match
   surrounding tone. No sidebars/callouts unless approved in Phase 3.

---

## 4. Concrete per-chapter edit plan

### Phase 1 — Anchor + primary attribution

Goal: one PR, small, review-friendly, no per-chapter surgery yet.

| File                      | Location                                         | Edit                                                                                                                                                                                                                                                                       |
|---------------------------|--------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `book/references.bib`     | append                                           | Add `@misc{Macdonald:2026aa, ...}` for the STAMPED preprint (DOI `10.31222/osf.io/f3h82_v1`). Full author list: Macdonald, Baker, To, Halchenko. Canonical BibTeX (from `doiref`) captured verbatim in §10; adjust key + fields to match BibDesk convention before commit. |
| `book/introduction.md`    | near reproducibility crisis section (~line 148)  | **Primary framing spot (per §8.4).** Short paragraph: FAIR is discovery-oriented; STAMPED is the operational companion — list the 7 principles by name, forward to `book/data_management.md` for deeper coverage. Cite `[@Macdonald:2026aa]`.                              |
| `book/data_management.md` | new subsection right after FAIR (~line 47)       | **Deep coverage (per §8.4)**, referenced from the introduction. ~2 short paragraphs: 7 principles in one sentence each, graduated MUST/SHOULD/MAY structure, link to `checklist.stamped-principles.org`, brief COI disclosure per §8.5. Cite `[@Macdonald:2026aa]`.        |
| `book/workflows.md`       | inside "FAIR-inspired practices" list (~line 34) | Single sentence noting each listed practice is also a STAMPED requirement (Actionability, Portability, Distributability), one line pointer.                                                                                                                                |


### Phase 2 — Per-principle attachment points

Small (1–3 sentence) insertions at natural seams. Could be one PR or split
per-chapter.

| Principle            | Chapter / section it attaches to                                                                                         | Proposed edit                                                                                                                                                                                                    |
|----------------------|--------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **S**elf-containment | `book/project_organization.md` (project-layout sections; BIDS)                                                           | Name the "everything under one root" practice as STAMPED-S.                                                                                                                                                      |
| **T**racking         | `book/data_management.md:954+` (DataLad section)                                                                         | One sentence: content-addressed VCS + code-driven provenance = STAMPED-T; DataLad exemplifies it.                                                                                                                |
| **A**ctionability    | `book/workflows.md` (executable pipelines); `book/sharing.md` §CITATION.cff / codemeta.json                              | Frame as "executable specifications, not documentation (although with AI might become such in some cases)" = STAMPED-A.                                                                                          |
| **M**odularity       | `book/project_organization.md:129–141` (BIDS, subdatasets, code separately as might be different life cycle)             | Name the practice as STAMPED-M; note per-module license check.                                                                                                                                                   |
| **P**ortability      | `book/project_organization.md:447–458` (containers); `book/HPC.md` (env modules); `book/sharing.md:312` (Docker/uv.lock) | STAMPED-P: env explicit + version-controlled + not depending on undocumented host state.                                                                                                                         |
| **E**phemerality     | `book/HPC.md`; `book/workflows.md` (CI re-runs; runs on HPC, greatly assists reproducibility!)                           | Reframe per §8.3 (git-independent): "stage inputs + code in a temporary location and run there — don't run in-place." Call out HPC per-job scratch dirs as an existing exemplar of STAMPED-E; CI runs similarly. |
| **D**istributability | `book/sharing.md` (Zenodo, Software Heritage, container hubs, wide range of portals supported by git-annex/DataLad)      | STAMPED-D: all referenced modules persistently retrievable; each has resolvable license.                                                                                                                         |

### Phase 3 — Pedagogical extension (in scope per §8.2; **separate commit**)

- **Concise mapping table** in `book/extras.md`: book chapters ↔ STAMPED
  principles ↔ representative checklist items. Kept small; not a full
  duplication of `checklist.stamped-principles.org`. Lands in its own
  commit within the same PR (per §8.2).
- **"STAMPED checkpoint" callouts** at chapter ends *(optional add-on,
  not required)*: 1–2 concrete checklist items (`must/004`,
  `should/001`, …) the reader can now tick. Draft only if Russ signals
  interest during PR review; otherwise skip.

---

## 5. Explicit non-goals

- Not adding CARE, TRUST, PROV-DM, DUO, Ten Simple Rules. Those are separate
  frameworks; a survey subagent listed them as "gaps" but they are out of
  scope for this integration.
- Not touching the book's existing FAIR section, other than to append the
  STAMPED companion right after it.
- Not renaming, restructuring, or reordering chapters.
- Not rewriting the DataLad / containers / BIDS coverage — just attaching
  attribution.

---

## 6. Verification steps before writing edits

1. Read `stamped-paper/main.tex` §Introduction + §Principles fully so
   one-line-per-principle summaries match canonical wording (avoid
   paraphrase drift).
2. ~~Grab exact author list, year, DOI…~~ **Done** — canonical BibTeX
   from `doiref` captured in §10 Appendix; preprint DOI verified to
   resolve.
3. Confirm checklist site URL and stability, plus the `must/NNN` /
   `should/NNN` anchor scheme (verify at least one anchor resolves).
4. Local build check (repo uses `myst.yml` at book root) that citations
   render before pushing.

---

## 7. Delivery / sequencing

**Decided:** one PR against `main` from branch `enh-stamped`, with
multiple commits so Russ can review the whole integration end-to-end
while still being able to drop or request changes to individual pieces.

Suggested commit sequence (each independently revertable):

1. `docs/stamped-integration-plan.md` — this plan file *(already
   staged).*
2. `book/references.bib` — add STAMPED entry (`Macdonald:2026aa`).
3. **Phase 1** anchor + attribution:
   - `book/introduction.md` — primary STAMPED framing paragraph.
   - `book/data_management.md` — deep STAMPED subsection after FAIR.
   - `book/workflows.md` — cross-reference inside the FAIR-inspired list.
   *(May split into 2–3 sub-commits if diffs get large.)*
4. **Phase 2** per-principle attachments — one commit per attachment
   chapter to keep review chunks small:
   - `book/project_organization.md` (S, M, P)
   - `book/data_management.md` (T — one line under DataLad section)
   - `book/workflows.md` (A, E)
   - `book/sharing.md` (A, D)
   - `book/HPC.md` (P, E)
5. **Phase 3** — `book/extras.md` mapping table, its own commit (per
   §8.2).
6. *(Optional)* "STAMPED checkpoint" callouts — separate commit; drop
   if Russ prefers.

---

## 8. Decisions

Recorded from Yaroslav's review of this plan. Original questions +
verbatim responses retained under each decision as an audit trail.

### 8.1 Bib entry style — **Resolved**

**Decision:** Full author list. Bibkey `Macdonald:2026aa` (Austin
Macdonald is first author, not Halchenko). Canonical BibTeX from
`doiref` captured verbatim in §10 for the reference.

> **Original question:** should the entry use full author list, or
> shortened `{Halchenko, Yaroslav O. and others}`?
>
> **Response:** `@article{Halchenko:2026aa, ...}` does not sound right
> — first author is Austin Macdonald. `doiref` output captured; use full
> list and the more proper identifier.

### 8.2 Phase 3 scope — **Resolved**

**Decision:** In scope. Add a concise mapping table to `book/extras.md`
in a **separate commit** within the same PR. "STAMPED checkpoint"
callouts remain optional (draft only if Russ signals interest).

> **Original question:** are the callouts + mapping table in, sample-first, or skipped?
>
> **Response:** (a) — add concise table to `book/extras.md`. Do it in
> a separate commit though.

### 8.3 Ephemerality treatment — **Resolved**

**Decision:** Full but concise treatment. Reframe independently of
`git`: "copy everything needed for execution into some temporary
location instead of running in-place." HPC's per-job scratch model
already exercises this naturally — call that out explicitly.

> **Original question:** give Ephemerality full treatment or soft-pedal
> it?
>
> **Response:** `git` is just a helper tool here. Ephemerality could be
> presented as "copy everything you think needed for execution into
> some temporary location instead of running 'inplace'". Give it good
> treatment, albeit concise.

### 8.4 STAMPED overview placement — **Resolved**

**Decision:** Two-tier presentation. Brief framing paragraph in
`book/introduction.md` (per (a) — more prominent). Deep coverage
subsection after FAIR in `book/data_management.md` (per (c) — original
proposal), referenced from the introduction.

> **Original question:** intro (a), standalone chapter (b), or after
> FAIR in `data_management.md` (c)?
>
> **Response:** (a) — mention in introduction, then extend after FAIR
> in `book/data_management.md`.

### 8.5 Contributor / conflict-of-interest disclosure — **Resolved**

**Decision:** Include the proposed disclosure line in the
`book/data_management.md` STAMPED subsection. Russ may adjust wording
during PR review.

Line to insert (as drafted):

> *Full disclosure: STAMPED was co-developed by Yaroslav Halchenko, who
> also contributed to this book.*

> **Response:** Above is alright with me; Russ might adjust when in PR.


---

## 9. What lands where — quick summary table

| Book file                      | Phase 1                                                       | Phase 2                                             | Phase 3                                  |
|--------------------------------|---------------------------------------------------------------|-----------------------------------------------------|------------------------------------------|
| `book/references.bib`          | + STAMPED entry (`Macdonald:2026aa`)                          | —                                                   | —                                        |
| `book/introduction.md`         | STAMPED framing paragraph (**primary** framing spot)          | —                                                   | —                                        |
| `book/data_management.md`      | STAMPED subsection after FAIR (deep coverage, COI disclosure) | +1 line under DataLad (Tracking)                    | *(callout — optional)*                   |
| `book/workflows.md`            | +1 line under FAIR-inspired list                              | +1 line (Actionability, Ephemerality)               | *(callout — optional)*                   |
| `book/sharing.md`              | —                                                             | +1 line (Distributability, Actionability)           | *(callout — optional)*                   |
| `book/project_organization.md` | —                                                             | +1 line (Self-containment, Modularity, Portability) | *(callout — optional)*                   |
| `book/HPC.md`                  | —                                                             | +1 line (Portability, Ephemerality)                 | *(callout — optional)*                   |
| `book/extras.md`               | —                                                             | —                                                   | **Mapping table** (own commit, per §8.2) |

---

## 10. Appendix: canonical BibTeX for the STAMPED preprint

Captured verbatim from `doiref https://doi.org/10.31222/osf.io/f3h82_v1`
(shell output, per §8.1 response):

```bibtex
@article{Macdonald_2026,
  title={STAMPED principles for reproducible research objects},
  url={http://dx.doi.org/10.31222/osf.io/f3h82_v1},
  DOI={10.31222/osf.io/f3h82_v1},
  publisher={Center for Open Science},
  author={Macdonald, Austin and Baker, Cody and To, Isaac and Halchenko, Yaroslav O},
  year={2026},
  month=May
}
```

Adjustments before appending to `book/references.bib`:

- Rename key from `Macdonald_2026` → `Macdonald:2026aa` to match the
  book's BibDesk convention (see `Halchenko:2021aa`, `Bannier:2021aa`,
  etc.).
- Consider changing `@article` → `@misc` since this is a preprint (or
  keep `@article` with a `note = {Preprint}` — check other preprint
  entries in the book's .bib for the local convention).
- Add `bdsk-url-1 = {https://doi.org/10.31222/osf.io/f3h82_v1}` to
  match the BibDesk-style entries in the rest of the file.
- Upgrade DOI URL from `http://` → `https://` in the `url` field.
- If the paper is accepted at a peer-reviewed venue (e.g. Sci Data)
  before this PR merges, replace with the venue's citation instead.
