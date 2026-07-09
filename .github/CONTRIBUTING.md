# Contributing to marker-command-engine (MCE)

Thank you for your interest in contributing to **marker-command-engine (MCE)**! Contributions of all kinds are welcome, including bug reports, feature requests, documentation improvements, performance optimizations, and code or datapack enhancements.

## Reporting Bugs

Before opening a new issue, please check the existing issues to avoid duplicates.

When reporting a bug, include the following information whenever possible:

* **Minecraft Version** (for example: `1.20.1`)
* **Datapack Version** (for example: `v2.1.0`)
* **Installed Mods** (Fabric API, Sodium, etc., if applicable)
* **Description** of the problem
* **Expected Behavior**
* **Steps to Reproduce** the issue
* **Screenshots or Logs**, including crash reports if available

Clear and reproducible reports help us resolve issues much faster.

## Suggesting Features

Have an idea that could improve MCE?

Open a new issue and label it as a **feature request** or **enhancement**. Please explain:

* What the feature does
* Why it would be useful
* Any implementation ideas or examples (optional)

Well-described feature requests are much easier to evaluate.

## Submitting Pull Requests

We welcome pull requests!

Before submitting one, please make sure you:

1. Fork the repository and create a branch from `main`.
2. Follow the existing project structure and naming conventions.
3. Keep functions, JSON files, and assets organized within their proper namespaces.
4. Update `pack.mcmeta` if your changes require a new `pack_format`.
5. Test your changes in Minecraft using `/reload` and verify that no errors appear.
6. Ensure your changes do not introduce unnecessary files or formatting changes.
7. Write a clear pull request title and describe exactly what your PR changes.

Small, focused pull requests are generally easier to review than large ones.

## Coding Standards

### Namespaces

* Always use a unique namespace under `data/`.
* Avoid overriding files from other datapacks unless intentionally required.

### Functions

* Keep `.mcfunction` files organized and easy to read.
* Use comments (`#`) where they improve readability.
* Prefer descriptive function names over abbreviations.

### JSON Files

* Ensure all JSON files are valid and properly formatted.
* Maintain consistent indentation and formatting throughout the project.

### Scoreboards

* Prefix scoreboard objectives with the project namespace to minimize conflicts with other datapacks.

## Testing

Before opening a pull request, verify that:

* The datapack loads without errors.
* `/reload` completes successfully.
* Relevant functionality behaves as expected.
* No warnings or errors are introduced into the game log.

## Code of Conduct

Please be respectful and constructive when interacting with other contributors. We aim to maintain a welcoming and collaborative environment for everyone.

## License

By contributing to **marker-command-engine (MCE)**, you agree that your contributions will be licensed under the project's **MIT License**.

## Need Help?

If you have questions, ideas, or would like to discuss a contribution before starting work, feel free to open a discussion or issue in the repository.
