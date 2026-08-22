# Swift Rules Engine for iOS

**Business logic humans can read and machines can run.** One copy of your rules: the owner reads it, every system runs it.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

<img width="1280" alt="GoRules ZEN Engine" src="https://raw.githubusercontent.com/gorules/zen/master/.github/images/hero.png">

ZEN Engine is a cross-platform, open-source [Business Rules Engine (BRE)](https://gorules.io) written in **Rust**, packaged here as a **Swift** package with a precompiled XCFramework for **iOS**. Decisions evaluate in microseconds, on-device and offline-capable, and are stored as portable JSON that runs identically on every platform: the same rules power Node.js, Python, Go, Java, Kotlin and .NET backends.

Try it in the free [Online Editor](https://editor.gorules.io) with a built-in simulator, or embed the open-source React [JDM Editor](https://github.com/gorules/jdm-editor) in your own product. Learn more about the [Swift rules engine](https://gorules.io/open-source/swift-rules-engine) on the GoRules website.

## Rules that read like sentences

Conditions are written the way the business says them, in the ZEN Expression Language. The developer view is one toggle away, and the two can never drift apart: there is only one source of truth, and this engine runs it.

<img width="1280" alt="Readable rules" src="https://raw.githubusercontent.com/gorules/zen/master/.github/images/tables.png">

## Rules as graphs, or as documents

Model a decision on a visual canvas of decision tables, switches, expressions, functions and reusable sub-decisions. Or write it as a policy document with prose, typed data models and tables. Both compile to the same engine and return the same answers.

<img width="1280" alt="Graphs and documents" src="https://raw.githubusercontent.com/gorules/zen/master/.github/images/graphs-docs.png">

To go deeper, see the [iOS SDK documentation](https://docs.gorules.io/developers/sdks/ios), the [decision graph guide](https://docs.gorules.io/learn/authoring/decision-graphs) and the [ZEN Expression Language](https://docs.gorules.io/learn/zen-language/syntax) reference.

## Installation

Add the package in Xcode via **File → Add Package Dependencies...** with the repository URL `https://github.com/gorules/zen-ios`, or in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/gorules/zen-ios", from: "2.0.0")
]
```

Then add `ZenUniffi` to your target dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "ZenUniffi", package: "zen-ios")
    ]
)
```

## Quickstart

```swift
import ZenUniffi

Task {
    guard let ruleData = Bundle.main.url(forResource: "pricing", withExtension: "json")
        .flatMap({ try? Data(contentsOf: $0) }) else {
        return
    }

    let engine = try ZenEngine(loader: nil, customNode: nil)
    let decision = try engine.createDecision(content: ruleData)

    let input = """
        {
            "customer": { "tier": "gold", "yearsActive": 3 },
            "order": { "subtotal": 150, "items": 5 }
        }
    """.data(using: .utf8)!

    let response = try await decision.evaluate(context: input, options: nil)

    if let resultString = String(data: response.result, encoding: .utf8) {
        print(resultString)
        // => {"discount":0.15,"freeShipping":true}
    }
}
```

### Loaders

`ZenEngine` accepts an optional `ZenLoader` that serves decisions by key. Use the `static`, `filesystem`, or `zip` variants for common backends, or `callback` for custom loading logic. With a configuration, decisions are pre-loaded and pre-compiled at engine creation for faster evaluations.

```swift
import ZenUniffi
import Foundation

func createEngine() throws -> ZenEngine {
    let url = Bundle.main.url(forResource: "pricing", withExtension: "json")!
    let pricing = try Data(contentsOf: url)

    let loader = ZenLoader.static(content: ["pricing.json": pricing])
    return try ZenEngine(loader: loader, customNode: nil)
}
```

Full guides, including filesystem and zip loaders, tracing and expression evaluation, are in the [iOS SDK documentation](https://docs.gorules.io/developers/sdks/ios).

## Other platforms

* **Node.js** - [GitHub](https://github.com/gorules/zen/tree/master/bindings/nodejs) | [Documentation](https://docs.gorules.io/developers/sdks/nodejs) | [npm](https://www.npmjs.com/package/@gorules/zen-engine)
* **Python** - [GitHub](https://github.com/gorules/zen/tree/master/bindings/python) | [Documentation](https://docs.gorules.io/developers/sdks/python) | [PyPI](https://pypi.org/project/zen-engine/)
* **Go** - [GitHub](https://github.com/gorules/zen-go) | [Documentation](https://docs.gorules.io/developers/sdks/go)
* **Java / Kotlin / Android** - [GitHub](https://github.com/gorules/zen/tree/master/bindings/uniffi) | [Documentation](https://docs.gorules.io/developers/sdks/java) | [Maven Central](https://central.sonatype.com/artifact/io.gorules/zen-engine)
* **.NET** - [GitHub](https://github.com/gorules/zen/tree/master/bindings/uniffi) | [Documentation](https://docs.gorules.io/developers/sdks/csharp) | [NuGet](https://www.nuget.org/packages/GoRules.ZenEngine)
* **Rust (Core)** - [GitHub](https://github.com/gorules/zen) | [Documentation](https://docs.gorules.io/developers/sdks/rust) | [crates.io](https://crates.io/crates/zen-engine)

## The GoRules platform

The engine is open at the core; [GoRules](https://gorules.io) is the platform around it. Managed cloud, self-hosted, or embedded with no network hop. SOC 2 Type II.

### AI that builds rules, and stays reviewable

An AI copilot and MCP server that edits rules, runs tests and explains decisions. It never deploys. Releases stay with your reviewers.

<img width="800" alt="GoRules AI" src="https://raw.githubusercontent.com/gorules/zen/master/.github/images/ai.png">

### Promote like a release, run like a binary

A release moves from testing to staging to production untouched. Approvals, instant rollback, and a paper trail for every change.

<img width="800" alt="Governance" src="https://raw.githubusercontent.com/gorules/zen/master/.github/images/governance.png">

### Prove it before it ships

Scenario suites run on every change, coverage is measured against decision paths, and every answer comes with a replayable trace.

<img width="800" alt="Testing" src="https://raw.githubusercontent.com/gorules/zen/master/.github/images/tests.png">

## Requirements

- iOS 16.0+
- Swift 5.9+

## Contribution

The JDM standard is growing and we need to keep tight control over its development and roadmap, as a number of companies use GoRules ZEN Engine and GoRules BRMS. For this reason we can't accept code contributions at this moment, apart from help with documentation and additional tests.

## License

[MIT License](https://opensource.org/licenses/MIT)

## Support

For issues and questions, please visit [github.com/gorules/zen-ios/issues](https://github.com/gorules/zen-ios/issues).
