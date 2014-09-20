_ = require 'lodash'
config = require './config'

class Builder
  constructor: (@gulp, opts) ->
    @used_tasks = {}

    ['html', 'js', 'less', 'sass'].forEach (type) =>
      options = opts[type]
      return unless options
      options.dest ||= opts.dest
      @use type, options
    @done()

  use: (tn, options) ->
    tasks = require("./tasks/#{tn}")(options)

    _.each tasks, (task, k) =>
      task_name = "#{k}-#{tn}"
      @used_tasks[k] ||= []
      @used_tasks[k].push task_name
      @gulp.task task_name, task
    @

  done: ->
    console.log @used_tasks
    @gulp.task 'watch', @used_tasks.watch
    @gulp.task 'build', @used_tasks.build
    @

class Registry
  constructor: (@gulp) ->
    @tasks =
      watch: []
      build: []

  register: (tn, action, cb) ->
    gtask_name = "#{action}-#{tn}"
    @tasks[action].push gtask_name
    @gulp.task gtask_name, cb

  build: (tn, cb) ->
    @register tn, 'build', cb

  watch: (tn, cb) ->
    @register tn, 'watch', cb

module.exports = (gulp, options) ->
  options = config.validate(options)
  reg = new Registry gulp
  options.used_tasks
    .map (tn) ->
      task = require "./tasks/#{tn}"

      task.register options[tn], reg

  gulp.task 'build', reg.tasks.build
  gulp.task 'watch', reg.tasks.watch



