util = require './util'
_    = require 'lodash'
joi  = require 'joi'
rimraf = require 'rimraf'
$     = require('gulp-load-plugins')(lazy: true)

check = (opt, schema) ->
  {value, error} = joi.validate opt, schema,
    abortEarly: false
  throw error if error
  value


class Builder
  constructor: (@gulp) ->
    @tasks = {}

  add_subtask_type: (type) ->
    @tasks[type] = []

  add_subtask: (type, task_name, cb) ->
    tn = "gee-#{type}-#{task_name}"
    @tasks[type].push tn

    @gulp.task tn, tn, cb

  finish: (hooks) ->
    _.each @tasks, (tasks, type) =>

      post = hooks["post_#{type}"] || _.noop
      @gulp.task "gee-#{type}", type, tasks, post

module.exports = (gulp, options) ->
  $.help gulp
  builder = new Builder gulp

  ['build', 'watch'].forEach (t) ->
    builder.add_subtask_type t

  gulp.task 'clean', 'cleans', (cb) ->
    rimraf options.dest, cb


  tasks = util.task_chain()
    .filter (task) ->
      options[task.name]
    .each (task) ->
      opts = options[task.name]
      opts.dest ||= options.dest unless task.dest == false

      opts = check(opts, task.options)
      opts = _.defaults opts, task.defaults

      _.each task.tasks, (build_fn, type) ->
        builder.add_subtask type, task.name, ->
          build_fn(opts)

  builder.finish
    post_build: ->
      gulp.src "#{options.dest}/**/*"
        .pipe $.if '*.js', $.rev()
        .pipe $.if '*.css', $.rev()
        .pipe $.revReplace()
        .pipe $.size
          showFiles: true
          gzip: true
        .pipe gulp.dest(options.dest)




