class AsciiIo.Renderer.Pre extends AsciiIo.Renderer.Base
  tagName: 'pre'
  className: 'terminal'

  initialize: (options) ->
    super
    @createChildElements()

  createChildElements: ->
    i = 0

    while i < @lines
      line = $('<span class="line">')
      @$el.append line
      @$el.append "\n"
      i++

    @$lines = @$('.line')

  fixTerminalElementSize: ->
    width = @cols * @cellWidth
    height = @lines * @cellHeight

    @$el.css(width: width + 'px', height: height + 'px')

  renderLine: (n, fragments, cursorX) ->
    throw 'renderLine not implemented!'

  escape: (text) ->
    text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')

  classForBrush: (brush) ->
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
    throw 'blinkCursor not implemented!'

  resetCursorState: ->
    throw 'resetCursorState not implemented!'
