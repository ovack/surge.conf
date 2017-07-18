_ = require 'lodash'
fs = require 'fs'
readline = require 'linebyline'
download = require 'download'
moment = require 'moment'
config = require './config'

convert = (str) ->
  policy = ''
  if str.length isnt 0
    stp = _.replace str, '\t', ' '
    strArray = _.compact (_.split stp, ' ')

    if strArray.length > 1
      policy = strArray[1] + ' = ' + strArray[0] + '\n'
    else '\n'
  else policy

download config.hostUrl
  .then (data) ->
    fs.writeFileSync './fresh_hosts', data
  .then ->
    surgeHeader = '[Host]\n#Last Upadate: ' + moment().format() + '\n'

    fs.writeFileSync './surge.conf', surgeHeader

    rl = readline './fresh_hosts'
    rl.on 'line', (line) ->
      if not _.startsWith line, '#'
        fs.appendFileSync './surge.conf', convert line

  .then -> console.log 'well done!'
