gulp = require 'gulp'
$    = require('gulp-load-plugins')(lazy: true)
path  = require 'path'

extract_watch = (opts) ->
  watch = [path.dirname(opts.src)]
  watch.concat(opts.paths || []).map (p) ->
    path.join p, '**/*.less'

module.exports = (opts) ->
  console.log extract_watch(opts)
  build = ->
    gulp.src(opts.src)
      .pipe $.plumber()
      .pipe $.less
        paths: opts.paths
      .pipe gulp.dest(opts.dest)

  out =
    build: build
    watch: ->
      build()
      $.watch extract_watch(opts), (files, cb) ->
        build(cb).on 'end', cb
