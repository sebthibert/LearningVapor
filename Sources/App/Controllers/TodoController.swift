import Vapor

/// Controls basic CRUD operations on `Todo`s.
final class TodoController {
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[Todo]> {
        return Todo.query(on: req).all()
    }

    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request) throws -> Future<Todo> {
        return try req.content.decode(Todo.self).flatMap { todo in
            return todo.save(on: req)
        }
    }

    /// Deletes a parameterized `Todo`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Todo.self).flatMap { todo in
            return todo.delete(on: req)
        }.transform(to: .ok)
    }
}

final class TMDBController {
  struct Cheese: Content {
    let name: String
  }

  func movies(_ req: Request) throws -> Cheese {
    return Cheese(name: "Cheddar")
  }

  func toes(_ req: Request) throws -> Future<Response> {
    let client = try req.client()
    return client.get("https://api.themoviedb.org/3/movie/now_playing?api_key=f7caebd7ef3ee2bd2ca8ecfc1cb67a2c&language=en-US&page=1")
  }
}
