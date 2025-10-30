# Zen iOS Package (WIP)

A Swift package for integrating Zen rules engine into iOS applications.

## Installation

### Swift Package Manager

Add the package to your project using Xcode:

1. Open your project in Xcode
2. Go to **File → Add Package Dependencies...**
3. Enter the repository URL:
   ```
   https://github.com/gorules/zen-ios
   ```
4. Select the version you want to use
5. Click **Add Package**

Or add it to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/gorules/zen-ios", from: "0.0.9")
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

## Usage

### Import the Package

```swift
import ZenUniffi
```

### Evaluate Simple Expressions

```swift
// Evaluate a simple expression
let expression = "2 + 2"
let context: JsonBuffer? = nil
let result = try evaluateExpression(expression: expression, context: context)

// Convert result to string
if let resultString = String(data: result, encoding: .utf8) {
    print("Result: \(resultString)")
}
```

### Create and Use Decision Engine

```swift
// Create engine instance
let loader: ZenDecisionLoaderCallback? = nil
let customNode: ZenCustomNodeCallback? = nil
let engine = ZenEngine(loader: loader, customNode: customNode)

// Define your decision JSON
let decisionJson = """
{
  "nodes": [
    {
      "type": "inputNode",
      "content": {
        "schema": ""
      },
      "id": "e80a9ddd-2f6b-4a24-9822-b0931a47944d",
      "name": "request",
      "position": {
        "x": 450,
        "y": 275
      }
    },
    {
      "type": "decisionTableNode",
      "content": {
        "hitPolicy": "first",
        "rules": [
          {
            "_id": "c5844d99-af9a-48e8-9146-3cfc396e84ff",
            "aa52b906-c849-40e0-94b7-d89e69e91445": "age > 20",
            "7358a39f-5d6a-4e97-9566-fa207cedd99a": "true"
          },
          {
            "_id": "cb0559cd-4e49-41b5-9994-eacccb6a4f69",
            "aa52b906-c849-40e0-94b7-d89e69e91445": "",
            "7358a39f-5d6a-4e97-9566-fa207cedd99a": "false"
          }
        ],
        "inputs": [
          {
            "id": "aa52b906-c849-40e0-94b7-d89e69e91445",
            "name": "Input"
          }
        ],
        "outputs": [
          {
            "id": "7358a39f-5d6a-4e97-9566-fa207cedd99a",
            "name": "Output",
            "field": "output"
          }
        ],
        "passThrough": true,
        "inputField": null,
        "outputPath": null,
        "executionMode": "single",
        "passThorough": false
      },
      "id": "5700f66f-698e-4b5c-bd5f-15086eb67c9c",
      "name": "decisionTable1",
      "position": {
        "x": 765,
        "y": 275
      }
    }
  ],
  "edges": [
    {
      "id": "f9cc7d2d-88df-497e-9f74-699d3fcc56dc",
      "sourceId": "e80a9ddd-2f6b-4a24-9822-b0931a47944d",
      "type": "edge",
      "targetId": "5700f66f-698e-4b5c-bd5f-15086eb67c9c"
    }
  ]
}
"""

// Define context
let contextJson = #"{"age": 21}"#

// Convert to Data
guard let decisionData = decisionJson.data(using: .utf8),
      let contextData = contextJson.data(using: .utf8) else {
    throw NSError(domain: "ZenError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert JSON"])
}

// Create decision
let decision = try engine.createDecision(content: decisionData)

// Evaluate decision
let result = try await decision.evaluate(
    context: contextData,
    options: nil
)

// Access results
if let resultString = String(data: result.result, encoding: .utf8) {
    print("Decision result: \(resultString)")
}
print("Performance: \(result.performance)")
```


## Advanced Usage

### Caching Decisions with a Loader

For better performance, you can cache decisions in a HashMap and load them on demand. This is useful when you need to load decision models from remote storage or files.

#### Step 1: Pre-load and Cache Decisions

```swift
import ZenUniffi

class DecisionManager {
    private let engine: ZenEngine
    private var decisionCache: [String: ZenDecision] = [:]
    
    init() {
        // Create engine with a loader callback
        let loader: ZenDecisionLoaderCallback = { [weak self] key in
            // Return cached decision for the given key
            return self?.decisionCache[key]
        }
        
        self.engine = ZenEngine(loader: loader, customNode: nil)
    }
    
    /// Load decision from remote storage and cache it
    func loadAndCacheDecision(path: String, content: Data) throws {
        // Create decision from JSON content
        let decision = try engine.createDecision(content: content)
        
        // Cache it with the path as key
        decisionCache[path] = decision
        
        print("✅ Cached decision at path: \(path)")
    }
    
    /// Load multiple decisions from remote storage (e.g., downloaded as a zip file)
    func loadDecisionsFromRemote() async throws {
        // Step 1: Download zip file from remote server
        // let zipData = try await downloadDecisionsZip(from: "https://api.example.com/decisions.zip")
        
        // Step 2: Extract zip file
        // let extractedFiles = try extractZipFile(zipData)
        
        // Step 3: Load each decision file and cache it
        // Pseudo code for processing extracted files:
        /*
        for (filePath, fileContent) in extractedFiles {
            // filePath example: "rules/age-verification.json"
            // fileContent is the JSON Data
            try loadAndCacheDecision(path: filePath, content: fileContent)
        }
        */
        
        // Example with mock data:
        let mockDecisions: [(String, Data)] = [
            ("rules/age-verification", """
                {
                  "contentType": "application/vnd.gorules.decision",
                  "nodes": [...],
                  "edges": [...]
                }
                """.data(using: .utf8)!),
            ("rules/pricing", """
                {
                  "contentType": "application/vnd.gorules.decision",
                  "nodes": [...],
                  "edges": [...]
                }
                """.data(using: .utf8)!),
            ("rules/eligibility", """
                {
                  "contentType": "application/vnd.gorules.decision",
                  "nodes": [...],
                  "edges": [...]
                }
                """.data(using: .utf8)!)
        ]
        
        for (path, content) in mockDecisions {
            try loadAndCacheDecision(path: path, content: content)
        }
    }
    
    /// Evaluate a decision by its path
    func evaluate(path: String, context: Data) async throws -> ZenDecisionResult {
        guard let decision = decisionCache[path] else {
            throw NSError(domain: "DecisionManager", code: 404, 
                         userInfo: [NSLocalizedDescriptionKey: "Decision not found: \(path)"])
        }
        
        return try await decision.evaluate(context: context, options: nil)
    }
}
```

#### Step 2: Use the Decision Manager

```swift
// Initialize manager
let manager = DecisionManager()

// Load all decisions on app startup
Task {
    try await manager.loadDecisionsFromRemote()
}

// Later, evaluate a specific decision
Task {
    let contextJson = #"{"age": 25}"#
    guard let contextData = contextJson.data(using: .utf8) else { return }
    
    let result = try await manager.evaluate(
        path: "rules/age-verification",
        context: contextData
    )
    
    if let resultString = String(data: result.result, encoding: .utf8) {
        print("Result: \(resultString)")
    }
}
```

## Requirements

- iOS 16.0+
- Xcode 14.0+
- Swift 5.9+

## License

MIT: See the LICENSE file for details.

## Support

For issues and questions, please visit: https://github.com/gorules/zen-ios/issues
