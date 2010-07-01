# Puppet

A prototype of a solution to the problem of expressing social game rules in code.

## Installation

You need git, ruby1.8, rubygems, sqlite and bundler. Once you have that do:

    git clone http://github.com/infrared/puppet
    cd puppet
    bundle install
    rake db:migrate
    rake spec # make sure all pass
    rails s

and the application should be running at http://localhost:3000


## Commentary

Coming up with requirements from a general problem description wasn't easy. In my opinion it would be better to start with an existing game and working code and only then start abstracting out its rules. Since the task didn't mention any particular game, I had to make one up. Because of that the resulting design may not be entirely realistic and only further development and real-world usage could test its usefulness.

User activities are the driving force of the game, so I focused on building a system that would allow to describe those activities in terms of game mechanics. The core of this system is the *Command* class. Through a use of *define_command* method, game rules concerning user actions can be described in a declarative manner. Dynamic features of Ruby do the heavy lifting, although there are enough checks to avoid the most common programming errors.

Flow of time is also a factor in social games, although not as important as user actions. In the current form, time is described by a class method definition (named *tick!*), although could be made part of the system after a few adjustments. The event-driven nature of the system would work well for regular time-dependent events.

The system is showcased on an example of a game of city building. A player invests money in buildings that are populated by people over time. People pay taxes, what gives money for new investments, and closes the circle.


## Handling time

For game to function properly it need to get regular time events. Easiest way to achieve this is through a cron task. For the purposes of testing a time flow can also be simulated from the console using the following snippet of code:

    while true
      CityCommands.tick!
      sleep 1 # adjust to your liking
    end
