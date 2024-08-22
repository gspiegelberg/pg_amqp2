EXTENSION    = amqp2
EXTVERSION   = 0.1.0
TARGET       = pg_amqp2.so

local_cflags = -g -I/usr/local/include/rabbitmq-c
local_libs   = -L/usr/local/lib64 -lrabbitmq

CC = gcc

PG_CONFIG    = pg_config
#PGXS := $(shell $(PG_CONFIG) --pgxs)
#include $(PGXS)
CFLAGS       = $(shell $(PG_CONFIG) --cflags)
LIBS         = $(shell $(PG_CONFIG) --libs)
INCLUDEDIR   = $(shell $(PG_CONFIG) --includedir)
LIBDIR       = $(shell $(PG_CONFIG) --libdir)

SRCS         = pg_amqp2.c
OBJS         = pg_amqp2.o

FLAGS        = -shared
CFLAGS      += $(local_cflags)
LIBS        += $(local_libs)
LDFLAGS     += -shared

pg_includes = -I$(INCLUDEDIR) -I$(INCLUDEDIR)/postgresql/server

#PGXS := $(shell $(PG_CONFIG) --pgxs)
#include $(PGXS)


all: objs sql/$(EXTENSION)--$(EXTVERSION).sql

objs:
	$(info    CFLAGS is $(CFLAGS))
	$(info    LIBS is $(LIBS))
	$(info    pg_includes is $(pg_includes))
	$(info    )
	$(CC) $(FLAGS) $(CFLAGS) $(pg_includes) $(DEBUGFLAGS) -o $(TARGET) $(SRCS) -L $(LIBDIR) $(LIBS)

sql/$(EXTENSION)--$(EXTVERSION).sql: sql/tables/*.sql sql/functions/*.sql
	cat $^ > $@


install:
	install pg_amqp2.so /usr/local/cbdb/lib/postgresql/pg_amqp2.so
	install amqp2.control /usr/local/cbdb/share/postgresql/extension/amqp2.control
	install sql/amqp2--0.1.0.sql /usr/local/cbdb/share/postgresql/extension/amqp2--0.1.0.sql
	install doc/amqp2.md /usr/local/cbdb/share/doc/postgresql/extension/amqp2.md


clean:
	rm -f $(OBJS) $(TARGET)
