CREATE FUNCTION @extschema@.autonomous_publish(
    broker_id integer
    , exchange varchar
    , routing_key varchar
    , message varchar
    , delivery_mode integer default null
    , content_type varchar default null
    , reply_to varchar default null
    , correlation_id varchar default null
)

RETURNS boolean AS 'pg_amqp2.so', 'pg_amqp2_autonomous_publish'
LANGUAGE C IMMUTABLE;

COMMENT ON FUNCTION @extschema@.autonomous_publish(integer, varchar, varchar, varchar, integer, varchar, varchar, varchar) IS
'Works as amqp2.publish does, but the message is published immediately irrespective of the
current transaction state. Commit and rollback at a later point will have no
effect on this message being sent to AMQP.';


CREATE FUNCTION amqp2.disconnect(broker_id integer)
RETURNS void AS 'pg_amqp2.so', 'pg_amqp2_disconnect'
LANGUAGE C IMMUTABLE STRICT;

COMMENT ON FUNCTION amqp2.disconnect(integer) IS
'Explicitly disconnect the specified (broker_id) if it is current connected. Broker
connections, once established, live until backend terminates.  This allows for more
precise control.
select amqp2.disconnect(broker_id) from amqp2.broker
will disconnect any brokers that may be connected.';


CREATE FUNCTION amqp2.exchange_declare(
    broker_id integer
    , exchange varchar 
    , exchange_type varchar
    , passive boolean
    , durable boolean
    , auto_delete boolean DEFAULT false
)
RETURNS boolean AS 'pg_amqp2.so', 'pg_amqp2_exchange_declare'
LANGUAGE C IMMUTABLE;

COMMENT ON FUNCTION amqp2.exchange_declare(integer, varchar, varchar, boolean, boolean, boolean) IS
'Declares a exchange (broker_id, exchange_name, exchange_type, passive, durable, auto_delete)
auto_delete should be set to false (default) as unexpected errors can cause disconnect/reconnect which
would trigger the auto deletion of the exchange.';


CREATE FUNCTION @extschema@.publish(
    broker_id integer
    , exchange varchar
    , routing_key varchar
    , message varchar
    , delivery_mode integer default null
    , content_type varchar default null
    , reply_to varchar default null
    , correlation_id varchar default null
)
RETURNS boolean AS 'pg_amqp2.so', 'pg_amqp2_publish'
LANGUAGE C IMMUTABLE;

COMMENT ON FUNCTION @extschema@.publish(integer, varchar, varchar, varchar, integer, varchar, varchar, varchar) IS
'Publishes a message (broker_id, exchange, routing_key, message). 
The message will only be published if the containing transaction successfully commits.  
Under certain circumstances, the AMQP commit might fail.  In this case, a WARNING is emitted. 
The last four parameters are optional and set the following message properties: 
delivery_mode (either 1 or 2), content_type, reply_to and correlation_id.

Publish returns a boolean indicating if the publish command was successful.  Note that as
AMQP publish is asynchronous, you may find out later it was unsuccessful.';

