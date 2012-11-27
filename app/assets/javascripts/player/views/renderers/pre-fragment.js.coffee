class AsciiIo.Renderer.PreFragment extends AsciiIo.Renderer.Pre

  renderLine: (n, fragments, cursorX) ->
    html = []
    rendered = 0

    domFragment = document.createDocumentFragment()

    for fragment in fragments
      [text, brush] = fragment

      if text
        e = document.createElement 'span'
        e.innerHTML = @escape(text)

        if brush
          brush = AsciiIo.Brush.create brush
          e.className = @classForBrush brush

        domFragment.appendChild e

    node = @$lines[n]
    while node.firstChild
      node.removeChild(node.firstChild)

    node.appendChild domFragment
