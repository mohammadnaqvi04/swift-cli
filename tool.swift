// tool: kareman/SwiftShell @ 5.0.0
// tool: sharplet/Regex @ 2.0.0
// tool: kylef/PathKit @ 1.0.0

import Foundation
import SwiftShell
import Regex
import PathKit


/// Formats all the code in the project
public func formatCode() throws {
    let formatOptions = "--wraparguments beforefirst --stripunusedargs closure-only --header strip --disable sortedImports,blankLinesAtEndOfScope,blankLinesAtStartOfScope"
    try runAndPrint(bash: "swiftformat Sources \(formatOptions)")
    try runAndPrint(bash: "swiftformat Tests \(formatOptions)")
}


public func install(directory: String = "/usr/local/bin") throws {
    print("Building tool...")
    let output = run(bash: "swift build --disable-sandbox -c release")
    if let error = output.error {
        print("Couldn't build:\n\(error)")
        return
    }
    try runAndPrint(bash: "cp -R .build/release/\(tool) \(directory)/\(tool)")
    print("🐦  Installed tool!")
}

public func updateBrew(_ version: String) throws {
  let releaseTar = "\(repo)/archive/\(version).tar.gz"
  let output = run(bash: "curl -L -s \(releaseTar) | shasum -a 256 | sed 's/ .*//'")
  guard output.succeeded else {
    print("Error retrieving brew SHA")
    return
  }
  let sha = output.stdout

  try replaceFile(
      regex: "(url \".*/archive/)(.*).tar.gz",
      replacement: "$1\(version).tar.gz",
      path: "Formula/tool.rb")

  try replaceFile(
      regex: "sha256 \".*\"",
      replacement: "sha256 \"\(sha)\"",
      path: "Formula/tool.rb")

  run(bash: "git add Formula/tool.rb")
  run(bash: "git commit -m \"Updated brew to \(version)\"")
}

/// Releases a new version of tool
///
/// - Parameters:
///   - version: The version to release
public func release(_ version: String) throws {

    try replaceFile(
        regex: "public let version: String = \".*\"",
        replacement: "public let version: String = \"\(version)\"",
        path: "Sources/toolCLI/toolCLI.swift")

    run(bash: "git add Sources/toolCLI/toolCLI.swift")
    run(bash: "git commit -m \"Updated to \(version)\"")
    run(bash: "git tag \(version)")

    print("Released version \(version)!")
}

func replaceFile(regex: String, replacement: String, path: Path) throws {
    let regex = try Regex(string: regex)
    let contents: String = try path.read()
    let replaced = contents.replacingFirst(matching: regex, with: replacement)
    try path.write(replaced)
}

func runMint(package: String, command: String?) {

}
