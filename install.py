import os, sys

PSQL_FILENAME = 'vimpsqlpager'
PGCLI_FILENAME = 'vimpgclipager'
EXECUTABLE_PATH = '/usr/bin/'

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
        sys.exit('Installation must be executed as the root user')

    install_dir = os.getcwd()

    with open(os.path.join(EXECUTABLE_PATH, PSQL_FILENAME), 'w') as f:
        f.write(psql_script.format(install_dir=install_dir))
    os.chmod(PSQL_FILENAME, 0755)

    with open(os.path.join(EXECUTABLE_PATH, PGCLI_FILENAME), 'w') as f:
        f.write(pgcli_script.format(install_dir=install_dir))
    os.chmod(PGCLI_FILENAME, 0755)

    print '''
Be sure to add the following to your .bashrc (or similar):
    alias psql='PAGER=vimpsqlpager psql';
    alias pgcli='PAGER=vimpgclipager pgcli';
    '''

if __name__ == '__main__':
    main()
