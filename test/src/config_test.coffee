config = require '../../src/config'

describe 'config', ->
  describe 'dest', ->
    it 'copies root dest to below', ->
      c = config.validate
        dest: 'www'
        js:
          src: 'index'
          dest: 'www/js'
        html:
          src: 'index'
      expect(c.js.dest).to.equal 'www/js'
      expect(c.html.dest).to.equal 'www'
    it 'throws error if no dest', ->
      expect(->
        config.validate
          js:
            src: 'index'
      ).to.throw /dest required for js/
