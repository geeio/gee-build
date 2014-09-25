gulp  = require 'gulp'
$     = require('gulp-load-plugins')(lazy: true)
util  = require '../../util'
joi = require 'joi'

build_browserify = require './browserify'
build_bower      = require './bower'

module.exports =
  options:
    dest: joi.string().required()
    src: joi.string().required()
    out: joi.string().default('bundle.js')
    uglify: joi.object().default
      mangle: true
    bower: joi.boolean()

  tasks:
    build: (opts) ->
      flags =
        minify: true
        watch: false
      build_bower opts, flags if opts.bower
      build_browserify opts, flags



    watch: (opts) ->
      flags =
        minify: false
        watch: true
      build_bower opts, flags if opts.bower
      build_browserify opts, flags

