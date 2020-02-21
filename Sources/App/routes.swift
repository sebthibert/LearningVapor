import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "Hello my name is Seb 🙋🏽‍♂️ I like cheese 🧀"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)

  router.get("api", "first_name", String.parameter, "last_name", String.parameter) { req -> String in
    let firstName = try req.parameters.next(String.self)
    let lastName = try req.parameters.next(String.self)
    return "Your name is \(firstName) \(lastName)"
  }

  struct Person: Content {
      let firstName: String
      let lastName: String?
  }

  router.post(Person.self, at: "api/name") { req, data -> Person in
      return data
  }

  struct Cheese: Content {
    let name: String
    let smellIntensity: Int
  }

  router.get("cheese") { req in
    return [Cheese(name: "Cheddar", smellIntensity: 2), Cheese(name: "Brie", smellIntensity: 3)]
  }

  struct MovieList: Content {
    let page: Int?
    let results: [Movie]?
  }

  struct Movie: Content {
    let title: String?
    let overview: String?
  }

  router.get("status") { req -> Future<MovieList> in
    let client = try req.make(Client.self)
    let response = client.get("https://api.themoviedb.org/3/movie/now_playing?api_key=f7caebd7ef3ee2bd2ca8ecfc1cb67a2c&language=en-US&page=1")

    return response.flatMap(to: MovieList.self, { response in
      return try response.content.decode(MovieList.self)
    })
  }

  let tmdbController = TMDBController()
  router.get("movies", use: tmdbController.movies)
  router.get("toes", use: tmdbController.toes)
}
