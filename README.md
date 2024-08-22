pg_amqp2
=============

The pg_amqp2 package provides the ability for postgres statements to directly
publish messages to an [AMQP](http://www.amqp.org/) broker.

All bug reports, feature requests and general questions can be directed to
Issues section on Github.


History
--------
Project cloned and overhauled from http://github.com/omniti-labs/pg_amqp.
Kudo's to that team.

Major reason for overhaul and not direct clone as previous was built around
an antiquated and built in librabbitmq of version unknown circa 2014.

Intention of this project is to reboot effort to support AMQP in current
versions of PostgreSQL, Greenplum/gpdb and CloudberryDB/cbdb, removal of
internal librabbitmq, bring up to date with current librabbitmq, general
code clean up, and make enterprise ready.


Building
--------

Requires
 * librabbitmq 0.14.0

To build pg_amqp2:

    make
    make install

You need to use GNU make, which may well be installed on your system as
`gmake`:

    gmake
    gmake install

If you encounter an error such as:

    make: pg_config: Command not found

Be sure that you have `pg_config` installed and in your path. If you used a
package management system such as RPM to install PostgreSQL, be sure that the
`-devel` package is also installed. If necessary tell the build process where
to find it:

PostgreSQL:
    env PG_CONFIG=/path/to/pg_config make && make install

CloudberryDB & Greenplum assuming build directory NFS mounted everywhere:
    gpssh -f ALLHOSTS
    => cd /path/to/build/dir
    => env PG_CONFIG-/path/to/install/bin/pg_config
    => make install


Loading
-------

Once amqp2 is installed, you can add it to a database. Add this line to your
postgresql config

    shared_preload_libraries = 'pg_amqp2.so'

This extension requires
 * CloudberryDB 1.5.4
 * Greenplum 7.0.0 (via archive github gpdb)
 * PostgreSQL >= 9.1.0 (untested)

Loading amqp2, connect to a database as a super user and run: 

    CREATE EXTENSION amqp2;


Basic Usage
-----------

Insert AMQP broker information (host/port/user/pass) into `amqp2.broker` table.

A process starts and connects to the database and executes:

    SELECT amqp2.publish(broker_id, 'amqp.direct', 'foo', 'message');

Upon process termination, all broker connections will be torn down.
If there is a need to disconnect from a specific broker, one can call:

    select amqp2.disconnect(broker_id);

which will disconnect from the broker if it is connected and do nothing
if it is already disconnected.

