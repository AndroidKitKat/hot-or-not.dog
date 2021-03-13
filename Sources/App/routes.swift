import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return req.view.render("index", ["title": "Hello Vapor!"])
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    app.get("upload") { req in
        return req.view.render("upload", ["title": "Upload Picture"])
    }
    
    app.post("upload") { req -> EventLoopFuture<String> in
        struct Input: Content {
            var file: File
        }
        
        let input = try req.content.decode(Input.self)
        
        guard input.file.data.readableBytes > 0 else {
            throw Abort(.badRequest)
        }
        
        let path = app.directory.publicDirectory + input.file.filename
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
                        return is_hotdog(image: "Public/" + input.file.filename)
                    }
            }
    }
}
