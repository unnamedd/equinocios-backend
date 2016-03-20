import HTTPServer
import Router
import LogMiddleware

let log = Log()
let logMiddleware = LogMiddleware(log: log)

let router = Router(middleware: logMiddleware) { route in
	route.get("/") { request in
		return Response(body: "Hello World!")
	}
}

try Server(port: 8080, responder: router).start()
