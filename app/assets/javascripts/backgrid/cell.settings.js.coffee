class Backgrid.SettingsCell extends Backgrid.Cell

  events:
    "click" : "openMenu"
    "click .deleteRow" : "deleteRow"
    "click .insertRowAbove" : "insertRowAbove"
    "click .insertRowBelow" : "insertRowBelow"
    "click .indentRow" : "indentRow"
    "click .unIndentRow" : "unIndentRow"


  render: ->
    @$el.empty()
    @$el.attr("model_id", @model.get("id"))
    @$el.addClass("settings")
    indent = ""
    indent = "&nbsp;|&nbsp; <a class='indentRow'>Indent</a></li>" if @model.collection.indexOf(@model) != 0
    indent = "&nbsp;|&nbsp; <a class='unIndentRow'>UnIndent</a></li>" if _.isNumber(@model.get("child"))
    ul = $("<div class='wrapper'>
      <ul class='menu-settings ui-menu'>
        <li><a class='insertRowAbove'>Insert Row Above</a></li>
        <li><a class='deleteRow'>Delete</a> " + 
        indent +
        "<li><a class='insertRowBelow'>Insert Row Below</a></li>
      </ul>
      </div>
    ")
    @$el.append(ul)
    $(document).on("click", @closeMenu)
    @delegateEvents();
    return this

  openMenu: (e) ->
    $(".menu-settings").each(() ->
      this.style.display = 'none'
      )
    menu = $(e.target).find(".menu-settings")
    if menu.length > 0
      menu[0].style.top = "-" + (menu.height() - $(e.target).height())/2 + "px"
      menu[0].style.display = 'block'
    that = this

  closeMenu: (e) ->
    if !($(e.target).hasClass("menu-settings") or $(e.target).parents(".menu-settings").length > 0 or $(e.target).children(".menu-settings").length > 0)
      $(".menu-settings").each(() ->
        this.style.display = "none" 
      )

  deleteRow: (e) ->
    @model.destroy() if (window.confirm("Are you sure you want to delete this row?"))
    @$el.trigger("saveAndRefresh")
    @model.collection.trigger("refresh:classes")

  insertRowBelow: (e) ->
    model = @addNewRow()
    index = @model.collection.indexOf(@model) + 1
    @model.collection.once("sync", () ->
      @.model.collection.move(model, index)
      @$el.trigger("saveAndRefresh")  
    , this)

  insertRowAbove: (e) ->
    model = @addNewRow()
    index = @model.collection.indexOf(@model)
    @model.collection.once("sync", () ->
      @model.collection.move(model, index)
      @$el.trigger("saveAndRefresh")  
    , this)

  addNewRow: () ->
    model = @model.collection.create({
      event_id: @model.collection.event.get('id')
    }, {wait: true})
    return model

  indentRow: (e) ->
    if(@model.collection.indexOf(@model) > 0)
      @$el.find(".indentRow").removeClass("indentRow").addClass("unIndentRow").text("UnIndent")
      @model.set({child: 1})
      @model.collection.trigger("refresh:classes")
    

  unIndentRow: (e) ->
    @$el.find(".unIndentRow").removeClass("unIndentRow").addClass("indentRow").text("Indent")
    @model.set({child: null })
    @model.collection.trigger("refresh:classes")
    