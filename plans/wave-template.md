# Wave <n> — <theme>

<One line: what this wave makes possible.> <One line: the order — which rows run serially
because they share a module, which go first and why.> Code lives in each task's worktree
(`../<repo>-wt/<slug>`); this file lives in the main checkout.

## The rows

| # | Row | What | Module(s) | Status |
|---|-----|------|-----------|--------|
| 1 | W1-A1 | Email sign-in screen (example — replace) | `:feature:auth` | OPEN |
| 2 | <id> | <what> | <module> | OPEN |

---

## W1-A1 — email sign-in screen   (example — replace)

**Promise.** A user can type an email and password and reach the home screen, or see a message
that names what was wrong and what to do next.

**Modules.** `:feature:auth` only.

**What exists.**
- `feature/auth/src/main/.../AuthRepository.kt:12-40` — `signIn(email, password): Result<Session>`.
- `app/src/main/.../NavGraph.kt:55` — the `home` route.
- No sign-in screen yet.

**Lands.**
- `SignInScreen.kt` (new, ≤ 200 lines) — the form, the button, one error line, a loading state.
- `SignInViewModel.kt` (new) — holds the typed state, validates, calls `AuthRepository.signIn`,
  emits one `NavigateHome` event on success.
- `SignInError.kt` (new) — the error kinds, each with a user message that says the fix.
- `SignInViewModelTest.kt` (new) — the legs below, on a fake repository.

**Dod.**
1. `empty_email_shows_enter_your_email` — input: blank email. The repository is never called.
   Fails today: no such screen.
2. `malformed_email_names_the_expected_shape` — input: `a@`. The message shows an example address.
3. `bad_password_shows_the_reset_hint` — fake returns `InvalidCredentials`. The message names the
   reset link.
4. `network_down_keeps_input_and_offers_retry` — fake returns `Offline`. Fields keep their text.
5. `success_navigates_home_once` — fake returns a session. Exactly one `NavigateHome` is emitted.
6. `rotation_keeps_typed_email` — state restored from the saved-state handle.
7. `screen_renders_every_state` — snapshot of idle, loading, each error, success (created, never
   accepted when changed).

**Refusals.**
- No social sign-in: row W1-A3.
- No "remember me" and no biometric unlock: not in this wave's promise.
- No edits to `AuthRepository`; a missing method there is widened into this row by ruling, not
  patched around.

**Oracle.** None: no reference implementation; the dod legs are the bar.

**First request.**
```
<LINT_CMD with {module}=feature:auth>
<TEST_CMD with {module}=feature:auth>
```

---

## <row id> — <title>

**Promise.** <one or two sentences>

**Modules.** <list>

**What exists.** <file:line references>

**Lands.** <file by file>

**Dod.**
1. `<test_name>` — <input>. <expected>. Fails today: <why>.

**Refusals.** <what it will not do; who owns it>

**Oracle.** <reference, or why none>

**First request.**
```
<lint line per module>
<test line per module>
```
