## [Unreleased]

### [0.4.0] - 2022-05-02

### Added

- `any_then` and alias `either_then` yields value to a block if the instance status matches the input statuses.

## [0.3.0] - 2022-03-13

### Added

- `#any?` to compare the instance status against array of statuses.

### Changed

- Conditional "#&lt;status&gt;_then" now returns nil instead of self if there is no match.
- Wrap checks with .format_status method to reliably format the status...

## [0.2.0] - 2022-03-07

### Added

- Allow aliases of the status tags to be defined with the .define_status_tags
  method.

### Removed

- No longer define methods with the method_missing hook.

## [0.1.0] - 2022-03-04

- Initial release
