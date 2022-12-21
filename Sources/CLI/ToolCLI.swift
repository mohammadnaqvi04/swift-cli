import SwiftCLI
import ToolCore
import Foundation

public class ToolCLI {

    public let version: String = "0.5.1"
    public let options: ToolOptions

    public init(options: ToolOptions) {
        self.options = options
    }

    public func execute(arguments: [String]? = nil) {
        let cli = CLI(name: "Tool", version: version, description: "Tool can inspect and run functions in your swift scripts")
        cli.globalOptions.append(GlobalOptions.path)
        cli.commands = [
            ListCommand(),
            FunctionCommand(),
            RunCommand(options: options),
            EditCommand(options: options),
        ]

        let status: Int32
        if let arguments = arguments {
            status = cli.go(with: arguments)
        } else {
            status = cli.go()
        }
        exit(status)
    }
}
