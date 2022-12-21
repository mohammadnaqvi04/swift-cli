import ToolCore
import SwiftCLI

extension ToolError: ProcessError {

    public var message: String? {
        return "⚠️  \(description)"
    }

    public var exitStatus: Int32 {
        return 1
    }

}
