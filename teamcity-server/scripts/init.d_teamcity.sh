#!/bin/bash
### BEGIN INIT INFO
# Provides:          teamcity
# Required-Start:    $local_fs
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: TeamCity
# Description:       TeamCity
### END INIT INFO

TEAMCITY_DATA_PATH="/data/.BuildServer"

. /etc/rc.d/init.d/functions

case $1 in
  start)
    echo "Starting Team City"
    sudo -u teamcity -s -- sh -c "TEAMCITY_DATA_PATH=$TEAMCITY_DATA_PATH /srv/TeamCity/bin/teamcity-server.sh start"
    ;;
  stop)
    echo "Stopping Team City"
    sudo -u teamcity -s -- sh -c "/srv/TeamCity/bin/teamcity-server.sh stop"
    ;;
  restart)
    echo "Restarting Team City"
    sudo -u teamcity -s -- sh -c "/srv/TeamCity/bin/teamcity-server.sh stop"
    sudo -u teamcity -s -- sh -c "TEAMCITY_DATA_PATH=$TEAMCITY_DATA_PATH /srv/TeamCity/bin/teamcity-server.sh start"
    ;;
  *)
    echo "Usage: /etc/init.d/teamcity {start|stop|restart}"
    exit 1
    ;;
esac

exit 0