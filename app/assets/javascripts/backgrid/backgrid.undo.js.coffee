Backgrid.Command::undo = ->
  return (this.keyCode is 90 and this.ctrlKey)
Backgrid.Command::redo = ->
  return (this.keyCode is 89 and this.ctrlKey)

class Backgrid.Undo extends Backbone.View
  undoStack: []
  redoStack: []
  el: window

  events: {
    "keydown": "changeState"
  }

  push: (model) ->
    @redoStack = []
    key = _.keys(model.changedAttributes())[0]
    from = model.previousAttributes()[key]
    to = model.changedAttributes()[key]
    @undoStack.push({
      model: model
      key: key
      from: from
      to: to
      })

  pop: ->
    return false if @undoStack.length == 0
    pop = @undoStack.pop()
    @redoStack.push(pop)
    return pop

  repush: ->
    return false if @redoStack.length == 0
    pop = @redoStack.pop()
    @undoStack.push(pop)
    return pop

  changeState: (event) ->
    command = new Backgrid.Command(event)
    if command.undo()
      @undo()
    if command.redo()
      @redo()

  undo: () ->
    changes = @pop()
    changes.model.set(changes.key, changes.from, {undo: true}) if changes

  redo: () ->
    changes = @repush()
    changes.model.set(changes.key, changes.to, {undo: true}) if changes

Eventplanner.Undo = new Backgrid.Undo()

class Backbone.UndoModel extends Backbone.Model
  undo: Eventplanner.Undo
  
  initialize: ->
    Backbone.Model.prototype.initialize.apply(this, arguments)
    this.on "change", (model, options) ->
      @undo.push(model) if !options.undo
      if options and options.save is false
        return
      $(".save-indicator").text("saving...")
      model.save(null, {
        success: (e) ->
          $(".save-indicator").text("saved - " + moment().calendar())
        }) if model.hasChanged()