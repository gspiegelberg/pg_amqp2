pg_amqp2
========

Notes
-----
In the case of CloudberryDB and Greenplum/gpdb, all messages are sent from the
master/coordinator segment only.


Usage
-----
Insert AMQP broker information (host/port/user/pass) into the
`amqp2.broker` table.

A process starts and connects to PostgreSQL and runs:

    SELECT amqp2.publish(broker_id, 'amqp.direct', 'foo', 'message', 1, 
			'application/json', 'some_reply_to', 'correlation_id');

The last four parameters are optional and define the message properties. The parameters
are: delivery_mode (either 1 or 2, non-persistent, persistent respectively), content_type,
reply_to and correlation_id.

Given that message parameters are optional, the function can be called without any of those in
which case no message properties are sent, as in:

    SELECT amqp2.publish(broker_id, 'amqp.direct', 'foo', 'message');

Upon process termination, all broker connections will be torn down.
If there is a need to disconnect from a specific broker, one can call:

    select amqp2.disconnect(broker_id);

which will disconnect from the broker if it is connected and do nothing
if it is already disconnected.

Autonomous message publishing possible with amqp2.autonomous_publish(). Works as
amqp2.publish() does however will send the message immediately.

Support
-------

This library is stored in an open [GitHub repository](http://github.com/gspiegelberg/pg_amqp2).
Feel free to fork and contribute! Please file bug reports via 
[GitHub Issues](http://github.com/gspiegelberg/pg_amqp/issues/).

Authors
------

[Project pg_amqp2:](https://github.com/gspiegelberg/pg_amqp2)
[Greg Spiegelberg](https://www.linkedin.com/in/gregspiegelberg/)

[Project pg_amqp:](https://github.com/omniti-labs/pg_amqp)
[Theo Schlossnagle](http://lethargy.org/~jesus/)
[Keith Fiske](http://www.keithf4.com)
