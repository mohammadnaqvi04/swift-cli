import PathKit
import SwiftCLI
import ToolCore

class ListCommand: ToolCommand {

    let name = "list"
    let shortDescription = "Lists all functions"

    func execute(path: Path, ToolFile: ToolFile) throws {
        stdout <<< "Functions:"
        stdout <<< ""
        ToolFile.functions.forEach { function in
            stdout <<< "  \(function.name): \(function.docsDescription ?? "")"
        }
        stdout <<< ""
    }
}
