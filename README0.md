# COI-flyway #

Installs and manage flyway command line tool and gives defines to use database migrations.

## Example usage of COI-flyway module

To install flyway-commandline in version 4.2.0:

```puppet
include flyway
```
In order to choose other version of flyway, use class `flyway::params` and set proper parameter.

To download and unpack zip file (from url or disk):
```puppet
flyway::loadsql::zip { 'https://the.earth.li/~sgtatham/putty/latest/puttydoc.zip':
  # parameter to create directory in flyway sql directory
  namespace => 'pesel',
}
```
```puppet
flyway::loadsql::zip { '/usr/src/db_schema.zip':
  namespace => 'migration1',
}
```
To implement changes on database:

```puppet
flyway::migrate { 'pgsql':
  url      =>  'jdbc:postgresql://localhost/mydatabasename',
  user     =>  'mydatabaseuser',
  password =>  'mypassword',
}
```
In order to change database or/and configuration flyway file `*.conf`, use parameters from define `flyway::migrate`.
