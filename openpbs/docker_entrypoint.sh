#!/bin/bash

HOST=$(hostname)
echo "\$clienthost $HOST" > /var/spool/pbs/mom_priv/config
cat <<EOT > /etc/pbs.conf
PBS_EXEC=/opt/pbs
PBS_SERVER=$HOST
PBS_START_SERVER=1
PBS_START_SCHED=1
PBS_START_COMM=1
PBS_START_MOM=1
PBS_HOME=/var/spool/pbs
PBS_CORE_LIMIT=unlimited
PBS_SCP=/bin/scp
EOT

/opt/pbs/libexec/pbs_init.d start
sleep 1s
/opt/pbs/bin/qmgr -c  "create node $HOST"
/opt/pbs/bin/qmgr -c "create queue workqueue queue_type=e,enabled=t,started=t"
/opt/pbs/bin/qmgr -c "set server default_queue = workqueue"

# Run whatever the user wants to
exec "$@"
