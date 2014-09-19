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
    uglify: joi.object().unknown(true).description('Options for uglify.').keys
      mangle: joi.boolean().default(true)

  html: task_helper 'jade -> html',
    lr: joi.boolean().default(false).description 'Include livereload snippet and watch dest dir'

    jade: joi.object().unknown(true).keys
      pretty: joi.boolean().default(true)

  css: task_helper 'less -> css',
    minify: joi.object().unknown(true).keys
      keepSpecialComments: joi.any().valid('*', 0, 1).default(0) # Remove all comments
      keepBreaks: joi.boolean().default(false)
    less: joi.object().unknown(true).keys
      vendor: joi.array().default([])



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
