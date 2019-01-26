MODULES = %extname%
EXTENSION = %extname%
DATA = %extname%--1.0.sql

ifdef PG_PORT
REGRESS_OPTS += --port $(PG_PORT)
endif

PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
