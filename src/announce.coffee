# Description
#   Announce when hubot comes online or goes offline and include version
#
# Configuration:
#   HUBOT_ROOMS - a comma delimited list to announce to
#
# Author:
#   Alex Robson <asrobson@gmail.com>

_ = require "lodash"
path = require "path"
fs = require "fs"

packagePath = path.resolve __dirname, "../../../package.json"
packageJson = require packagePath
infoPath = path.resolve __dirname, "../../../.nonstop-info.json"
version = packageJson.version

if fs.existsSync infoPath
  info = require infoPath
  version = info.version

announceRooms = if process.env.HUBOT_ROOMS then process.env.HUBOT_ROOMS.split( "," ) else []

announce = ( robot ) ->
  _.each announceRooms, ( room ) ->
    robot.messageRoom room, "_#{robot.name} version_ #{version} _ is online_"

  goOffline = () ->
    _.each announceRooms, ( room ) ->
      robot.messageRoom room, "_#{robot.name} version_ #{version} _ is going offline_"

  process.on "exit", goOffline
  process.on "SIGINT", goOffline
  process.on "uncaughtException", goOffline

module.exports = (robot) ->
  announce robot
