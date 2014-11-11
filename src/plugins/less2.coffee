through = require 'through2'
gutil = require 'gulp-util'
less = require 'less'

module.exports = (opts = {}) ->
  lis = ->
    console.log arguments
  less.logger.addListener
    debug: lis
    info: lis
    warn: lis
    error: lis

  through.obj (file, enc, cb) ->
    content = file.contents.toString 'utf8'
    opts.filename = file.path
    less.render content, opts, (err, css) ->
      if err
        console.log less.formatError err,
          color: true
        cb(err, null)
      else
        file.contents = new Buffer(css)

        cb null, file


