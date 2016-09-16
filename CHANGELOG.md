# Changelog

## Unreleased
- Nothing yet

## [v0.4.2] - 2016-09-16
### Fixed
- Strip empty binaries from array of ids before casting ([@sebastian](https://github.com/sebastian))
- Properly order nested tags - checkbox first, label text afterwards ([@creuter](https://github.com/creuter))

## Changed
- Improved documentation ([@sebastian](https://github.com/sebastian))


## [v0.4.1] - 2016-09-13
### Fixed
- Don't try to pattern match keyword list options ([@drapergeek](https://github.com/drapergeek))


## [v0.4.0] - 2016-09-13
### Added
- Allow nesting of checkboxes inside labels ([@drapergeek](https://github.com/drapergeek))

### Changed
- Updated Travis to track Elixir 1.3.2 / OTP 19.0


## [v0.3.0] - 2016-08-21
### Added
- Allow passing of a custom collection lookup function
- Added tests for Changeset module
- Added tests to cover helper options ([@justinbkay](https://github.com/justinbkay))
- Improve function documentation ([@justinbkay](https://github.com/justinbkay))

### Changed
- Updated to Ecto ~> 2.0.0 stable from -rc

### Fixed
- If param is not provided to changeset, preserve assoc as it was


## [v0.2.0] - 2016-06-18
### Changed
- Nolonger using Phoenix namespace for modules
- Single query is now used to fetch data to prepare changesets


## [v0.1.0] - 2016-06-18
### Added
- Initial functionality implemented


[Unreleased]: https://github.com/adam12/phoenix_mtm/compare/v0.4.2...HEAD
[v0.4.2]: https://github.com/adam12/phoenix_mtm/compare/v0.4.1...v0.4.2
[v0.4.1]: https://github.com/adam12/phoenix_mtm/compare/v0.4.0...v0.4.1
[v0.4.0]: https://github.com/adam12/phoenix_mtm/compare/v0.3.0...v0.4.0
[v0.3.0]: https://github.com/adam12/phoenix_mtm/compare/v0.2.0...v0.3.0
[v0.2.0]: https://github.com/adam12/phoenix_mtm/compare/v0.1.0...v0.2.0
[v0.1.0]: https://github.com/adam12/phoenix_mtm/tree/v0.1.0
