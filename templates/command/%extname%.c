#include "postgres_fe.h"
#include "pg_getopt.h"

const char *progname;

/* these are the opts structures for command line params */
typedef struct options
{
	int flag;
} Options;


/* function prototypes */
static void help(const char *progname);

static void
help(const char *progname)
{
	printf("%s summary.\n\n"
		   "Usage:\n"
		   "  %s [OPTION]...\n"
		   "\nOptions:\n"
		   "  -?, --help     show this help, then exit\n"
		   "\nDescription\n\n"
		   "Report bugs to <example@example.com>.\n",
		   progname, progname);
}


int
main(int argc, char **argv)
{
	int c;
	Options *my_opts;

	my_opts = (Options *) pg_malloc(sizeof(Options));

	my_opts->flag = 0;

	progname = get_progname(argv[0]);

	if (argc > 1)
	{
		if (strcmp(argv[1], "--help") == 0 || strcmp(argv[1], "-?") == 0)
		{
			help(progname);
			exit(0);
		}
		if (strcmp(argv[1], "--version") == 0 || strcmp(argv[1], "-V") == 0)
		{
			puts("%extname% (PostgreSQL) " PG_VERSION);
			exit(0);
		}
	}

	/* get opts */
	while ((c = getopt(argc, argv, "h")) != -1)
	{
		switch (c)
		{
			case 'h':
				help(progname);
				exit(0);
				break;

			default:
				fprintf(stderr, _("Try \"%s --help\" for more information.\n"), progname);
				exit(1);
		}
	}

	return 0;
}
