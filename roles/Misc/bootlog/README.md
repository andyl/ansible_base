# Boot Log

- 3 variables: defined in private `group_vars`
  - `influxdb_hostname`
  - `influxdb_username`
  - `influxdb_password`
- setup an influx database on `influxdb_hostname`
- setup systemd config to report reboot event

Note: this config relies on a 'bootlog' script in `pdev_util/bin/bootlog`

