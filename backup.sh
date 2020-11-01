#!/bin/sh

keyboard_interrupt() {
  echo "WARN: Interrupted by user."
  exit 1
}

trap keyboard_interrupt SIGINT

usage() {
  cat << EOF
usage: backup.sh [-h] [-c config] [-d]

   -h           display this message and exit
   -c config    load configuration from file 'config'
   -l logdir    directory to store log files
   -d           run in debug mode

Configuration File:
   MASTER_DISKS    an array with the directories to backup
   BACKUP_VOLUMES  an array with the path to the backup modules
   EXCLUDE_LIST    an array of patterns to be excluded from backup
EOF
  exit $1
}

die() {
  echo "$*"
  exit 2
}

start_log() {
    LOG="$1"
    mkdir -p "`dirname ${LOG}`"
    [ ! -f "${LOG}" ] && touch "${LOG}"
    echo "========================================" | tee -a "$LOG"
    echo " Backup performed at `date +"%Y-%m-%d %H:%M"`" | tee -a "$LOG"
    echo "========================================" | tee -a "$LOG"
}

backup_directory() {
    [ "$DEBUG" == "y" ] && DBG="--dry-run" || DBG=""
    SOURCE="$1"
    DEST="$2"
    LOG="$3"
    BKP_EXCL="$4"
    HISTORY_DIR="`date +"history/history_%Y%m%d_%H%M%S"`"
    RSYNC_OPTS="-avhb --progress --delete --delete-during --backup-dir=${HISTORY_DIR}"
    EXCLUDE_OPTS="--exclude-from=${BKP_EXCL}"
    echo "Copying from '${SOURCE}' to '$DEST'" | tee -a "${LOG}"
    rsync ${DBG} ${RSYNC_OPTS} ${EXCLUDE_OPTS} "${SOURCE}" "${DEST}" | tee -a "${LOG}"
}

# --- main ---

CONFIG="${HOME}/.config/backup_catalog/config"
LOGDIR="${HOME}/.config/backup_catalog/logs"
DEBUG="n"
BKP_EXCL='/tmp/backup_catalog.excl'
EXCLUDE_LIST=''

argv=`getopt -hc:l:d $*`
errcode=$?

[ $errcode -ne 0 ] && usage $errcode

set -- $argv

for opt
do
    case "$opt" in
        -h)
            usage 0
        ;;
        -c)
            CONFIG=$2
            shift 2
        ;;
        -l)
            LOGDIR=$2
            shift 2
        ;;
        -d)
            DEBUG="y"
            shift
        ;;
        --)
            shift
        ;;
        *)
            echo "Invalid option: $opt"
            usage 1
        ;;
    esac
done

if [ -f "${CONFIG}" ]
then
    . "${CONFIG}"
else
    die "Could not find config file: $CONFIG"
fi

LOGFILE="${LOGDIR}/`date +'%Y-%m-%d_%H%M'`.log"

cat << EOF > "${BKP_EXCL}"
.Spotlight*/
.DocumentRevisions*/
.DS_Store
.TemporaryItems
.Trashes
.apdisk
.fseventsd
EOF
[ -z "${EXCLUDE_LIST}" ] || for excl in ${EXCLUDE_LIST[@]}
do
    echo "${excl}" >> "${BKP_EXCL}"
done

if [ -z "${MASTER_DISKS}" -o -z "${BACKUP_VOLUMES}" ]
then
    die "Must define MASTER_DISKS and BACKUP_VOLUMES."
fi

start_log "${LOGFILE}"

for MASTER in ${MASTER_DISKS[@]}
do
    for BACKUPDIR in ${BACKUP_VOLUMES[@]}
    do
        backup_directory "${MASTER}" "${BACKUPDIR}" "${LOGFILE}" "${BKP_EXCL}"
    done
done

rm -f /tmp/backupcatalog.excl
