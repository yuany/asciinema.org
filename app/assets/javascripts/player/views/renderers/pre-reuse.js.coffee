class AsciiIo.Renderer.PreReuse extends AsciiIo.Renderer.Pre

  createChildElements: ->
    i = 0

    while i < @lines
      row = $("<span class=\"line\">")

      j = 0
      while j < @cols
        cell = $('<span>')
        row.append cell
        j++

      @$el.append row
      @$el.append "\n"
      i++

    @$lines = @$('.line')

  renderLine: (n, fragments, cursorX) ->
    html = []
    rendered = 0

    line = @$lines[n]
    spans = line.children

    i = 0
    for fragment in fragments
      [text, brush] = fragment

      t = @escape(text)

      spans[i].innerHTML = t

      if brush
        brush = AsciiIo.Brush.create brush
        if brush != AsciiIo.Brush.default()
          spans[i].className = @classForBrush brush
        else
          spans[i].className = ''
      else
        spans[i].className = ''

      i++

    while i < @cols
      spans[i].innerHTML = ''
      i++
