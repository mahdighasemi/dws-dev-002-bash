#!/usr/bin/bash

# default variable values #
default_number=5
default_interval=12

# to send error log on stderr
function errlog
{
    echo $1 >&2
}

# main function to do job
function run
{
    for i in `seq 1 $number`; do
        # echo -n "This is a try in loop $i "; date
        $command 2> /dev/null
        if [ $? -eq 0 ]; then
            exit 0
        fi
        if [ $i -ne $number ]; then
            sleep $interval
        fi
    done
    errlog "command not found: $command"
    exit 1
}
if [ $1 == "try" ]; then
    shift
else 
    errlog "Usage: try [OPTIONS] COMMAND"
    exit 1
fi
while true; do
    case $1 in
        -i)
            interval=$2
            shift 2
            ;;
        -n)
            number=$2
            shift 2
            ;;
        *)
            if [[ $# -eq 0 ]]; then
                errlog "Usage: try [OPTIONS] COMMAND"
                exit 1
            fi
            if [ -z $number ]; then
                if [ -n "$TRY_NUMBER" ]; then
                    echo "number : $TRY_NUMBER"
                    number=$TRY_NUMBER
                else
                    number=$default_number
                fi
            fi
            if [ -z $interval ]; then
                if [ -n "$TRY_INTERVAL" ]; then
                    echo "interval : $TRY_INTERVAL"
                    interval=$TRY_INTERVAL
                else
                    interval=$default_interval
                fi
            fi
            command=$*
            run
            ;;
    esac
done