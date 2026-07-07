# HealthManage Android Architecture (MVVM)

## Layering

- `ui/`
  - Activities, Fragments, Adapters, ViewModels (presentation only)
- `domain/`
  - UseCases + domain models (business orchestration)
- `data/`
  - `remote/` Retrofit service + client
  - `repository/` data aggregation / source composition
  - `dto/` backend transport models
  - `local/` Room database
- `common/`
  - cross-cutting result/viewmodel placeholders
- `util/`
  - lightweight app utilities (SP, Toast)

## Data flow

`UI -> ViewModel -> UseCase -> Repository -> Remote/Local -> Repository -> UseCase -> ViewModel -> UI`

## Material Design

- App theme: `Theme.Material3.DayNight.NoActionBar`
- Main style entry: `Theme.HealthManage`
- Full-screen pages: `Theme.HealthManage.NoActionBar.Fullscreen`
