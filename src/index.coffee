_ = require 'lodash'
joi = require 'joi'
watchify   = require 'watchify'
browserify = require 'browserify'
source     = require 'vinyl-source-stream'
gulp       = require 'gulp'
$          = require('gulp-load-plugins')(lazy: true)
path       = require 'path'

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
  b.transform require './transforms/ng-template-cache'

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
      .on 'error', $.util.log.bind($.util, 'Browserify')
      .pipe source('bundle.js')
      .pipe gulp.dest dest
  b.on 'update', bundle if opts.watch
  bundle()


class Builder
  constructor: (options) ->
    @gulp = options.gulp
    @dest = options.dest

    @watch_tasks = []
    @build_tasks = []

    @add_js_tasks options.js
    @add_css_tasks options.css


    @gulp.task 'watch', @watch_tasks
    @gulp.task 'build', @build_tasks

  add_watch: (name, fn) ->
    task_name = "watch-#{name}"
    @gulp.task task_name, fn

    @watch_tasks.push task_name

  add_build: (name, fn) ->
    task_name = "build-#{name}"
    @gulp.task task_name, fn

    @build_tasks.push task_name

  add_js_tasks: (opts) ->
    opts.dest = @dest

    @add_build 'js', ->
      build_js opts.src, opts.dest,
        minify: true
        watch: false

    @add_watch 'js', ->
      build_js opts.src, opts.dest,
        minify: false
        watch: true

  add_css_tasks: (opts) ->
    @add_build 'css', =>
      gulp.src(opts.src)
        .pipe $.plumber()
        .pipe $.less(opts.less)
        .pipe gulp.dest(@dest)

    @add_watch 'css', ->
      $.watch glob: opts.watch, ['build-css']

module.exports = (options) ->
  new Builder options






