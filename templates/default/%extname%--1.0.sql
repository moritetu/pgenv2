\echo USE "CREATE EXTENSION %extname%" TO LOAD this file. \quit

CREATE OR REPLACE FUNCTION %extname%()
RETURNS BOOL
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;
