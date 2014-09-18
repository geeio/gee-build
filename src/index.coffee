_ = require 'lodash'

class Builder
  constructor: (@gulp, @global_opts) ->
    @used_tasks = {}

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

module.exports = (gulp, options) ->
  new Builder(gulp, options)






