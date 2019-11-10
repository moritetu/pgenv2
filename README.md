pgenv2
======

pgenv2 is a tool to help you to manage multiple PostgreSQL versions. This is useful for **testing** or **developing**
on your local machine. You can pick a PostgreSQL version and run it. And also pgenv2 helps you to setup your
testing replication cluster.

Synopsis
--------

```bash
# Install PostgreSQL
pgenv install 10.4

# Install PostgreSQL with '--enable-debug' option.
pgenv install -d 10.4

# Set current version
pgenv global 10.4

# Show current version
pgenv current

# Create a link to the the specified path where you installed postgresql
pgenv link /my/postgres my_postgres

# Show the installed path.
pgenv prefix

# Change current working directory and execute any commands
pgenv prefix --source "cd contrib/auto_explain && make install"

# Show installed versions
pgenv list

# Remove the installed version
pgenv remove 10.4

# Show available versions
pgenv versions
pgenv versions -p  # pretty print
pgenv versions 9.6 # print only specified versions

# Export PostgreSQL with tarball archive
pgenv export

# Edit configure options
pgenv configure -e --default

# Excecute any commands
pgenv exec initdb pgdata
pgenv exec -v 9.6 initdb pgdata96

# Setup cluster
pgenv cluster -D clusterdir setup -s sync_standby -a async_standby primary

# Usage
pgenv --help
pgenv cluster setup --help
```


Getting Started
---------------

### Required

Bash 4.2 or later ( But recommend Bash 4.4 or later )

### Installing pgenv2

**Clone the Github project:**

```bash
$ git clone https://github.com/moritetu/pgenv2
$ cd pgenv2
$ source install.sh
```

**Use source archive:**

```bash
$ unzip pgenv2-master.zip
$ cd pgenv2
$ source install.sh
```

### Installing PostgreSQL

Before installing a PostgreSQL, you should check available PostgreSQL versions.
To do it, you can use `versions` command.

```bash
$ pgenv versions
```

pgenv2 gets available versions from the public PostgreSQL website, so please confirm whether the version you are going to install exists in the list.

And also, you can print only specified versions with the pretty format.

```bash
$ pgenv versions -p 10
PostgreSQL Available Versions 10
=======================================================================
10.0         10.1         10.2         10.3         10.4         10.5
10.6         10.7         10.8         10.9         10.10
```

Next, you can build a PostgreSQL with `install` command.

```bash
$ pgenv install 10.4
```

pgenv2 gets source archive from the public PostgreSQL repository, expands it and builds. If all is well, you will see the installed version with `list` command.

```bash
$ pgenv list
  10.4
```

### Customizing configure options

You can customize configure options with `configure` command.

```bash
# With EDITOR
$ pgenv configure -e
# From STDIN
$ pgenv configure -e <<EOF
--with-libxml
EOF
```

Configure options file is read with the following priority:

1.`$PGENV_ROOT/configure_options-<version>`

```
pgenv configure -e [--global]
```

2.`$PGENV_ROOT/configure_options`

```
pgenv configure -e --default
```

3.`$PWD/pgenv_configure_opts`

```
pgenv configure -e --local
```

### Setting default PostgreSQL

You can set the version to be used by default with `global` command.

```bash
$ pgenv global 10.4
Current version -> versions/10.4

[Next step]

  Create an instance and start postmaster:
    $ initdb pgdata
    $ pg_ctl -D pgdata -l postgresql.log start

  Connect to the postgres database:
    $ psql postgres
```

Run `list` command again. `*` mark means that current active version is 10.4.

```bash
$ pgenv list
* 10.4
```

Or you can do it with `current` command.

```bash
$ pgenv current
10.4
```

Execute the `psql` command and confirm current active version in the same way.

```bash
$ psql -V
psql (PostgreSQL) 10.4
```

OK, `psql` says current active version is 10.4.

### Showing path

When you need to know where resources of the version that you installed are stored, you can use `prefix` command.

```bash
$ pgenv prefix
/Users/guest/pgenv2/versions/10.4
```

If with `--bin`, `--share`, `--lib` or `--source` option, path will be shown more deeply.

```bash
$ pgenv prefix --bin
/Users/guest/pgenv2/versions/10.4/bin
$ pgenv prefix --share
/Users/guest/pgenv2/versions/10.4/share
$ pgenv prefix --lib
/Users/guest/pgenv2/versions/10.4/lib
$ pgenv prefix --source
/Users/guest/pgenv2/sources/10.4
```

In addition to it, you can pass arbitrary commands as arguments.

