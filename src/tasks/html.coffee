gulp  = require 'gulp'
$     = require('gulp-load-plugins')(lazy: true)
util  = require '../util'
joi = require 'joi'

module.exports =
  options:
    dest: joi.string().required()
    src: joi.string().required()
    lr: joi.boolean()
    lr_path: joi.alternatives().try(joi.string(), joi.array())
    jade: joi.object()

  defaults:
    lr_path: 'www/**/*'

  tasks:
    build: (opts) ->
      console.log opts
      gulp.src(opts.src)
        .pipe $.plumber()
        .pipe $.jade opts.jade
        .pipe gulp.dest(opts.dest)

    watch: (opts) ->
      console.log opts
      opts.jade ||=
        pretty: true

      if opts.lr
        $.watch opts.lr_path
          .pipe $.livereload()

      gulp.src(opts.src)
        .pipe $.watch opts.src
        .pipe $.plumber()
        .pipe $.jade opts.jade
        .pipe $.if(opts.lr, $.embedlr())
        .pipe gulp.dest(opts.dest)

