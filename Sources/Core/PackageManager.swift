import Foundation
import PathKit

public class PackageManager {

    public var path: Path
    public var name: String
    public var ToolFile: ToolFile

    public var sourcesPath: Path { return path + "Sources" }
    public var packagePath: Path { return path + "Package.swift" }
    public var mainFilePath: Path { return sourcesPath + "\(name)/main.swift" }

    public init(path: Path, name: String, ToolFile: ToolFile) {
        self.path = path
        self.name = name
        self.ToolFile = ToolFile
    }

    public func write(functionCall: String?) throws {
        try write()

        var swiftFile = ToolFile.contents
        if let functionCall = functionCall {
            swiftFile += "\n\n" + functionCall
        }
        try mainFilePath.writeIfUnchanged(swiftFile)
    }

    public func write(filePath: Path) throws {
        try write()

        try? mainFilePath.delete()
        try mainFilePath.writeIfUnchanged(ToolFile.contents)
    }

    func write() throws {
        try path.mkpath()
        try mainFilePath.parent().mkpath()
        let package = PackageManager.createPackage(name: name, ToolFile: ToolFile)
        try packagePath.writeIfUnchanged(package)
    }

    public static func createPackage(name: String, ToolFile: ToolFile) -> String {
        let dependenciesString = ToolFile.dependencies.map { ".package(url: \($0.package.quoted), \($0.requirement))," }.joined(separator: "\n        ")
        let librariesString = ToolFile.libraries.map { "\($0.quoted)," }.joined(separator: "\n                ")
        return """
        // swift-tools-version:5.0

        import PackageDescription

        let package = Package(
            name: \(name.quoted),
            platforms: [
                .macOS(.v10_13),
            ],
            dependencies: [
                \(dependenciesString)
            ],
            targets: [
                .target(
                    name: \(name.quoted),
                    dependencies: [
                        \(librariesString)
                    ]
                )
            ]
        )
        """
    }
}

extension Path {

    func writeIfUnchanged(_ string: String) throws {
        if let existingContent: String = try? read() {
            if existingContent == string {
                return
            }
        }
        try write(string)
    }
}
