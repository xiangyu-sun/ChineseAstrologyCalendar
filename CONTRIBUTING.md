# Contributing to ChineseAstrologyCalendar

Thank you for your interest in contributing to ChineseAstrologyCalendar! This document provides guidelines and instructions for contributing to the project.

## Code of Conduct

This project adheres to a code of conduct that all contributors are expected to follow. Please be respectful and constructive in all interactions.

## Getting Started

### Prerequisites

- macOS 10.14+ (for local development)
- Xcode 14.0+ or Swift 5.8+
- Git

### Setting Up Your Development Environment

1. **Fork the repository** on GitHub

2. **Clone your fork** to your local machine:
   ```bash
   git clone https://github.com/YOUR_USERNAME/ChineseAstrologyCalendar.git
   cd ChineseAstrologyCalendar
   ```

3. **Add the upstream repository** as a remote:
   ```bash
   git remote add upstream https://github.com/xiangyu-sun/ChineseAstrologyCalendar.git
   ```

4. **Build the package** to verify your setup:
   ```bash
   swift build
   ```

5. **Run tests** to ensure everything works:
   ```bash
   swift test
   ```

## Development Workflow

### Before You Start

1. **Check existing issues** to see if someone is already working on the feature or fix
2. **Create or comment on an issue** to discuss your proposed changes
3. **Keep changes focused** - one feature or fix per PR

### Making Changes

1. **Create a new branch** from `master`:
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/your-bug-fix
   ```

2. **Make your changes** following the code style guidelines below

3. **Write or update tests** for your changes

4. **Run tests** to ensure they pass:
   ```bash
   swift test
   ```

5. **Run code formatting**:
   ```bash
   swift package format
   ```

6. **Run linting**:
   ```bash
   swift package lint
   ```

7. **Commit your changes** with clear, descriptive commit messages:
   ```bash
   git commit -m "Add feature: brief description"
   ```

### Submitting a Pull Request

1. **Push your branch** to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Create a Pull Request** on GitHub from your fork to the main repository

3. **Fill in the PR template** with:
   - Clear description of changes
   - Related issue numbers (use "Fixes #123" or "Closes #123")
   - Any breaking changes
   - Screenshots if applicable (for documentation changes)

4. **Wait for review** - maintainers will review your PR and may request changes

5. **Address feedback** by making additional commits to your branch

6. **Celebrate!** 🎉 Once approved, your PR will be merged

## Code Style Guidelines

### Swift Style

This project uses [SwiftLint](https://github.com/realm/SwiftLint) and [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) to enforce consistent code style.

Key guidelines:
- Use 2 spaces for indentation (not tabs)
- Maximum line length: 120 characters
- Use meaningful variable and function names
- Follow Swift API design guidelines
- Use `// MARK:` comments to organize code sections

### Documentation

- **Public APIs** must have documentation comments
- Use Swift's documentation syntax:
  ```swift
  /// Brief description of the function.
  ///
  /// More detailed description if needed.
  ///
  /// - Parameter name: Description of parameter
  /// - Returns: Description of return value
  public func exampleFunction(name: String) -> String {
    // implementation
  }
  ```
- Include code examples for complex functionality
- Document edge cases and assumptions

### Testing

- Write unit tests for all new functionality
- Maintain or improve code coverage
- Test both success and failure cases
- Use descriptive test names: `testFunctionName_whenCondition_shouldExpectedBehavior`
- Include integration tests for complex workflows

Example test structure:
```swift
func testGanzhiCalculation_forKnownDate_shouldReturnCorrectValue() {
  // Given
  let date = Date(timeIntervalSince1970: 1234567890)
  
  // When
  let ganzhi = date.dateComponentsFromChineseCalendar().nian
  
  // Then
  XCTAssertEqual(ganzhi?.description, "己丑")
}
```

## Architecture Guidelines

### Adding New Features

When adding new features, consider:

1. **Module organization**: Place code in the appropriate directory
   - `Date/` - Date extensions and conversions
   - `DizhiGanzhi/` - Ganzhi system components
   - `FiveElements/` - Wuxing theory
   - `Jieqi/` - Solar terms
   - `Moon/` - Lunar phases

2. **Public API design**:
   - Keep public APIs minimal and well-documented
   - Use Swift protocols for extensibility
   - Consider backward compatibility

3. **Dependencies**:
   - Minimize external dependencies
   - Only add dependencies that are well-maintained
   - Justify new dependencies in your PR

### Breaking Changes

If your changes include breaking changes to the public API:

1. **Deprecate before removing**: Use `@available` annotations
   ```swift
   @available(*, deprecated, renamed: "newFunctionName", message: "Use newFunctionName instead")
   public func oldFunctionName() { }
   ```

2. **Document in PR**: Clearly list all breaking changes
3. **Update migration guide**: Add migration notes to CHANGELOG.md
4. **Discuss with maintainers**: Breaking changes may require major version bump

## Reporting Issues

### Bug Reports

Include:
- Swift version and platform (iOS, macOS, etc.)
- Steps to reproduce
- Expected behavior
- Actual behavior
- Sample code if possible

### Feature Requests

Include:
- Use case description
- Proposed API (if applicable)
- Why this feature would be useful
- Are you willing to implement it?

## Documentation Contributions

Documentation improvements are always welcome! This includes:
- README improvements
- Code comments
- DocC documentation catalog
- Tutorial examples
- Architecture documentation

## Questions?

If you have questions about contributing:
- Open a GitHub issue with the "question" label
- Check existing issues and discussions
- Refer to the CLAUDE.md file for AI-assisted development guidance

## License

By contributing to ChineseAstrologyCalendar, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to ChineseAstrologyCalendar! 🙏


