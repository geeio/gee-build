_ = require 'lodash'
config = require './config'

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



