gulp = require 'gulp'
$    = require('gulp-load-plugins')(lazy: true)



module.exports = (opts) ->
  build = ->
    gulp.src(opts.src)
      .pipe $.plumber()
      .pipe $.jade(opts.jade)
      .pipe gulp.dest(opts.dest)

  out =
    build: build
    watch: ->
      $.watch('www/**/*')
        .pipe $.livereload()


      gulp.src(opts.src)
        .pipe $.watch(opts.src)
        .pipe $.plumber()
        .pipe $.jade
          pretty: true
        .pipe $.embedlr() # TODO - only if index.
        .pipe gulp.dest(opts.dest)
