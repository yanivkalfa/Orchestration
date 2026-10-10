# PROJECT.md — the one file you fill

Replace every `<placeholder>`. Lines marked **example — replace** show a filled value for a
mobile Kotlin app; delete them once yours are in. The commands themselves go in
`project/commands.env`.

## 1. Name

`<project name>`

## 2. What it is (one paragraph)

<Who uses it, what they can do with it, why it matters.>

> Example — replace: "Tally is an Android app for households to split shared bills. A user adds a
> bill, picks who shares it, and the app keeps a running balance per person that works offline
> and syncs when the phone is back online."

## 3. Platform and language

| Item | Yours | Example — replace |
|---|---|---|
| Platform | `<platform>` | Android, min SDK 26 |
| Language | `<language + version>` | Kotlin 2.x |
| UI framework | `<framework>` | Jetpack Compose |
| Build tool | `<build tool + version>` | Gradle, Kotlin DSL |

## 4. Check commands

Set in `project/commands.env`; listed here for humans.

| Purpose | Command | Example — replace |
|---|---|---|
| Lint | `<lint>` | `./gradlew :{module}:lint :{module}:detekt` |
| Test one module | `<test>` | `./gradlew :{module}:testDebugUnitTest` |
| Format one file | `<format>` | `ktlint -F {file}` |
| Build | `<build>` | `./gradlew assembleDebug` |
| Full gate | `<gate>` | `./gradlew check` |

## 5. Test framework

`<framework, where tests live, how a slow/device test is marked>`

> Example — replace: JUnit 5 + Turbine for flows; tests in `src/test/` beside each module;
> device tests in `src/androidTest/`, run only by name.

## 6. Module layout

`<where modules live, how they are named, which may depend on which>`

> Example — replace: `:app`, `:core:*` (no UI), `:feature:*` (one screen family each);
> a feature never depends on another feature.

## 7. References (oracles), if any

`<a trusted product, spec or dataset our output is compared against — or "none">`

> Example — replace: none for UI; for money rounding, the published rounding rules of the
> currency standard, as a table of expected outputs.

## 8. Constraints

- `<licence, privacy, offline, size, performance, accessibility, toolchain limits>`
- `<machine limits: how many build jobs at once are safe>`

## 9. What "done" means here

- `<e.g. "every row's dod is green in the lane and the critic says MEETS BAR">`
- `<project-level: e.g. "a release build installs and passes the smoke suite on <device>">`

## 10. Owner

How the owner wants questions: one chat line, (A)/(B), a recommendation. `<any other preference>`
