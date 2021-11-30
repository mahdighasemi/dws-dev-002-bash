#!/usr/bin/bash

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
    errlog "Usage: try -i INTERVAL -n NUMBER COMMAND"
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
            if [[ ($# -eq 0) || (-z $interval) || (-z $number) ]]; then
                errlog "Usage: try -i INTERVAL -n NUMBER COMMAND"
                exit 1
            fi
            command=$*
            run
            ;;
    esac
done