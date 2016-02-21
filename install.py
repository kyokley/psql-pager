#!/usr/bin/python

import os, sys

PSQL_FILENAME = 'vimpsqlpager'
PGCLI_FILENAME = 'vimpgclipager'
EXECUTABLE_PATH = '/usr/bin'

psql_script = '''#!/bin/bash
what=-
test "$@" && what="$@"
exec vi -u NONE -S {install_dir}/plugin/psql.vim -c Less $what
'''

pgcli_script = '''#!/bin/bash
what=-
test "$@" && what="$@"
exec vi -u NONE -S {install_dir}/plugin/pgcli.vim -c Less $what
'''

def main():
    uid = os.getuid()
    if uid != 0:
        sys.exit('ERROR: Installation must be executed as the root user')

    install_dir = os.getcwd()
    full_psql_path = os.path.join(EXECUTABLE_PATH, PSQL_FILENAME)
    with open(full_psql_path, 'w') as f:
        f.write(psql_script.format(install_dir=install_dir))
    os.chmod(full_psql_path, 0755)

    full_pgcli_path = os.path.join(EXECUTABLE_PATH, PGCLI_FILENAME)
    with open(full_pgcli_path, 'w') as f:
        f.write(pgcli_script.format(install_dir=install_dir))
    os.chmod(full_pgcli_path, 0755)

    print '''
Pager has been installed successfully to {executable_path}

Be sure to add the following to your .bashrc (or similar):
    alias psql='PAGER=vimpsqlpager psql';
    alias pgcli='PAGER=vimpgclipager pgcli';
    '''.format(executable_path=EXECUTABLE_PATH)

if __name__ == '__main__':
    main()
