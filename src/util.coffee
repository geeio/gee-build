path = require 'path'
_    = require 'lodash'
fs   = require 'fs'

module.exports.dir_test = ->
  console.log(". = %s", path.resolve("."))
  console.log("__dirname = %s", path.resolve(__dirname))

module.exports.extract_watch = (opts) ->
  return opts.watch if opts.watch
  watch = [path.dirname(opts.src)]
  ext = path.extname opts.src

  watch.concat(opts?.less?.paths || []).map (p) ->
    path.join p, "**/*#{ext}"

module.exports.options_for = (opts, type) ->
  opts = _.omit opts, 'build', 'watch'

  _.extend opts, (opts[type] || {})



module.exports.task_chain = ->
  dir = path.join __dirname, 'tasks'

  _.chain fs.readdirSync(dir)
    .map (fn) ->
      task = require path.resolve path.join(dir, fn)
      task.name ||= path.basename fn, path.extname(fn)
      task
    .filter (task) ->
      !task.skip
