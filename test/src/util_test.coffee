util = require '../../src/util'

describe 'util', ->
  describe 'extract_watch', ->
    it 'src only', ->
      watch = util.extract_watch
        src: 'src/main.less'

      expect(watch).to.deep.equal ['src/**/*.less']

    it 'watch overrides all', ->
      watch = util.extract_watch
        src: 'src/main.less'
        watch: ['hi']

      expect(watch).to.deep.equal ['hi']

    describe 'less', ->
      it 'includes paths', ->
        watch = util.extract_watch
          src: 'src/main.less'
          less:
            paths: ['vendor']

        expect(watch).to.deep.equal ['src/**/*.less', 'vendor/**/*.less']
