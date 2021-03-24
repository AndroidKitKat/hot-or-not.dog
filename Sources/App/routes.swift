import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return req.view.render("index", ["hotdogs": countFiles(path: app.directory.publicDirectory + "hot/"), "not_hotdogs": countFiles(path: app.directory.publicDirectory + "not/")])
    }

    
    app.get("upload") { req in
        return req.view.render("upload", ["title": "Upload Picture"])
    }
    
    app.post("upload") { req -> EventLoopFuture<View> in
        struct Input: Content {
            var file: File
        }

        let input = try req.content.decode(Input.self)

        guard input.file.data.readableBytes > 0 else {
            throw Abort(.badRequest)
        }

        let randomized = randomString(length: 10)
        let path = app.directory.publicDirectory + "processing/" + randomized + "_" + input.file.filename
        return req.application.fileio.openFile(path: path,
                                               mode: .write,
                                               flags: .allowFileCreation(posixMode: 0x744),
                                               eventLoop: req.eventLoop)
            .flatMap { handle in
                req.application.fileio.write(fileHandle: handle,
                                             buffer: input.file.data,
                                             eventLoop: req.eventLoop)
                    .flatMapThrowing { _ in
                        try handle.close()
//                        return path
                        return req.view.render("result", [
                            "result": "test"
                        ])
                    }
            }
    }
}
