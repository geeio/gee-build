gulp  = require 'gulp'
$     = require('gulp-load-plugins')(lazy: true)
joi = require 'joi'



module.exports =
  dest: false
  options:
    script: joi.string()
    ext: joi.string().default('js coffee jade')
    watch: joi.array()

  tasks:
    watch: (opts) ->
      $.nodemon opts

