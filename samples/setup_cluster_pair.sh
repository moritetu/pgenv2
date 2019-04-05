#!/usr/bin/env bash
#
# Setup a cluster which is composed of four nodes.
#
# (primary)
#  P-----------> S1
#  |          (sync)
#  v
#  S2----------> S3
#  (async)    (async)
#
#
# Fallback Test
# -------------
#
# 1. Stop primary node.
#
#  $ pgenv cluster -D /path/to/cluster exec p pg_ctl stop
#
# (primary)
#  P            S1
#             (sync)
#
#  S2----------> S3
#  (async)    (async)
#
# 2. Promote standby node.
#
#  $ pgenv cluster -D /path/to/cluster exec s1 pg_ctl promote
#
#  P          S1 (primary)
#             ^
#  +----------|
#  |
#  S2-------> S3
#  (async)  (async)
#
# 3. See replication status.
#
#  echo "select * from pg_stat_replication" | pgenv cluster -D /path/to/cluster exec s1 psql -x
#  echo "select * from pg_stat_replication" | pgenv cluster -D /path/to/cluster exec s2 psql -x
#
#

set -eu

# Show usage
usage() {
  local this="$(basename "${BASH_SOURCE:-$0}")"
  cat<<EOF
Usage: $this <cluster_dir>

SYNOPSIS
  $this /path/to/cluster
  pgenv prefix --samples bash $this /path/to/cluster

Fallback test:
  # First, stop primary node.
  pgenv cluster -D /path/to/cluster exec p pg_ctl stop

  # Next, promote standby node.
  pgenv cluster -D /path/to/cluster exec s1 pg_ctl promote

  # Finally, you can see that s2 is connecting to s1.
  pgenv cluster -D /path/to/cluster exec s1 psql -x <<SQL
  select * from pg_stat_replication
  SQL

EOF
}

# Check whether PostgreSQL is greather than version 12.
is_postgres_less_than_12() {
  local pgdata="$1"
  test -e "$pgdata/recovery.conf"
}

# Cleanup
cleanup() {
  local status=$?

  # If nodes are running, we stop them.
  pgenv cluster -D "$CLUSTER_ROOT" stop -a

  # Remove cluster directory.
  if [ -e "$CLUSTER_ROOT" ]; then
    /bin/rm -rf "$CLUSTER_ROOT"
  fi

  exit $status
}


# Parse options
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)
      usage && exit
      ;;
    -*)
      echo "invalid option: $1" >&2
      exit 1
      ;;
    *)
      break
      ;;
  esac
  shift
done


# Cluster root directory
CLUSTER_ROOT="$1"

trap cleanup SIGINT SIGTERM


# Setup the following:
#
# (primary)
#   P----------> S1
#              (sync)
#
pgenv cluster -D "$CLUSTER_ROOT" setup -s s1 p
source "$CLUSTER_ROOT"/cluster_config.sh


# Setup the following:
#
# (primary)
#   P----------> S1
#   |          (sync)
#   v
#   S2
# (async)
#

# s2 is still not running.
pgenv cluster -D "$CLUSTER_ROOT" ctrl -a -f p s2
(
  cd "$CLUSTER_ROOT"
  config_file=
  if is_postgres_less_than_12 "s2"; then
    config_file="recovery.conf"
  else
    config_file="postgresql.auto.conf"
  fi
  {
    port1=$primary_port
    port2=${synchronous_standby_ports[0]}
    sed "/primary_conninfo *=/d" "s2/$config_file"
    echo "primary_conninfo = 'user=''$USER'' passfile=''$HOME/.pgpass'' host=localhost,localhost port=$port1,$port2 application_name=s2 sslmode=prefer sslcompression=0 target_session_attrs=read-write'"
  } > "s2/$config_file.tmp"

  mv "s2/$config_file.tmp" "s2/$config_file"
)

# Start s2
pgenv cluster -D "$CLUSTER_ROOT" start s2


# Finally, the cluster becomes the following:
#
# (primary)
#   P----------> S1
#   |         (sync)
#   v
#   S2---------> S3
# (async)     (async)
#
pgenv cluster -D "$CLUSTER_ROOT" ctrl -f s2 -a -S s3
