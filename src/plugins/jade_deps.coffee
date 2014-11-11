through = require 'through2'
gutil = require 'gulp-util'
JadeParser = require 'jade/lib/parser'
path = require 'path'
_ = require 'lodash'
fs = require 'fs'
touch = require("touch")

directly_depends_on = (file, opts) ->
  parser = new JadeParser String(file.contents), file.path, opts
  paths = []
  while (type = parser.peek().type) isnt 'eos'
    switch type
      when 'include'
        p = parser.resolvePath parser.expect(type).val.trim(), type
        paths.push p
      else
        parser.advance()
  paths


module.exports = (opts = {}) ->
  parent_cache = {}
  through.obj (file, enc, cb) ->
    deps = directly_depends_on(file, opts)
    _.each deps, (d) ->
      parent_cache[d] ||= []
      parent_cache[d] = _.union parent_cache[d], [path.normalize(file.path)]

    if file.event
      _.each parent_cache[path.normalize(file.path)], (child) ->
        touch(child)
    cb null, file
