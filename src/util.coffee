path = require 'path'
_    = require 'lodash'

module.exports.extract_watch = (opts) ->
  return opts.watch if opts.watch
  watch = [path.dirname(opts.src)]
  ext = path.extname opts.src

  watch.concat(opts?.less?.paths || []).map (p) ->
    path.join p, "**/*#{ext}"

module.exports.options_for = (opts, type) ->
  opts = _.omit opts, 'build', 'watch'

  _.extend opts, (opts[type] || {})
