import PathKit

public struct ToolOptions {

    public let cachePath: Path
    public let packageName: String

    public init(cachePath: Path = "~/.Tool/builds", packageName: String = "ToolFile") {
        self.cachePath = cachePath.normalize()
        self.packageName = packageName
    }
}
