import PerfectHTTP
import PerfectHTTPServer

func rootHandler(request: HTTPRequest, response: HTTPResponse) {
    response.setHeader(.contentType, value: "text/html")
    response.appendBody(string: "<html><title>PerfectHTTP</title><body>Hello, PerfectHTTP!</body></html>")
    response.completed()
}

func apiHandler(request: HTTPRequest, response: HTTPResponse) {
        if authorized(request) {
            response.next()
        } else {
            response.completed()
        }
}

func authorized(_: HTTPRequest) -> Bool {
    return true
}

func verHandler(request: HTTPRequest, response: HTTPResponse) {
    response.next()
}

func userHandler(request: HTTPRequest, response: HTTPResponse) {
    if let id = request.urlVariables["id"] {
        print("do \(request.method) to user:\(id)")
    } else {
        print("do \(request.method) to users")
    }
    response.setHeader(.contentType, value: "text/html")
    response.appendBody(string: "<html><title>PerfectHTTPServer</title><body>\(request.method):\(String(describing: request.urlVariables["id"]))</body></html>")
    response.completed()
}

func storyHandler(request: HTTPRequest, response: HTTPResponse) {
    if let id = request.urlVariables["id"] {
        print("do \(request.method) to story:\(id)")
    } else {
        print("do \(request.method) to stories")
    }
    response.setHeader(.contentType, value: "text/html")
    response.appendBody(string: "<html><title>PerfectHTTPServer</title><body>\(request.method):\(String(describing: request.urlVariables["id"]))</body></html>")
    response.completed()
}

do {
    var routes = Routes()
    // root
    routes.add(method: .get, uri: "/", handler: rootHandler)
    routes.add(method: .get, uri: "/**", handler: StaticFileHandler(documentRoot: "./webroot", allowResponseFilters: true).handleRequest)
    // api
    var apiRoutes = Routes(baseUri: "/api", handler: apiHandler)
    // ver
    var verRoutes = Routes(baseUri: "/v1", handler: verHandler)
    // users
    verRoutes.add(uris: ["/users", "/users/{id}"], handler: userHandler)
    // stories
    verRoutes.add(uris: ["/stories", "/stories/{id}"], handler: storyHandler)
    apiRoutes.add(verRoutes)
    
    
    routes.add(apiRoutes)
    
    try HTTPServer.launch(name: "localhost",
                          port: 8181,
                          routes: routes,
                          responseFilters: [
                            (PerfectHTTPServer.HTTPFilter.contentCompression(data: [:]), HTTPFilterPriority.high)
                          ])
} catch {
    fatalError("\(error)")
}

/// GET方法向特定路由发出请求，其中从客户端发向服务器的所有参数包含在URL字符串中。使用GET方法发出的请求只能接收数据，不能由其它作用。使用GET请求来删除数据库的一条记录是可行的，但是不推荐这么做。
/// POST方法通常用于向数据库内发送创建一条新记录的表单，比如在一个网站上填写好一个表单后提交给服务器。每个表单中都有成对出现的字段名和字段值，便于API服务器读取这些变量信息。
/// PATCH方法整体上来说和POST差不多，但是用于更新记录，而不是新建记录。
/// PUT方法主要用于上传文件，一个典型的PUT请求通常会在其消息体内部包含一个即将发给服务器的文件。
/// DELETE请求用于通知API服务器删除特定资源。通常在其URL中会包含一个唯一的标识信息。
