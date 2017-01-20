CommandAndControlController = require './controllers/command-and-control-controller'

class Router
  constructor: ({@commandAndControlService}) ->
    throw new Error 'Missing commandAndControlService' unless @commandAndControlService?

  route: (app) =>
    commandAndControlController = new CommandAndControlController {@commandAndControlService}

    app.get '/hello', commandAndControlController.hello
    # e.g. app.put '/resource/:id', someController.update

module.exports = Router
