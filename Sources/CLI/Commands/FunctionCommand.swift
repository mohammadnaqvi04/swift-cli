fimport PathKit
import SwiftCLI
import ToolCore

class FunctionCommand: ToolCommand {

    let name = "function"
    let shortDescription = "Info about a specific function"

    let functionName = Parameter()

    func execute(path: Path, ToolFile: ToolFile) throws {
        guard let function = ToolFile.functions.first(where: { $0.name == functionName.value }) else {
            throw ToolError.invalidFunction(functionName.value)
        }
        stdout <<< "\(function.name):\(function.docsDescription != nil ? " \(function.docsDescription!)" : "")"
        function.params.forEach { param in
            stdout <<< "  \(param.name): \(param.optionalType)\(param.defaultValue != nil ? " = \(param.defaultValue!)" : "")\(param.description != nil ? "  - \(param.description!)" : "")"
        }
    }
}
