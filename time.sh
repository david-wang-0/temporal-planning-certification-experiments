TIMEOUT=3s

run_with_timeout () {
    local f=$1
    local regex="real\s+([0-9]+)m([0-9]+),([0-9]+)s.+"
    msg=$(timeout $TIMEOUT bash -c "{ time $f; } 2>&1")
    if [[ $? == 124 ]]
    then 
        echo "-1"
    else
        if [[ $msg =~ $regex ]]
        then 
            echo "${BASH_REMATCH[1]}:${BASH_REMATCH[2]}.${BASH_REMATCH[3]}"
        else
            echo "-2"
        fi
    fi
}

run_tchecker () {
    local tck=$1
    local dot=$2
    local mode=$3
    local search_order=$4
    ./tck-reach -a $mode -C graph -s $search_order -l goal -o $dot $tck
}
export -f run_tchecker

time_tchecker () {
    local tck=$1
    local dot=$2
    local mode=$3
    local search_order=$4
    run_with_timeout "run_tchecker $tck $dot $mode $search_order"
}

function t() {
    time_tchecker tck_examples/sync-impossible/instance_1_4.tck tck_examples/sync-impossible/instance_1_4.dot covreach bfs
}


msg=$(run_with_timeout "sleep 2")
echo $msg
