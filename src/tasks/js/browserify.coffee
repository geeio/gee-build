_           = require 'lodash'
watchify    = require 'watchify'
browserify  = require 'browserify'
source      = require 'vinyl-source-stream'
gulp        = require 'gulp'
path        = require 'path'
$           = require('gulp-load-plugins')(lazy: true)




module.exports = (opts, flags) ->
  b_opts =
    extensions: ['.coffee']
    debug: flags.minify

  _.extend b_opts, watchify.args if flags.watch

  b = browserify b_opts
  b = watchify(b) if flags.watch
  b.add opts.src

  # Transforms
  b.transform require 'coffeeify'
  b.transform require '../../transforms/ng-template-cache'

  if flags.minify
    b.transform (file) ->
      require('browserify-ngannotate') file,
        x: ['.coffee']

    map_out = opts.out.replace 'js', 'map'
    b.plugin require('minifyify'),
      output: path.join opts.dest, map_out
      uglify: opts.uglify



  bundle = ->
    console.log 'bundle'
    b.bundle()
      .on 'error', console.log.bind(console, 'Browserify')
      .pipe source opts.out
      .pipe gulp.dest opts.dest
  b.on 'update', bundle if flags.watch
  bundle()
