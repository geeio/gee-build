_   = require 'lodash'
joi = require 'joi'

task_schema = (description, extra = {}) ->
  keys = _.extend
    src: joi.string().required()
    dest: joi.string().optional().description 'Overwrites default output directory'
  , extra

  joi.object().optional().description(description).keys keys



option_schema =
  dest: joi.string().required().description 'Default output directory'
  js: task_schema 'Use browserify to build.',
    uglify: joi.object().unknown(true).description('Options for uglify.').keys
      mangle: joi.boolean().default(true)


  html: task_schema 'Compile jade -> html files',
    lr: joi.boolean().default(false).description 'Include livereload snippet and watch dest dir'

    jade: joi.object().unknown(true).keys
      build: joi.object().unknown(true)
      watch: joi.object().unknown(true).keys
        pretty: joi.boolean().default(true)

assert = (config) ->
  {value, error} = joi.validate config, option_schema,
    abortEarly: false
  throw error if error
  value

assert
  dest: 'www'

assert
  dest: 'www'
  js:
    src: './src/client/index.coffee'
  less:
    src: 'src/css/main.less'
    paths: ['vendor']
  html:
    src: 'src/views/*.jade'
    lr: true
