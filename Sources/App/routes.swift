import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return req.view.render("index", ["hotdogs": countFiles(path: app.directory.publicDirectory + "hot/"), "not_hotdogs": countFiles(path: app.directory.publicDirectory + "not/")])
    }
    
    app.post("classify") { req -> EventLoopFuture<View> in
        struct Input: Content {
            var file: File
        }

        let input = try req.content.decode(Input.self)

        guard input.file.data.readableBytes > 0 else {
            throw Abort(.badRequest)
        }

        let randomized = randomString(length: 10)
        let cleanName = String(input.file.filename.map {
            $0 == " " ? "_" :$0
        })
        let path = app.directory.publicDirectory + "processing/" + randomized + "_" + cleanName
        return req.application.fileio.openFile(path: path,
                                               mode: .write,
                                               flags: .allowFileCreation(posixMode: 0x744),
                                               eventLoop: req.eventLoop)
            .flatMap { handle in
                req.application.fileio.write(fileHandle: handle,
                                             buffer: input.file.data,
                                             eventLoop: req.eventLoop)
                    .flatMap { _ in
                        do {
                            try handle.close()
                        } catch {
                        }
                        let (_, result, _, name) = isHotDog(path: path)
                        // name the result
                        let fixedPath = fixPath(name)
                        var resultString: String
                        switch result {
                        case "hot_dog":
                            resultString = "Hot Dog!"
                            break
                        case "not_hot_dog":
                            resultString = "Not Hot Dog!"
                            break
                        default:
                            resultString = "Something went wrong!"
                        }
                        
                        let hdogs = String(countFiles(path: app.directory.publicDirectory + "hot/"))
                        let nhdogs = String(countFiles(path: app.directory.publicDirectory + "not/"))
                        return req.view.render("classify",
                                               ["result": resultString,
                                                "imageSource": fixedPath,
                                                "hotdogs": hdogs,
                                                "not_hotdogs": nhdogs,

                        ])
                    }
            }
    }
}

struct ClassifiedData: Content {
    let status: Int
    let result: String
    let confidence: [String : Double]
    let name: String
}

func fixPath(_ path: String) -> String {
    print(path)
    var separatedPath = path.components(separatedBy: "/")
    print(separatedPath)
    separatedPath.removeFirst(1)
    print(separatedPath)
    let newPath = separatedPath.joined(separator: "/")
    print(newPath)
    return "/" + newPath
}
