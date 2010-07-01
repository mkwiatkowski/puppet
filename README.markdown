# Puppet

## Handling time

For game to function properly it need to get regular time events. Easiest way to achieve this is through a cron task. For the puproses of testing time flow can also be simulated from the console using the following snippet of code:

    while true
        CityCommands.tick!
        sleep 1 # adjust to your liking
    end
