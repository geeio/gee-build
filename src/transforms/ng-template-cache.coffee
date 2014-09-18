js_escape = require 'js-string-escape'
jade      = require 'jade'
bt        = require 'browserify-through'


module.exports = bt
  filter: (fp) ->
    /\.jade$/.test fp

  map: (fp, data, done) ->
    jade.render data, filename: fp, (err, html) ->
      done err, "module.exports = '#{js_escape(html)}';\n"
