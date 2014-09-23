gulp  = require 'gulp'
$     = require('gulp-load-plugins')(lazy: true)
util  = require '../util'
joi = require 'joi'


build = (opts) ->
  is_less = $.filter '*.less'
  is_sass = $.filter ['*.sass', '*.scss']

  gulp.src(opts.src)
    .pipe(is_less).pipe($.less opts.less).pipe(is_less.restore())
    .pipe(is_sass).pipe($.sass opts.sass).pipe(is_sass.restore())
    .pipe $.minifyCss opts.minify
    .pipe gulp.dest(opts.dest)


module.exports =
  options:
    dest: joi.string().required()
    src: joi.string().required()
    less: joi.object()
    sass: joi.object()
    minify: joi.object().default
      keepSpecialComments: 0

  tasks:
    build: (opts) ->
      build(opts)

    watch: (opts) ->
      $.watch util.extract_watch(opts), (files, cb) ->
        build(opts).on 'end', cb

