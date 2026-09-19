# Washup

A Flutter app (Android + iOS) that replaces the paper "Waschplan" clipboard
some apartment buildings use to share a cellar full of washing machines and
dryers, and fixes the thing everyone complains about: the paper version is
visibly biased — whoever signs up first, or writes the biggest name, ends up
on the sheet far more often than everyone else.

## What it does

- **Configurable building** — set the number of floors and flats per floor;
  flats are named `1A`, `1B`, `2A`, ... and can be renamed to a tenant's name
  or switched off (e.g. a vacant unit) from the **Flats** tab.
- **Configurable appliances** — set how many washing machines and dryers live
  in the cellar.
- **Configurable time slots** — the default mirrors the classic 07–12 /
  12–17 / 17–22 layout, but slots can be added, removed, relabeled or
  retimed from **Setup**.
- **Generates a bias-free plan** — tap "Generate plan" to produce a rota for
  the configured number of days, shown day-by-day as a grid of machines ×
  time slots, just like the paper version.
- **Fairness tab** — shows exactly how many appliance-slots each flat got in
  the current plan (as a bar per flat) plus the random seed used, so
  fairness is auditable rather than taken on faith.

## How "without bias" is implemented

`lib/services/scheduler_service.dart` uses a fair-queueing algorithm:

1. Every flat starts with a running total (0, or carried over from every
   plan generated before it — see below).
2. For each appliance-slot (a given machine, at a given time slot, on a
   given day), the candidates are every active flat that hasn't already hit
   the per-day cap (`maxSlotsPerFlatPerDay`, default 1 — nobody washes twice
   in the same day while others get nothing).
3. Among candidates, the scheduler finds whoever has the *lowest* running
   total, and — if several flats are tied — picks one **uniformly at
   random**. This is the step that removes bias: ties are never broken by
   list order, alphabetical order, or who was entered first.
4. The chosen flat's running and daily totals are incremented and the loop
   continues.

This guarantees the spread between the busiest and quietest flat is at most
one appliance-slot for the whole plan (verified in
`test/scheduler_service_test.dart`).

Fairness also **compounds across plans**: `AppState`/`StorageService` persist
a cumulative per-flat count every time a plan is generated, and that history
is fed back in as the starting point for the next plan. So generating a new
month's rota doesn't reset the scoreboard — a flat that got fewer slots last
month is preferred this month until things even out. This history can be
reset from code via `StorageService.resetHistoryCounts()` (e.g. after adding
or removing flats).

## Project layout

```
lib/
  models/      Flat, Machine, TimeSlot, LaundrySettings, ScheduleEntry, LaundryPlan
  services/    SchedulerService (the algorithm), StorageService (persistence),
               AppState (app-wide state, wraps both)
  screens/     Plan, Fairness, Flats, Setup (bottom nav tabs)
  widgets/     DayScheduleCard (renders one day's grid)
```

State is stored locally on-device via `shared_preferences` — no backend or
account is required.

## Running it

```bash
flutter pub get
flutter run            # launches on a connected device/emulator
flutter test           # unit tests for the scheduler + widget smoke tests
flutter build apk      # Android
flutter build ios      # iOS (requires Xcode on macOS)
```
