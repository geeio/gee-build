_ = require 'lodash'
joi = require 'joi'
watchify   = require 'watchify'
browserify = require 'browserify'
source     = require 'vinyl-source-stream'
gulp       = require 'gulp'
$          = require('gulp-load-plugins')(lazy: true)
path       = require 'path'


class Builder
  constructor: (@dest) ->

  js: (src, out, opts = {}) ->
    b_opts =
      extensions: ['.coffee']
      debug: opts.minify

    _.extend b_opts, watchify.args if opts.watch

    b = browserify b_opts
    b = watchify(b) if opts.watch
    b.add src

    # Transforms
    b.transform require 'coffeeify'
    b.transform require './transforms/ng-template-cache'

    if opts.minify
      b.transform (file) ->
        require('browserify-ngannotate') file,
          x: ['.coffee']
      b.plugin require('minifyify'),
        output: path.join @dest, out.replace('js', 'map.json')
        uglify:
          mangle: true



    bundle = =>
      b.bundle()
        .on 'error', $.util.log.bind($.util, 'Browserify')
        .pipe source(out)
        .pipe gulp.dest @dest
    b.on 'update', bundle if opts.watch
    bundle()


module.exports = (dest) ->
  new Builder(dest)