```bash
$ pgenv prefix --bin <<COM
initdb pgdata
COM
$ pgenv prefix --source 'find src/backend -type f -name "*.c" | xargs grep "too many clients"'
src/backend/postmaster/postmaster.c:					 errmsg("sorry, too many clients already")));
src/backend/storage/ipc/procarray.c:				 errmsg("sorry, too many clients already")));
src/backend/storage/ipc/sinvaladt.c:					 errmsg("sorry, too many clients already")));
src/backend/storage/lmgr/proc.c:				 errmsg("sorry, too many clients already")));
```

### Link to the existed one

If built version already exists, you can make a link to it with arbitrary name.

```bash
$ pgenv link /path/to/existed/postgresql mypg
$ pgenv list
* 10.4
  mypg
```

### Executing command

You can execute commands with any version you specify.

```bash
$ pgenv exec -v 9.6.9 <<EOF
initdb pgdata
pg_ctl -D pgdata -l postgresql.log start
EOF
```

`pgenv exec` command tries to read environment variables from `pgenv_myenv` file in the current directory. You can create its file with `pgenv env` command.

```bash
$ pgenv env -w -v 9.6.9
file created: /Users/guests/pgenv_myenv-9.6.9
$ pgenv exec -v 9.6.9 <<'EOF'
echo \$PGHOST
EOF
localhost
```

Constructing Replication
------------------------

pgenv2 helps you to construct replication environment for testing or development and so on.

### Setting up a cluster

For setting up your cluster, you can use `cluster setup` command. In the following example, a set of a primary server and a synchronous standby server is created.

```bash
pgenv cluster -D mycluster setup --sync-standby standby primary
```

If setting up has done successfully, you will be able to see the following cluster status with `cluster status` command.

```bash
$ pgenv cluster -D mycluster status
[Cluster Servers]
# Primary server
primary:24312       pg_ctl: server is running (PID: 1118)

# Synchronous standby servers
standby:24313       pg_ctl: server is running (PID: 1217)

# Asynchronous standby servers

[Replication Graph]
primary -> standby
  standby ->
```

### Starting/Stopping cluster

You can start your cluster with `cluster start` command. `start` command with `-a` option starts all instances in your cluster.

```bash
$ pgenv cluster -D mycluster start -a
```

And also stop it with `cluster stop` command. `stop` command with `-a` option stops all instances in your cluster.

```bash
$ pgenv cluster -D mycluster stop -a
```

### Attaching/Detaching nodes

After setting up your cluster, you can attach nodes to your cluster or detach nodes from it.

**Attaching nodes:**

```bash
$ pgenv cluster -D mycluster ctrl --attach --fork-off primary standby2
```

You can create a new standby node with `pg_basebackup` command , and start it.

```bash
$ pgenv cluster -D mycluster start standby2
```

Then check your cluster status.

```bash
pgenv cluster -D mycluster status
[Cluster Servers]
# Primary server
primary:24312       pg_ctl: server is running (PID: 1517)

# Synchronous standby servers
standby:24313       pg_ctl: server is running (PID: 1537)

# Asynchronous standby servers
standby2:24314      pg_ctl: server is running (PID: 1713)

[Replication Graph]
standby2 ->
primary -> standby standby2
  standby ->
```

**Detaching nodes:**

Here is a example to detach standby2 node.

```bash
$ pgenv cluster -D mycluster ctrl --detach standby2
```

Then check your cluster status.

```bash
$ pgenv cluster -D mycluster status
[Cluster Servers]
# Primary server
primary:24312       pg_ctl: server is running (PID: 1517)

# Synchronous standby servers
standby:24313       pg_ctl: server is running (PID: 1537)

# Asynchronous standby servers
standby2:24314      pg_ctl: no server running

[Replication Graph]
standby2 ->
primary -> standby
  standby ->
```

### Tailing logs

You can watch logs of all instances with `tail` command. This is useful for watching state of instances in your cluster.

```bash
$ pgenv cluster -D mycluster tail -f -a
```

### Cluster information

The setting about your cluster is saved under the cluster directory you specified with `-D` option.

```
# Cluster settings
export PGENV_CLUSTER_ROOT="/Users/guest/mycluster"

# Primary server
primary_server="primary"
primary_port="24312"

# Synchronous standby servers
synchronous_standby_servers=(standby)
synchronous_standby_ports=(24313)

# Asynchronous standby servers
asynchronous_standby_servers=(standby2)
asynchronous_standby_ports=(24314)

# Sync + Async standby servers
all_standby_servers=(standby standby2)
all_standby_ports=(24313 24314)

# Context when setup cluster
pg_setup_version="10.4"

# Version of pgenv
pgenv_version="pgenv2 0.1.2-beta"

# Other information
pg_start_port=24315   # Starting port number used when port number was not passed.
working_directory="/Users/guest/mycluster"    # This is the directory where you were when creating a cluster.

# Replication graph
# This information is extracted from pg_stat_replication view.
# So to analyze current exact replication state, all instances need to be started.
replication_tree["primary"]="standby"
replication_tree["standby"]=""
replication_tree["standby2"]=""
```

