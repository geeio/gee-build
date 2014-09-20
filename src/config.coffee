_   = require 'lodash'
joi = require 'joi'

assert = require 'assert'

task_helper = (description, extra = {}) ->
  keys = _.extend
    src: joi.string().required()
    dest: joi.string().required().description 'Overwrites default output directory'
  , extra

  joi.object().optional().description(description).keys keys

module.exports.task_names = task_names = ['js', 'html', 'css']

module.exports.schema = schema =
  dest: joi.string().description 'Default output directory'

  js: task_helper 'Use browserify to build.',
    uglify: joi.object()

  html: task_helper 'jade -> html',
    lr: joi.boolean().default(false).description 'Include livereload snippet and watch dest dir'
    jade: joi.object()

  css: task_helper 'less -> css',
    minify: joi.object()
    less: joi.object()



module.exports.validate = (opts) ->
  used_tasks = task_names.filter (tn) ->
    opts[tn]

  used_tasks.forEach (tn) ->
    opts[tn].dest ||= opts.dest
    assert opts[tn].dest, "dest required for #{tn} or global dest."

  {value, error} = joi.validate opts, schema,
    abortEarly: false
  throw error if error
  console.log value
  value.used_tasks = used_tasks
  value
