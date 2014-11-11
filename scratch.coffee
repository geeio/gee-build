JadeParser = require 'jade/lib/parser'
fs = require 'fs'
file = '/src/drinkin/style/views/index.jade'

content = fs.readFileSync file, 'utf8'


parser = new JadeParser content, file, {}

while (type = parser.peek().type) isnt 'eos'
  switch type
    when 'include'
      console.log parser.expect(type).val.trim()
    else
      console.log type
      parser.advance()