These settings are normally updated and stored into `cluster_config.sh` file by pgenv, so you do not need to edit them directly.

### Using hook at cluster setup

You can customize database configuration at cluster setup. By default, pgenv reads `libexec/pgenv--cluster-callback`, but you can overwrite by loading the your script which defines behaviors.

If `pgenv-cluster-callback.sh` exists on `PGENV_LOAD_PATH`, pgenv will load it after default script loaded at cluster setup.

```bash
on_primary_setup() {
  log_trace "on_primary_setup"
  cat <<EOF > "$include_file"
port = $port
EOF
}

on_primary_started() {
  log_trace "on_primary_started"
  : Do something
}

on_standby_setup() {
  log_trace "on_standby_setup"
  cat <<EOF > "$include_file"
port = $port
EOF
}

on_standby_recovery_setup() {
  log_trace "on_standby_recovery_setup"
  cat <<EOF >> "$recovery_conf"
recovery_target_timeline = 'latest'
EOF
}

on_standby_started() {
  log_trace "on_standby_started"
  : Do something
}
```

Developing PostgreSQL Extension
-------------------------------

pgenv will just help you to develop your extension.

### Setting up a extension project

```bash
$ pgenv extension init myext
```

You can choice another templates.

```bash
$ pgenv extension init -t command -Dextname=myext myext
```


### Building your extension

You can build your extension for all installed version.

```bash
$ cd myext
$ pgenv extension install -v @all
```

### Testing your extension

```bash
$ pgenv extension run -v @all 'initdb  ${ver}data'
$ pgenv extension run -v @all 'pg_ctl start -l $ver.log -D ${ver}data -o "-p $((9000+i))"'
$ pgenv extension run -v @all 'psql -p $((9000+i)) postgres -c "create extension myext"'
$ pgenv extension run -v @all 'psql -p $((9000+i)) postgres -c "select myext()"'
$ pgenv extension run -v @all 'pg_ctl stop -D ${ver}data'
$ pgenv extension run -v @all 'rm -rf ${ver}data $ver.log'
```

Plugin
------

You can add your own features into pgenv2. A plugin can be installed under `$PGENV_ROOT/plugins`.

```
$PGENV_ROOT/plugins/my-plugin
  |- bin
    |- pgenv-exec-<command name>
```

The description of your plugin can be shown with `pgenv help` command by writing `COMMAND` and `HELP` comment block into executable scripts.

```
#!/usr/bin/env bash

echo "Hello my plugin"

#=begin COMMAND
#
# my          This is my plugin.
#
#=end COMMAND

#=begin HELP
#
# Usage: pgenv my [-v|--version]
#
# OPTIONS
#   -v, --version
#     Show version.
#
#
#=end HELP
```

You will see the usage of the plugin with the following:

```
$ pgenv my -h
Usage: pgenv my [-v]

OPTIONS
  -v, --version
    Show version.

```

Hooks
-----
pgenv2 invokes hook scripts in running command optionally. The hook scripts can be installed into the followings.

```
$PGENV_ROOT/hooks/<hook_name>/yourhook.bash
$PGENV_ROOT/plugins/<plugin_name>/hooks/<hook_name>/yourhook.bash
~/.pgenv/hooks/<hook_name>/yourhook.bash
```

The name of hook sciprt file must end with `.bash`.

See more detail: [pgenv2 plugin sample]

FAQ
----


**Q. Failed to `install` or `versions` command with reason for 'curl: (35) Peer reports incompatible or unsupported protocol version.'**

Try to change `PGENV_CURL` environment variable.
```bash
$ PGENV_CURL="curl --tlsv1.2" pgenv ...
```

Bug Reporting
-------------

Please use [GitHub issues].


License
-------

Distributed under [The MIT License]; see [`LICENSE.md`] for terms.

[pgenv2 plugin sample]: https://github.com/moritetu/pgenv-plugin-sample
[GitHub issues]: https://github.com/moritetu/pgenv2/issues
[The MIT License]: https://opensource.org/licenses/MIT
[`LICENSE.md`]: https://github.com/moritetu/pgenv2/blob/master/LICENSE.md
