gulp = require 'gulp'
$    = require('gulp-load-plugins')(lazy: true)



module.exports = (opts) ->
  build = ->
    gulp.src(opts.src)
      .pipe $.plumber()
      .pipe $.less(opts.less)
      .pipe gulp.dest(opts.dest)

  out =
    build: build
    watch: ->
      build()
      $.watch opts.watch, (files, cb) ->
        build(cb).on 'end', cb
