# Simplified Technical English: the rules

These rules follow the nine sections of Part 1 of ASD-STE100 (Simplified Technical English),
Issue 8, adapted for software documentation. The text is our own wording; it does not quote the
specification. The ASD-STE100 dictionary (Part 2) is replaced by the project glossary (section 10).

The rule numbers are the same as in `references/rules-zh.md`. A rule that exists in only one
language says so. Each rule is **hard** or **soft**. Obey the hard rules. Obey the soft rules when
you can; when you break one, have a reason. All examples are made up to show the rule.

## Contents

1. Words: 1.1–1.5
2. Noun phrases: 2.1–2.3
3. Verbs: 3.1–3.5
4. Sentences: 4.1–4.6
5. Procedures: 5.1–5.5
6. Descriptive writing: 6.1–6.5
7. Warnings: 7.1–7.4
8. Punctuation, numbers and length: 8.1–8.9
9. Writing practices: 9.1–9.7
10. The glossary

## 1 Words

1.1 **Use one word for one concept.** (hard)
   Use the same word for the same thing or action in the whole document. Do not change words to
   make the text more varied.
   Why: a reader who sees two words thinks that there are two things. An AI reader does the same.
   Example: "The service loads its configuration at startup. After you change the settings,
   reinitialize it so that the new parameters apply." → "The service reads its configuration at
   startup. After you change the configuration, restart the service."

1.2 **Give each word one meaning.** (hard)
   When a word has a meaning in the glossary, do not use it for a different thing.
   Example: if "node" means a machine in the cluster, do not call an item in a tree a "node".
   Use "entry" or the code name.

1.3 **Use the words in the glossary.** (hard)
   Use the project glossary for project concepts. When a concept is new, add it to the glossary
   first. If there is no glossary, see section 10.

1.4 **Do not use vague words.** (hard)
   Do not use: appropriate, relevant, various, significant, substantial, a number of, reasonable,
   fairly, quite, somewhat, basically, essentially. Write a number, a name or a condition.
   Why: a vague word gives no information. The reader needs "how much" and "which one".
   Example: "Performance improved significantly." → "p99 latency went from 120 ms to 45 ms
   (1,000 requests per second, 2026-03-02)."
   When you rewrite and do not know the number, remove only the empty intensifier and keep the
   claim: "a fairly large refactor" → "a refactor"; "improved significantly" → "improved". Tell
   the author which claims have no data. Write an inline "[TBD: …]" only when the reader cannot
   do the task without the fact. Do not put a guess in the placeholder.
   Check: `scripts/check.py`.

1.5 **Use verbs that say what happens.** (soft)
   "Handle", "process", "manage", "support", "optimize" and "deal with" only say that something
   happens. Write the action.
   Example: "The worker handles failed jobs." → "The worker retries a failed job three times and
   then moves it to the dead-letter queue."
   Exception: a general verb is correct when the next words give the details: "It supports
   three formats: PNG, JPEG and HEIC."

## 2 Noun phrases

2.1 **Do not stack long modifiers before a noun.** (soft)
   Put at most two modifiers before a noun. Move the rest after the noun, or make a second
   sentence. Do not chain "of the … of the …" more than twice.
   Example: "the user-ID-sharded asynchronously replicated 30-day-retention orders table" → "the
   orders table. The table is sharded by user ID, replicated asynchronously and keeps data for 30
   days."

2.2 **Do not use more than three nouns together.** (soft)
   Use a verb or a preposition to break a longer noun cluster.
   Why: the reader cannot see which noun modifies which. Is a "cache service connection pool
   timeout" the timeout of the service or of the pool?
   Example: "connection pool timeout retry policy" → "how the connection pool retries after a
   timeout".
   Exception: a term in the glossary counts as one word.

2.3 **Hyphenate a compound modifier before a noun.** (hard; English only)
   Write "read-only replica", "two-step process", "64-bit build". Do not hyphenate it after the
   noun: "the replica is read only".

## 3 Verbs

3.1 **Do not hide the verb in a noun.** (hard)
   Do not write "perform", "carry out", "conduct", "make a decision", "give an explanation". Use
   the verb that the noun comes from.
   Example: "Perform a validation of the input." → "Validate the input."
   Example: "We made an adjustment to the timeout." → "We changed the timeout."
   Check: `scripts/check.py`.

3.2 **Use the active voice. Name the actor.** (soft)
   Put the thing that does the action first.
   Why: the active voice tells the reader which component acts, so the reader knows where to look.
   Example: "Requests are forwarded to the backend." → "The gateway forwards requests to the
   backend."
   Exception: use the passive when the actor is not known or not important: "The connection was
   reset." In procedures the imperative replaces both (5.2).

3.3 **State facts in the simple tense.** (soft)
   Use the simple present for how a system works, the simple past for what happened, and "will"
   for the future. Do not use the progressive ("is sending") or the perfect progressive.
   Example: "The scheduler is listening to the queue." → "The scheduler listens to the queue."
   Use "-ing" words only as nouns or adjectives in a term: "the logging level".

