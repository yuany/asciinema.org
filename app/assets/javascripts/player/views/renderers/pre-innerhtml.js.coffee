class AsciiIo.Renderer.PreInnerHtml extends AsciiIo.Renderer.Pre

  initialize: (options) ->
    super
    @cachedSpans = {}

  render: ->
    if @state.dirty
      @$el.find('.cursor').removeClass('cursor')

    super

  renderLine: (n, fragments, cursorX) ->
    html = []
    rendered = 0

    for fragment in fragments
      [text, brush] = fragment

      if cursorX isnt undefined and rendered <= cursorX < rendered + text.length
        left = text.slice(0, cursorX - rendered)
        cursor =
          '<span class="cursor visible">' + text[cursorX - rendered] + '</span>'
        right = text.slice(cursorX - rendered + 1)

        t = @escape(left) + cursor + @escape(right)
      else
        t = @escape(text)

      brush = AsciiIo.Brush.create brush

      if brush != AsciiIo.Brush.default()
        html.push @spanFromBrush(brush)
        html.push t
        html.push '</span>'
      else
        html.push t

      rendered += text.length

    @$lines[n].innerHTML = '<span>' + html.join('') + '</span>'

  spanFromBrush: (brush) ->
    key = brush.hash()
    span = @cachedSpans[key]

    if span == undefined
      span = "<span class=\""
      klass = @classForBrush brush
      span += klass
      span += "\">"

      @cachedSpans[key] = span

    span

  blinkCursor: ->
    cursor = @$el.find(".cursor")
    if cursor.hasClass("visible")
      cursor.removeClass "visible"
    else
      cursor.addClass "visible"

  resetCursorState: ->
    cursor = @$el.find(".cursor")
    cursor.addClass "visible"
