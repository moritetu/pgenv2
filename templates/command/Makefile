PGFILEDESC = "%extname% - description"
PGAPPICON = win32

PROGRAM = %extname%
OBJS	= %extname%.o $(WIN32RES)

ifdef USE_PGXS
PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
else
subdir = contrib/%extname%
top_builddir = ../..
include $(top_builddir)/src/Makefile.global
include $(top_srcdir)/contrib/contrib-global.mk
endif
