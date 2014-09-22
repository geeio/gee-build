gulp        = require 'gulp'
bower_files = require 'main-bower-files'
$           = require('gulp-load-plugins')(lazy: true)

build = (opts) ->
  files = bower_files()
  if opts.min
    files = files.map (f) ->
      f.replace '.js', '.min.js'


  gulp.src files
    .pipe $.size
      showFiles: true
      title: 'bower'
    .pipe $.concat 'vendor.js'
    .pipe $.size()
    .pipe $.size
      gzip: true
    .pipe gulp.dest opts.dest

module.exports.register = (opts, reg) ->
  reg.build 'bower', ->
    opts.min = true
    build(opts)

  reg.watch 'bower', ->
    build(opts)

