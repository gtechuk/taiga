

# Taiga Docker

## Usage

To use copy .example.env to .env and update with your own settings.

## Backup and Restore

### PostgreSQL
*Backup*

```docker exec -t $(basename `pwd`)_postgres_1 pg_dumpall -c -U postgres > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql```

*Restore*

```cat <backup>.sql | docker exec -i  $(basename `pwd`)_postgres_1 psql -U postgres```

