import SourceKittenFramework

public enum ToolError: Error, CustomStringConvertible {
    case fileNotFound(String)
    case compileError(String)
    case invalidFunction(String)
    case missingRequiredParam(Function.Param)
    case parsingError(SwiftStructure)
    case conversionError(Function.Param, String)

    public var description: String {
        switch self {
        case let .fileNotFound(file): return "File not found: \(file)"
        case let .compileError(error): return "File could not be compiled: \(error)"
        case let .invalidFunction(function): return "Function \(function) was not found"
        case let .missingRequiredParam(param): return "Missing required param \(param.name)"
        case let .parsingError(structure): return "Could not parse Tool file structure:\n\(toJSON(structure))"
        case let .conversionError(param, value): return "'\(value)' is not convertible to \(param.type.string) for argument \(param.name)"
        }
    }

}
