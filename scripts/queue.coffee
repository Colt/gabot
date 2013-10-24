util = require 'util'
_ = require 'underscore'

module.exports = (robot) ->
  robot.brain.data.instructorQueue ?= []

  queueStudent = (name) ->
    robot.brain.data.instructorQueue.push
      name: name
      queuedAt: new Date()

  stringifyQueue = ->
    _.reduce robot.brain.data.instructorQueue, (reply, student) ->
      reply += "\n"
      reply += "#{student.name} at #{student.queuedAt}"
      reply
    , ""

  popStudent = ->
    robot.brain.data.instructorQueue.shift()

  robot.respond /queue me/i, (msg) ->
    name = msg.message.user.mention_name || msg.message.user.name
    if _.any(robot.brain.data.instructorQueue, (student) -> student.name == name)
      msg.send "#{name} is already queued"
    else
      queueStudent(name)
      msg.send "Current queue is: #{stringifyQueue()}"

  robot.respond /pop student/i, (msg) ->
    student = popStudent()
    msg.reply "go help #{student.name}, queued at #{student.queuedAt}"

  robot.respond /student queue/i, (msg) ->
    if _.isEmpty(robot.brain.data.instructorQueue)
      msg.send "Student queue is empty"
    else
      msg.send stringifyQueue()
