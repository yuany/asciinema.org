fragments = undefined

f = -> window.player.view.rendererView.renderLine 0, fragments

window.bm = (f, times) ->
  start = new Date

  i = 0
  while i < times
    f()
    i++

  console.log (new Date).getTime() - start.getTime()

window.bmLines = (n = 30, times = 10000) ->
  fragments = []

  i = 0
  while i < n
    fragments.push ["X", AsciiIo.Brush._default]
    i++

  window.bm f, times

window.bmAll = ->
  i = 1
  while i <= 51
    window.bmLines i, 5000
    i += 5
