gulp        = require 'gulp'
bower_files = require 'main-bower-files'
$           = require('gulp-load-plugins')(lazy: true)


module.exports = (opts, {minify}) ->
  files = bower_files()
  if minify
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
