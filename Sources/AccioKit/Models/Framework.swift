import Foundation
import SwiftShell

struct Framework {
    let projectName: String
    let libraryName: String
    let projectDirectory: String
    let requiredFrameworks: [Framework]

    var commitHash: String {
        return run(bash: "git --git-dir '\(projectDirectory)/.git' rev-parse HEAD").stdout
    }

    func xcodeProjectPath() throws -> String {
        let rootFileNames: [String] = ["\(projectName).xcworkspace", "\(projectName).xcodeproj"] + (try FileManager.default.contentsOfDirectory(atPath: projectDirectory))

        let workspaceFileNames = rootFileNames.filter { $0.hasSuffix(".xcworkspace") }
        let projectFileNames = rootFileNames.filter { $0.hasSuffix(".xcodeproj") }

        let xcodeFileNames = workspaceFileNames + projectFileNames
        return xcodeFileNames.first { xcodeFileName in
            let sharedSchemesDirPath = URL(fileURLWithPath: projectDirectory).appendingPathComponent("\(xcodeFileName)/xcshareddata/xcschemes").path
            return FileManager.default.fileExists(atPath: sharedSchemesDirPath)
        }!
    }
}
