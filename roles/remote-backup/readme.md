# r3b

### basics

- target node needs passwordless sudo rsync
- rsync fetches files incrementally
- restic versions files and takes care of pruning

```
backup.sh      # backup-script
config         # target-config
mirrors        # local rsync target folder
repo           # restic repo folder
restic_pass    # restic passfile
```

### config

- `config/server-name/target-name/folder`
  - single line of target-path on server
- `config/server-name/target-name/exclude`
  - rsync exclude-file, one path/file per line
  - paths are relative to target-folder on server

### todo

- rsync result-checks in script
- log errors in file/variable
- general backup log
- integrate flock in script (or at least in crontab)
- report email
- change structure to variable files:
  - `server-name/target`:
    - ```
      folder=target-path
      exclude=exclude-profile  
      ```   