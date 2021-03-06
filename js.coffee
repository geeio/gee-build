_           = require 'lodash'
joi         = require 'joi'
watchify    = require 'watchify'
browserify  = require 'browserify'
source      = require 'vinyl-source-stream'
gulp        = require 'gulp'
path        = require 'path'
bower_files = require 'main-bower-files'
$           = require('gulp-load-plugins')(lazy: true)
build_bower = (dest, minify) ->
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
    .pipe gulp.dest dest

module.exports.skip = true
build_js = (src, dest, opts) ->
  b_opts =
    extensions: ['.coffee']
    debug: opts.minify

  _.extend b_opts, watchify.args if opts.watch

  b = browserify b_opts
  b = watchify(b) if opts.watch
  b.add src

  # Transforms
  b.transform require 'coffeeify'
  b.transform require '../transforms/ng-template-cache'

  if opts.minify
    b.transform (file) ->
      require('browserify-ngannotate') file,
        x: ['.coffee']
    b.plugin require('minifyify'),
      output: path.join dest, 'bundle.map'
      uglify:
        mangle: true



  bundle = ->
    b.bundle()
      .on 'error', console.log.bind(console, 'Browserify')
      .pipe source('bundle.js')
      .pipe gulp.dest dest
  b.on 'update', bundle if opts.watch
  bundle()


module.exports.register = (opts, reg) ->
  reg.build 'js', ->
    build_bower opts.dest, true

    build_js opts.src, opts.dest,
      minify: true
      watch: false

  reg.watch 'js', ->
    build_bower opts.dest, false
    build_js opts.src, opts.dest,
      minify: false
      watch: true
