class AsciiIo.Renderer.PreReuse extends AsciiIo.Renderer.Pre

  createChildElements: ->
    super

    i = 0
    while i < @lines
      line = @$lines.eq(i)

      j = 0
      while j < @cols
        cell = $('<span>')
        line.append cell
        j++

      i++

  renderLine: (n, fragments, cursorX) ->
    html = []
    rendered = 0

    line = @$lines[n]
    spans = line.children

    i = 0
    for fragment in fragments
      [text, brush] = fragment

      spans[i].innerText = text

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

  blinkCursor: ->

  resetCursorState: ->
