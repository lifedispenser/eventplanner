Backgrid.LinkFormatter = {
  fromRaw: (raw) ->
    if(raw) 
      return "#" + raw.toString() 
    return ""

  toRaw: (data) ->
    return data
  }

#Todo - make a better URICell!
Backgrid.EditLinkFormatter = {
  fromRaw: (raw) ->
    if(raw) 
      return "#" + raw.toString() 
    return ""

  toRaw: (data) ->
    return data
  }
