class AsciiIo.Renderer.PreFragment extends AsciiIo.Renderer.Base
  tagName: 'pre'
  className: 'terminal'

  initialize: (options) ->
    super(options)

    @cachedSpans = {}
    @createChildElements()

  createChildElements: ->
    i = 0

    while i < @lines
      row = $("<span class=\"line\">")
      @$el.append row
      @$el.append "\n"
      i++

  fixTerminalElementSize: ->
    width = @cols * @cellWidth
    height = @lines * @cellHeight

    @$el.css(width: width + 'px', height: height + 'px')

  render: ->
    if @state.dirty
      @$el.find('.cursor').removeClass('cursor')

    super

  renderLine: (n, fragments, cursorX) ->
    html = []
    rendered = 0

    domFragment = document.createDocumentFragment()

    for fragment in fragments
      [text, brush] = fragment

      if text
        t = @escape(text)

        e = document.createElement 'span' #$(span)[0]
        e.innerHTML = t
        e.className = @classForBrush brush if brush

        domFragment.appendChild e

    $line = @$el.find(".line:eq(" + n + ")")

    node = $line[0]
    while node.firstChild
      node.removeChild(node.firstChild)

    $line[0].appendChild domFragment

  escape: (text) ->
    text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')

  spanFromBrush: (brush) ->
    brush = AsciiIo.Brush.create brush

    key = brush.hash()
    span = @cachedSpans[key]

    if not span
      span = ""

      if brush != AsciiIo.Brush.default()
        span = "<span class=\""
        klass = @classForBrush brush
        span += klass
        span += "\">"

      @cachedSpans[key] = span

    span

  classForBrush: (brush) ->
    brush = AsciiIo.Brush.create brush

    klass = ''

    unless brush.hasDefaultFg()
      klass += " fg" + brush.fgColor()

    unless brush.hasDefaultBg()
      klass += " bg" + brush.bgColor()

    if brush.bright
      klass += " bright"

    if brush.underline
      klass += " underline"

    if brush.italic
      klass += " italic"

    klass

  showCursor: (show) ->
    if show
      @$el.addClass "cursor-on"
    else
      @$el.removeClass "cursor-on"

  blinkCursor: ->
    cursor = @$el.find(".cursor")
    if cursor.hasClass("visible")
      cursor.removeClass "visible"
    else
      cursor.addClass "visible"

  resetCursorState: ->
    cursor = @$el.find(".cursor")
    cursor.addClass "visible"

  # TODO: check if it's used
  clearScreen: ->
    # this.lineData.length = 0;
    # @cursorY = @cursorX = 0
    @$el.find(".line").empty()
