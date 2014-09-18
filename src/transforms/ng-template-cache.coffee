through   = require 'through'
js_escape = require 'js-string-escape'
jade      = require 'jade'




module.exports = (file) ->
  return through() unless /\.jade$/.test(file)
  data = ''
  write = (buf) -> data += buf

  through write, ->
    jade.render data, filename: file, (err, html) =>
      console.log err if err
      @queue  "module.exports = '#{js_escape(html)}';\n"
      @queue null
