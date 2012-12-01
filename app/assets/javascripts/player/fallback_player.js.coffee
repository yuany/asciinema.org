class AsciiIo.FallbackPlayer extends AsciiIo.AbstractPlayer

  constructor: (@options) ->
    super
    @states = []

  createVT: ->
    @vt = new AsciiIo.VT @options.cols, @options.lines

  createMovie: ->
    @movie = new AsciiIo.Movie @movieOptions()

  onModelReady: ->
    super

  bindEvents: ->
    super

    @movie.on 'reset', => @vt.reset()

    if @options.preprocess
      @movie.on 'preprocess-data', (data) =>
        @vt.feed data
        state = @vt.state()
        @vt.clearChanges()
        @states.push state

      @movie.preprocess()

      @movie.on 'data', (frameData, frameNo) =>
        state = @states[frameNo]
        @movie.trigger 'render', state
    else
      @movie.on 'data', (frameData, frameNo) =>
        @vt.feed frameData
        state = @vt.state()
        @vt.clearChanges()
        @movie.trigger 'render', state
