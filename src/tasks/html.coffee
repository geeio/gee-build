gulp  = require 'gulp'
$     = require('gulp-load-plugins')(lazy: true)
util  = require '../util'
joi = require 'joi'

module.exports =
  options:
    dest: joi.string().required()
    src: joi.string().required()
    lr: joi.boolean()
    jade: joi.object()

  tasks:
    build: (opts) ->
      gulp.src(opts.src)
        .pipe $.plumber()
        .pipe $.jade opts.jade
        .pipe gulp.dest(opts.dest)

    watch: (opts) ->
      opts.jade ||=
        pretty: true

      if opts.lr
        $.watch 'www/**/*'
          .pipe $.livereload()

      gulp.src(opts.src)
        .pipe $.watch opts.src
        .pipe $.plumber()
        .pipe $.jade opts.jade
        .pipe $.if(opts.lr, $.embedlr())
        .pipe gulp.dest(opts.dest)

