import HTTPServer
import Router
import LogMiddleware
import HTTPFile
import Mustache
import Sideburns

let log = Log()
let logMiddleware = LogMiddleware(log: log)

let router = Router(middleware: logMiddleware) { route in
	route.get("/") { request in
		let data: [String: Any] = [
			"title": "Título da Página",
			"description": "Renderizando HTML usando Sideburns",
			"messages": [ 
				[
					"author": "Patrick", 
					"message": "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
				],
				[
					"author": "Senhor Sirigueijo", 
					"message": "Morbi luctus urna vel lacus malesuada posuere."
				],
				[
					"author": "Lula Molusco", 
					"message": "Praesent dignissim nunc a convallis posuere."
				],
				[
					"author": "Bob Esponja", 
					"message": "Nam facilisis arcu at consequat sagittis."
				]
			]
		]
		return try Response(templatePath: "public/hello.html", templateData: data)
	}
	route.fallback = FileResponder(basePath: "public")
}

try Server(port: 8080, responder: router).start()