3.4 **Use a fixed set of words for requirements.** (hard)

   | Word | Meaning |
   |---|---|
   | must / must not | a requirement |
   | should / should not | a recommendation |
   | can / cannot | a permission, a capability or a possibility |
   | need not | not required |

   Do not use "need to", "have to", "make sure", "ensure that", "ideally", "try to" or "it is
   recommended" to state a requirement. If the project uses RFC 2119 keywords (MUST, SHOULD,
   MAY), use them instead.
   Why: "make sure", "ideally" and "need to" have different strengths. The reader cannot tell
   which requirement is optional.
   Exception: steps and warnings use the imperative (5.2, 7.2). "Need" is correct as a normal
   verb that describes a system: "The client needs the token before it sends a request."

3.5 **Use a one-word verb when one exists.** (soft; English only)
   Prefer "start" to "start up", "find" to "find out", "remove" to "get rid of". Keep a phrasal
   verb when it is the standard term ("log in", "roll back").

## 4 Sentences

4.1 **Write one topic in each sentence.** (hard)
   When a second topic starts, start a new sentence.
   Example: "The deploy script checks the image version and pushes it, rolls back and alerts on
   failure, and otherwise updates the configuration and notifies the services." → "The deploy
   script checks the image version. Then it pushes the image. If the push fails, the script rolls
   back and sends an alert. If the push succeeds, the script updates the configuration and tells
   each service to reload it."

4.2 **Name the actor.** (hard)
   Do not start a sentence with an empty subject ("It is …", "There is …") when a real subject
   exists. Do not use a modifier that has no actor ("After restarting, the cache is empty": who
   restarts?).
   Example: "It is necessary to restart the service." → "Restart the service."
   Example: "After committing, tests run automatically." → "After a developer commits, CI runs the
   tests."

4.3 **Make each pronoun point to one thing.** (hard)
   Use "it", "this", "that" and "which" only when one noun before them can be meant. Do not use
   "this" alone: write "this setting", "this step".
   Example: "The client sends the request to the pool, and it retries." → "The client sends the
   request to the pool. The pool retries."

4.4 **Show how sentences connect.** (soft)
   Use "because", "so", "if" and "but" to show cause, condition and contrast.
   Example: "The lock timeout is 30 seconds. A job runs for at most 20 seconds." → "A job runs for
   at most 20 seconds, so the lock timeout is 30 seconds."

4.5 **Use a vertical list for three or more items.** (soft)

4.6 **Do not leave out words.** (hard; English only)
   Keep the articles ("the", "a") and "that" where the sentence needs them. Do not write in
   telegraph style to make sentences shorter.
   Example: "Restart service after config change." → "Restart the service after you change the
   configuration."

## 5 Procedures

5.1 **Write one instruction in each step, in a numbered list.** (hard)
   Put two actions in one step only when the reader must do them at the same time.

5.2 **Start each step with a verb in the imperative.** (hard)
   Write "Run …", "Open …". Do not write "You should run …" or "The user runs …".

5.3 **Put the condition before the instruction.** (hard)
   Write "If the migration fails, restore the backup." Do not write "Restore the backup if the
   migration fails."
   Why: a reader who reads the instruction first can act before reading the condition.

5.4 **Write at most 20 words in a step sentence.** (soft)
   See 8.8 for how to count.

5.5 **Keep notes and results apart from instructions.** (soft)
   Put the reason before the list. Put the result of a step after that step, in its own sentence.

Example for this section:

Original: "Before upgrading you'll need to back up the database, then stop the service, and once
the upgrade is done go ahead and run the migration script; if that fails, restore from backup."

Rewrite:

**Warning:** If the migration fails, only the backup can restore the data. Back up the database
before you upgrade.

1. Back up the database: `pg_dump app > app.sql`.
2. Stop the service: `systemctl stop app`.
3. Install the new version.
4. Run the migration: `app migrate`.
   Result: the last line of the output is `migrated`.
5. If the migration fails, restore the backup: `psql app < app.sql`.
6. Start the service: `systemctl start app`.

## 6 Descriptive writing

6.1 **Put the conclusion first.** (hard)
   The first sentence of a paragraph gives the conclusion. Reasons, data and exceptions follow.
   Why: many readers read only the first sentence of each paragraph.

6.2 **Write one topic in each paragraph, in at most six sentences.** (soft)

6.3 **Write at most 25 words in a descriptive sentence.** (soft)
   Table cells are exempt.

6.4 **Give the conditions of every measured number.** (hard)
   State what was measured, the load, the machine and the date. Do not write a number that
   nobody measured. When you rewrite a number and its conditions are not known, keep the number
   as written and list it for the author; do not add an inline placeholder.
   Example: "p99 latency is 45 ms" → "p99 latency is 45 ms (1,000 requests per second, c6i.xlarge,
   2026-03-02)".

6.5 **Keep what is done apart from what is planned.** (hard)
   Give a date or "done" for completed work. Use "will", or a "Roadmap" or "Next steps" section,
   for plans.
   Why: a reader who takes a plan for a fact tries to use a feature that does not exist.

