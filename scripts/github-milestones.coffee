module.exports = (robot) ->
  robot.respond /milestones (.*)/i, (msg) ->
    repository = msg.match[1]
    msg.send "milestones for " + repository
    robot.http("https://api.github.com/repos/" + repository + "/milestones")
      .get() (err, res, body) ->
        if res.statusCode is 404
          msg.send "Repository " + repository + " not found."
        else if res.statusCode is 200
          milestones = null
          try
            milestones = JSON.parse body
          catch error
            msg.send "Error parsing JSON"

          for milestone in milestones
            msg.send "#{milestone.title} is #{Math.floor(milestone.closed_issues/(milestone.open_issues + milestone.closed_issues)*100)}% complete with " +
              "#{milestone.open_issues} open issues and #{milestone.closed_issues} closed issues"
