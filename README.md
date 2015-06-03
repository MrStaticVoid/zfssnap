# zfssnap
Tools for performing automatic snapshots and remote incremental backups.

Instructions for my reference:

## Initial Backup
1. On the destination host, create a place to send the backup to:

        # zfs create nest/backup/nodes/<nodename>
    
1. On the source host, perform an initial backup:

    1. Find the latest daily snapshot:
    
            # zfs list -H -o name -t snapshot | grep rpool@zfs-auto-snap_daily | tail -1
    
    1. Perform a full backup:
    
            # zfs send -R <snapshot from last step> | ssh root@hawk zfs receive -vdFu nest/backup/nodes/<nodename>

1. On the destination host, unset some received properties:

        # zfs inherit -r mountpoint nest/backup/nodes/<nodename>
        # zfs inherit -r com.sun:auto-snapshot nest/backup/nodes/<nodename>

## New Dataset
If you create a new dataset, it may be out-of-sync with the existing incremental backups and you will get an error message like:

        cannot receive incremental stream: destination 'nest/backup/nodes/<nodename>/<new dataset>' does not exist

In this case, perform a full replication of the new dataset to bring it in line with the incremental stream.

1. On the source host, determine the newest remote snapshot:

        # sudo -u zfssnap -s
        % zfs-backup -vn
        ...
        newest remote snapshot: zfs-auto-snap_frequent-2015-06-03-1200
        ...

1. Perform the full replication of the new dataset:

        # zfs send -R <new dataset>@<newest remote snapshot from last step> | ssh root@hawk zfs receive -vdFu nest/backup/nodes/<nodename>

1. On the destination host, unset some received properties:

        # zfs inherit -r mountpoint nest/backup/nodes/<nodename>
        # zfs inherit -r com.sun:auto-snapshot nest/backup/nodes/<nodename>
