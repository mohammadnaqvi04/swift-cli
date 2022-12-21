import PathKit
import SwiftCLI
import ToolCore

struct GlobalOptions {
    static let path = Key<String>("-p", "--path", description: "The path to a swift file. Defaults to Tool.swift")
    private init() {}
}

protocol ToolCommand: Command {
    func execute(path: Path, ToolFile: ToolFile) throws
}

extension ToolCommand {

    var path: Key<String> {
        return GlobalOptions.path
    }

    func execute() throws {
        let path = Path(self.path.value ?? "Tool.swift").normalize()
        let ToolFile = try ToolFile(path: path)
        try execute(path: path, ToolFile: ToolFile)
    }

}
