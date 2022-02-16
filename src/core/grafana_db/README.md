# Grafana Database

This is an empty and newly generated Grafana sqlite3 database.

It is modified with following command:

``` bash
$ sqlite3 grafana.db 'pragma journal_mode=wal;'
```

## Why

Follow this issue https://github.com/grafana/grafana/issues/20549

## How

After creating a new Grafana stack, this file will overwrite the one
generated from Grafana itself.
