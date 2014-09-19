gulp = require 'gulp'
$    = require('gulp-load-plugins')(lazy: true)
util = require '../util'
module.exports.register = (opts, reg) ->
  console.log opts
  reg.build 'html', ->
    gulp.src(opts.src)
      .pipe $.plumber()
      .pipe $.jade util.options_for(opts.jade, 'build')
      .pipe gulp.dest(opts.dest)

  reg.watch 'html', ->
    gulp.src(opts.src)
      .pipe $.watch opts.src
      .pipe $.plumber()
      .pipe $.jade util.options_for(opts.jade, 'watch')
      .pipe $.if(opts.lr, $.embedlr())
      .pipe gulp.dest(opts.dest)
