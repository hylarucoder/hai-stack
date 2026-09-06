## Internal consistency procedure

1. Identify the document scope.
   - The scope is exactly what the user points at: a single file, an arbitrary batch of files, a
     PRD pack, README plus docs, or a generated spec set. Do not widen it to a directory uninvited.
   - Note the document's apparent audience, purpose, and expected decision/use.

2. Build a document map.
   - List the main sections and what each section is trying to do.
   - Extract key claims, definitions, terminology, assumptions, scope boundaries, examples, dates, owners, statuses, and cross-links.
   - Identify repeated claims and places where the same concept appears under different names.

3. Find internal issues.
   - **Direct conflict**: two sections make incompatible claims.
   - **Scope conflict**: in-scope and out-of-scope sections disagree.
   - **Terminology drift**: the same concept uses different names, or one name means different things.
   - **Lifecycle conflict**: statuses, phases, dates, or dependencies do not line up.
   - **Acceptance conflict**: success criteria do not prove the stated goal.
   - **Stale signal**: the document itself contains dates, statuses, replacement notices,
     decision order, or cross-references proving that text is superseded. Without such evidence,
     label it unsupported or needs decision—not stale.
   - **Redundant content**: repeated paragraphs, examples, or checklists should be merged or removed.
   - **Misplaced content**: implementation detail, policy, background, or task planning lives in the wrong document section.
   - **Unsupported claim**: a strong claim lacks evidence, owner, source, or decision record.

4. Decide the repair type.
   - **Update** when the content is useful but stale or imprecise.
   - **Move** when the content belongs elsewhere in the same document.
   - **Merge** when repeated content fragments one idea.
   - **Remove** when content is out of scope, obsolete, unsupported, or harmful.
   - **Split** when one document contains multiple independent goals or audiences.
   - **Ask** when a conflict cannot be resolved from the document itself.

5. Return candidates to the shared audit workflow.
   - Prioritize issues that change understanding, decisions, scope, or execution.
   - Keep wording fixes secondary unless wording causes ambiguity or conflict.
   - Use the shared output template once, including findings from other selected evidence modes.