## 7 Warnings

Warn about operations that can do damage: data loss, irreversible changes, wrong results without
an error, silent performance loss, production impact, publishing outside the team.

7.1 **Put a warning before the step it applies to.** (hard)

7.2 **Give the instruction first, then the risk.** (hard)
   The first sentence says what to do or not to do. The second sentence says what happens if the
   reader does not obey. Give numbers when you have them.
   Example: "Since `--force` rewrites remote history, which can result in lost commits for other
   people, it is recommended to avoid it." → "**Warning:** Do not use `git push --force` on a
   shared branch. It rewrites the remote history, and other people lose their commits."

7.3 **Give one risk in each warning.** (soft)

7.4 **Use two levels: Warning and Caution.** (hard)
   **Warning:** data loss, irreversible change, wrong result without an error, production
   impact, publishing outside the team.
   **Caution:** slower operation, work to do again, a long wait.
   Start each one with "**Warning:**" or "**Caution:**", in its own paragraph.

## 8 Punctuation, numbers and length

8.1 **Use ASCII punctuation in English text.** (hard)
   Do not use full-width punctuation in an English sentence.

8.2 **Use one style of quotation marks in a document.** (hard)
   Follow the project convention. If there is none, keep the style that the document already
   uses most.

8.3 **Put a space between a number and its unit.** (hard)
   Write "40 ms", "1 MB", "5 minutes". Do not put a space before "%".

8.4 **Use numerals for counts and measurements.** (soft)
   Write "3 retries", "step 4", "2 replicas". Write the number as a word when it is not a count:
   "one of the replicas".

8.5 **Use unit symbols with numbers.** (soft)
   Write "40 ms", "500 req/s", "2 GB". Write the unit as a word when there is no number:
   "a few milliseconds" is vague (1.4); "milliseconds" alone is correct.

8.6 **Write ranges with an en dash or "to".** (hard)
   Write "5–10 seconds" or "5 to 10 seconds". Do not use "~" or a hyphen.

8.7 **Write dates that cannot be misread.** (hard)
   Use ISO dates (2026-03-02) in tables, logs and parentheses, and "March 2, 2026" (or the
   project style) in text. Do not write "03/02/2026".

8.8 **Count words like this.** (hard)
   A word is a group of characters between spaces. A code span, a number with its unit, and a
   hyphenated word each count as one word. A sentence ends at a period, a question mark, an
   exclamation mark or a semicolon. Step limits: 5.4. Descriptive limits: 6.3.

8.9 **Make list items and "and/or" clear.** (soft)
   End list items that are full sentences with a period. Do not use "and/or": say which.

## 9 Writing practices

9.1 **Spell and case each term one way.** (hard; the Chinese version covers translations)
   Write "log in" (verb) and "login" (noun), "set up" (verb) and "setup" (noun), and keep each
   one the same in the whole document.

9.2 **Put code names in backticks, exactly as in the code.** (hard)
   Files, functions, types, commands, flags and environment variables: `parseConfig`,
   `--dry-run`, `HTTP_PROXY`.

9.3 **Use official product names. Define abbreviations at first use.** (hard)
   Write macOS, PostgreSQL, GitHub, Kubernetes. Write "Kubernetes (K8s)" the first time.

9.4 **Do not use idioms, filler or marketing words for facts.** (soft)
   Do not write "out of the box", "seamless", "leverage", "under the hood", "robust",
   "powerful", "simply", "just", "easily", "obviously". State what happens and how much.
   Why: these words sound like information but give none. "Simply" and "just" also tell a reader
   who has a problem that the problem is their fault.

9.5 **Write to the reader as "you". Write "we" for decisions of the project.** (soft)

9.6 **Give references that the reader can find.** (soft)
   Give the file and line, or the file and section: "`server.go`, line 120".

9.7 **Do not use contractions or Latin abbreviations.** (soft; English only)
   Write "do not", "it is". Write "for example", "that is", "and so on", "through" instead of
   "e.g.", "i.e.", "etc.", "via".
   Why: contractions and Latin abbreviations are harder for readers who do not have English as a
   first language, and for translation.

## 10 The glossary

The glossary is the source for 1.1–1.3 and 9.1. Before you write, find the project glossary:

- files with "glossary", "terms" or "terminology" in the name;
- a terms section in a style guide (`STYLE.md`, `CONTRIBUTING.md`, a writing guide in the docs);
- naming rules in `CLAUDE.md`, `AGENTS.md` or the README.

If you find one, use it. When it conflicts with these rules, the project wins.

If there is no glossary:

1. Before you write, list the project concepts that you will use, from the code and the documents.
2. Choose one word for each concept. Prefer the name in the code and the most frequent word in
   the documents.
3. After you write, give the list to the author and suggest that the project keeps it:

| Term | Meaning | Do not use |
|---|---|---|
| build | type-check, then bundle | compile (for this) |
| bundle | the esbuild step of a build | build (for this step only) |
