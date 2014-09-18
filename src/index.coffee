_ = require 'lodash'
joi = require 'joi'
watchify   = require 'watchify'
browserify = require 'browserify'
source     = require 'vinyl-source-stream'
gulp       = require 'gulp'
$          = require('gulp-load-plugins')(lazy: true)



class Builder
  constructor: (@dest) ->

  js: (src, out, opts = {}) ->
    b_opts =
      extensions: ['.coffee']

    _.extend b_opts, watchify.args if opts.watch

    b = browserify b_opts
    b = watchify(b) if opts.watch
    b.add src

    # Transforms
    b.transform require 'coffeeify'
    b.transform require './transforms/ng-template-cache'
    b.transform require 'browserify-ngannotate'
    bundle = =>
      b.bundle()
        .on 'error', $.util.log.bind($.util, 'Browserify')
        .pipe source(out)
        .pipe gulp.dest @dest
    b.on 'update', bundle if opts.watch
    bundle()




module.exports = (dest) ->
  new Builder dest





