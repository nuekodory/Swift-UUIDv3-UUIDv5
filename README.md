# Swift+UUIDv3+UUIDv5
Tiny Swift code to generate namespace-based UUID (UUID version3 and 5) using CommonCrypto.

Compatible with Swift3/4/5

# Usage
Just put UUIDv3v5.swift on your project.

# Sample Code
```swift
import Foundation       // use UUID defined in Foundation

let dnsUuid = UUID(uuidVersion: 3, namespace: UUID.namespace.DNS, name: "github.com")
let urlUuid = UUID(uuidVersion: 5, namespace: UUID.namespace.URL, name: "https://github.com/nuekodory/Swift-UUIDv3-UUIDv5/")
// dnsUuid: UUID? = 7F4771A0-1982-373D-928F-D31140A51652
// urlUuid: UUID? = C6E8FD06-74BB-504E-8550-A4C64F6294B9
```

# Requirements
- `import CommonCrypto` requires Swift4.2 or later.
- For <Swift4.2 users, read this question: https://stackoverflow.com/questions/38584416/where-can-i-get-commoncrypto-commoncrypto-file-from
