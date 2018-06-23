#include "postgres.h"
#include "fmgr.h"
#include "funcapi.h"

PG_MODULE_MAGIC;

PG_FUNCTION_INFO_V1(myext);

Datum
myext(PG_FUNCTION_ARGS)
{
    PG_RETURN_BOOL(true);
}
