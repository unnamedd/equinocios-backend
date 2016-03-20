import HTTPServer
import Router
import LogMiddleware
import HTTPFile
import ContentNegotiationMiddleware
import LogMiddleware
import JSONMediaType
import InterchangeData
import BasicAuthMiddleware

let log                 = Log()
let logMiddleware       = LogMiddleware(log: log)
let contentNegotiaton   = ContentNegotiationMiddleware(mediaTypes: JSONMediaType())

let basicAuth = BasicAuthMiddleware { username, password in
    if username == "admin" && password == "password" {
        return .Authenticated
    }
    
    return .AccessDenied
}

let router = Router(middleware: logMiddleware, contentNegotiaton, basicAuth) { route in
    
    var items: [InterchangeData] = [
        ["id": "1", "description": "Comprar frutas"],
        ["id": "5", "description": "Pagar condomínio"],
        ["id": "3", "description": "Despachar encomenda"],
        ["id": "6", "description": "Assistir Deadpool"],
        ["id": "4", "description": "Ir ao banco"],
        ["id": "2", "description": "Ligar para operadora"]
    ]
    
    func get(id: String) throws -> InterchangeData {
        let list = items.filter({ $0["id"]!.string == id })

        guard let todo = list.first else {
            return nil
        }
        
        return todo
    }
    
    // cria o novo registro de uma tarefa
    route.post("/todo") { request in
        let body        = request.content!
        
        let id          = InterchangeData.from(String(arc4random()))
        let description = body["description"]
        
        let todo: InterchangeData = [
            "id"          : id,
            "description" : description!
        ]
        
        items.append(todo)
        
        return Response(status: .Created, content: todo)
    }
    
    // Lista todas os registros de tarefas
    route.get("/todo") { request in
        items = items.sort({ $0["id"]!.string < $1["id"]!.string })
        
        guard items.count > 0 else {
            return Response(status: .NoContent)
        }
        
        return Response(content: InterchangeData.from(items))
    }
    
    // busca os dados de uma tarefa baseado no id
    route.get("/todo/:id") { request in
        let path = request.pathParameters
        
        let todo = try get(path["id"]!)
        guard todo != nil else {
            return Response(status: .NotFound)
        }
        
        return Response(content: todo)
    }
    
    // atualiza uma tarefa baseado no id
    route.put("/todo/:id") { request in
        let path = request.pathParameters
        let body = request.content!
        
        var todo = try get(path["id"]!)
        guard todo != nil else {
            return Response(status: .NotFound)
        }
        
        let index = items.indexOf(todo)!
        todo["description"] = body["description"]
        items[index] = todo
        
        return Response(status: .NoContent)
    }
    
    // exclui uma tarefa baseado no id
    route.delete("/todo/:id") { request in
        let path = request.pathParameters
        
        let todo = try get(path["id"]!)
        guard todo != nil else {
            return Response(status: .NotFound)
        }
        
        let index = items.indexOf(todo)!
        guard items.removeAtIndex(index) != nil else {
            return Response(status: .NotFound)
        }
        
        return Response(status: .NoContent)
    }
}

try Server(port: 8080, responder: router).start()