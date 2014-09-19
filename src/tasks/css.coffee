gulp  = require 'gulp'
$     = require('gulp-load-plugins')(lazy: true)
util  = require '../util'

build = (opts) ->
  is_less = $.filter '*.less'
  is_sass = $.filter ['*.sass', '*.scss']

  gulp.src(opts.src)
    .pipe(is_less).pipe($.less opts.less).pipe(is_less.restore())
    .pipe(is_sass).pipe($.sass opts.sass).pipe(is_sass.restore())
    .pipe $.minifyCss opts.minify
    .pipe gulp.dest(opts.dest)


module.exports.register = (opts, reg) ->
  reg.build 'css', ->
    build(opts)

  reg.watch 'css', ->
    build(opts)
    $.watch util.extract_watch(opts), (files, cb) ->
      build(opts).on 'end', cb

