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
        let path = app.directory.publicDirectory + "processing/" + randomized + "_" + input.file.filename
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
//                        let result = isHotDog(path: path)
//                        let response = ClassifiedResponse(request: ClassifiedData(result: result))
//                        return response
                        return req.view.render("classify")

//                        return randomString(length: 10)
                    }
            }
    }
}

struct ClassifiedData: Content {
    let result: String
}

struct ClassifiedResponse: Content {
    let request: ClassifiedData
}
