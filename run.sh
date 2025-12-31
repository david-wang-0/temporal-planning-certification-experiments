TIMEOUT=100s

MEM_LIMIT=56000000 # kibibytes

out_dir="."
domain_dir_name="domain"
benchmarks=()

## !!! Only works with https://www.gnu.org/software/time/
## Not compatible with POSIX time
## uses the format option to get relevant information:
# %%   a literal '%'
# %x   exit status of command
# %e   elapsed real time (wall clock) in seconds
# %M   maximum resident set size in KB
run_with_timeout () {
    local f=$1
    local regex="(.*)%%([0-9]+)%([\.0-9]+)%([0-9]+)"
    msg=$(timeout -p $TIMEOUT bash -c "ulimit -HSv $MEM_LIMIT && { command time -f \"%%%%%x%%%e%%%M\" bash -c \"$f\" ; } 2>&1")
    err=$?
    if [[ $err == 143 ]] ## time out
    then 
        echo "143%%%"
    elif [[ $err == 1 || $err == 127 ]] ## out of memory -- terminated
    then
        echo "128%%%"
    elif [[ $err == 0 ]] ## okay
    then
        if [[ $msg =~ $regex ]]
        then 
            echo "${BASH_REMATCH[2]}%${BASH_REMATCH[3]}%${BASH_REMATCH[4]}%${BASH_REMATCH[1]}"
            # exit_code%time%memory%stdout
            # exit code will be whatever the command output
        else
            echo "129%%%$msg" ## something unexpected happened
        fi
    else
        echo "${err}%%%$msg" ## unknown
    fi
}

# these functions should be called with paths and files (relative to the working directory or absolute)

# grounder
ground_example () {
    local in_domain=$1
    local in_problem=$2
    local out_domain=$3 
    local out_problem=$4
    ./grounder --write-pddl $out_domain $out_problem $in_domain $in_problem >> /dev/null
}

# munta
convert_to_muntax () {
    local domain=$1
    local problem=$2
    local muntax=$3

    ./plan_cert -domain $domain -problem $problem -model $muntax >> /dev/null
}

rename () {
    local muntax=$1
    local rename=$2
    ./plan_cert -model $muntax -renaming $rename
}

ground_and_convert_to_muntax () {
    ground_example $1 $2 $3 $4
    convert_to_muntax $3 $4 $5
}

convert_to_smv () {
    local domain=$1
    local problem=$2
    local smv_file=$3
    ./tamer convert-to --target=smv --output=$smv_file -t constant-promoter -P $domain $problem
}

ground_and_convert_to_smv () {
    ground_example $1 $2 $3 $4
    convert_to_smv $3 $4 $5
}

convert_to_ta_and_q () {
    local domain=$1
    local problem=$2
    local ta_file=$3
    local q_file=$4
    ./tamer convert-to --target=uppaal --model=$ta_file --query=$q_file -t constant-promoter -P $domain $problem
}

ground_and_convert_to_ta_and_q () {
    ground_example $1 $2 $3 $4
    convert_to_ta_and_q $3 $4 $5 $6
}

# TChecker
convert_to_tck () {
    local muntax=$1
    local tck=$2
    python -m convert_models.convert $muntax $tck
}

ground_and_convert_to_tck () {
    ground_example $1 $2 $3 $4
    convert_to_muntax $3 $4 $5
    convert_to_tck $5 $6
}

convert_dot_to_cert () {
    local muntax=$1
    local rename=$2
    local dot=$3
    local cert=$4
    python -m convert_models.convert_certificate -m $muntax $dot $rename $cert
}

rename_and_convert_dot_to_cert () {
    rename $1 $2
    convert_dot_to_cert $1 $2 $3 $4
}

# running and timing
run_tchecker () {
    local tck=$1
    local dot=$2
    local mode=$3
    local search_order=$4

    ./tck-reach -a $mode -C graph -s $search_order -l goal -o $dot $tck
}
export -f run_tchecker

run_tamer () {
    local problem=$1
    local domain=$2
    local mode=$3

    ./tamer solve -a $mode -t constant-promoter -P $problem $domain
}
export -f run_tamer

run_nuxmv () {
    local smv_file=$1

    printf 'go_time; timed_check_invar; quit' | ./nuXmv -int -time $smv_file
}
export -f run_nuxmv


run_uppaal () {
    local ta_file=$1
    local q_file=$2
    
    verifyta -t 0 $ta_file $q_file
}
export -f run_uppaal

# todo: use a regex to detect if they have succeeded in detecting unsolvability and then change the return value

cmd_output_matches () {
    local msg=$1
    local to_match=$2

    local regex="(-?[0-9]+)%(.*)%(.*)%(.*)"

    if [[ $msg =~ $regex ]]
    then
        local return_code=${BASH_REMATCH[1]}
        local time=${BASH_REMATCH[2]}
        local memory_usage=${BASH_REMATCH[3]}
        local cmd_output=${BASH_REMATCH[4]}
        if [[ $cmd_output =~ $to_match ]]
        then
            echo "$return_code%$time%$memory_usage%true"
        else
            echo "$return_code%$time%$memory_usage%false"
        fi
    else
        echo "130%%%" # input ill-formatted
    fi
}

run_and_match_output () {
    local cmd=$1
    local regex=$2
    cmd_output_matches "$(run_with_timeout "$cmd")" "$regex"
}

time_tchecker () {
    local tck=$1
    local dot=$2
    local mode=$3
    local search_order=$4
    
    local cmd="run_tchecker $tck $dot $mode $search_order" 
    local unsolvable_regex=".*REACHABLE false.*"
    run_and_match_output "$cmd" "$unsolvable_regex"
}

time_tamer () {
    local ground_problem=$1
    local ground_domain=$2
    local mode=$3

    local cmd="run_tamer $ground_problem $ground_domain $mode"
    local unsolvable_regex=".*No solution exists\..*"
    run_and_match_output "$cmd" "$unsolvable_regex"
}

time_nuxmv () {
    local smv_file=$1

    local cmd="run_nuxmv $smv_file"
    local unsolvable_regex=".*-- invariant .+ is true.*"
    run_and_match_output "$cmd" "$unsolvable_regex"
}

time_uppaal () {
    local ta_file=$1
    local q_file=$2

    local cmd="run_uppaal $ta_file $q_file"
    local unsolvable_regex=".*-- Formula is NOT satisfied\..*"
    run_and_match_output "$cmd" "$unsolvable_regex"
}

# directories and files
ground_dir_name () {
    echo "$out_dir/ground-pddl-problems/$domain_dir_name"
}

muntax_dir_name () {
    echo "$out_dir/muntax-dir/$domain_dir_name"
}

tck_dir_name () {
    echo "$out_dir/tck-dir/$domain_dir_name"
}

uppaal_dir_name () {
    echo "$out_dir/uppaal-dir/$domain_dir_name"
}

nuxmv_dir_name () {
    echo "$out_dir/nuxmv-dir/$domain_dir_name"
}

make_dirs() {
    echo "Making folders"
    mkdir -p $(ground_dir_name)
    mkdir -p $(muntax_dir_name)
    mkdir -p $(tck_dir_name)
    mkdir -p $(nuxmv_dir_name)
    mkdir -p $(uppaal_dir_name)
}


ground_domain_file () {
    local file_name=$1
    echo "$(ground_dir_name)/${file_name}_domain.pddl"
}

ground_problem_file () {
    local file_name=$1
    echo "$(ground_dir_name)/${file_name}_problem.pddl"
}

muntax_file () {
    local file_name=$1
    echo "$(muntax_dir_name)/${file_name}.muntax"
}

rename_file () {
    local file_name=$1
    echo "$(muntax_dir_name)/${file_name}.rnm"
}

tck_file () {
    local file_name=$1
    echo "$(tck_dir_name)/${file_name}.tck"
}

dot_file () {
    local file_name=$1
    local algo=$2
    echo "$(tck_dir_name)/${file_name}_${algo}.dot"
}

smv_file () {
    local file_name=$1
    echo "$(nuxmv_dir_name)/${file_name}.smv"
}

ta_file () {
    local file_name=$1
    echo "$(uppaal_dir_name)/${file_name}.ta"
}

q_file () {
    local file_name=$1
    echo "$(uppaal_dir_name)/${file_name}.q"
}

# running concrete instances
# these should be called with pddl files and basenames without extensions
ground_and_time_tchecker() {
    local domain=$1
    local instance=$2
    local file_name=$3
    local algo=$4
    local search_order=$5

    local ground_domain_file=$(ground_domain_file $file_name)
    local ground_problem_file=$(ground_problem_file $file_name)
    local muntax_file=$(muntax_file $file_name)
    local tck_file=$(tck_file $file_name)
    local dot_file=$(dot_file $file_name 'covreach')

    ground_and_convert_to_tck $domain $instance $ground_domain_file $ground_problem_file $muntax_file $tck_file
    time_tchecker $tck_file $dot_file $algo $search_order
}

ground_and_time_tamer () {
    local domain=$1
    local instance=$2
    local file_name=$3
    local mode=$4

    local ground_domain_file=$(ground_domain_file $file_name)
    local ground_problem_file=$(ground_problem_file $file_name)

    ground_example $domain $instance $ground_domain_file $ground_problem_file
    time_tamer $ground_domain_file $ground_problem_file $mode
}

time_nuxmv_on_pddl () {
    local domain=$1
    local instance=$2
    local file_name=$3

    local smv_file=$(smv_file $file_name)

    convert_to_smv $domain $instance $smv_file
    time_nuxmv $smv_file
}

ground_and_time_nuxmv () {
    local domain=$1
    local instance=$2
    local file_name=$3

    local ground_domain_file=$(ground_domain_file $file_name)
    local ground_problem_file=$(ground_problem_file $file_name)
    local smv_file=$(smv_file $file_name)

    ground_and_convert_to_smv $domain $instance $ground_domain_file $ground_problem_file $smv_file
    time_nuxmv $smv_file
}

time_uppaal_on_pddl () {
    local domain=$1
    local instance=$2
    local file_name=$3

    local ta_file=$(ta_file $file_name)
    local q_file=$(q_file $file_name)

    convert_to_ta_and_q $domain $instance $ta_file $q_file
    time_uppaal $ta_file $q_file
}

ground_and_time_uppaal () {
    local domain=$1
    local instance=$2
    local file_name=$3

    local ground_domain_file=$(ground_domain_file $file_name)
    local ground_problem_file=$(ground_problem_file $file_name)

    local ta_file=$(ta_file $file_name)
    local q_file=$(q_file $file_name)

    ground_and_convert_to_ta_and_q $domain $instance $ground_domain_file $ground_problem_file $ta_file $q_file
    time_uppaal $ta_file $q_file
}

# just grounding
ground_instance () {
    local domain=$1
    local instance=$2

    local filename=$(basename -- "$instance")
    local extension="${filename##*.}"
    local file_name="${filename%.*}"

    local ground_domain_file=$(ground_domain_file $file_name)
    local ground_problem_file=$(ground_problem_file $file_name)
    ground_example $domain $instance $ground_domain_file $ground_problem_file
}

to_status () {
    local return_code=$1
    if [[ $return_code == "143" ]]
    then
        echo "out of time"
    elif [[ $return_code == "128" ]]
    then
        echo "out of memory"
    elif [[ $return_code == "129" ]]
    then
        echo "output of command unexpected"
    elif [[ $return_code == "130" ]]
    then
        echo "could not interpret correctness of result"
    elif [[ $return_code == "0" ]]
    then
        echo "okay"
    else
        echo "$return_code"
    fi
}

record_result () {
    local instance=$1
    local solver=$2
    local res=$3

    local regex="(-?[0-9]+)%(.*)%(.*)%(.*)"

    if [[ $res =~ $regex ]]
    then
        local return_code=${BASH_REMATCH[1]}
        local time=${BASH_REMATCH[2]}
        local memory_usage=${BASH_REMATCH[3]}
        local correctly_identified=${BASH_REMATCH[4]}

        local status=$(to_status "$return_code")

        if [[ ! -z $file ]]
        then 
            echo "$domain_dir_name,$instance,$solver,$time,$memory_usage,$correctly_identified,$status" >> "$file"
        else 
            echo "$domain_dir_name,$instance,$solver,$time,$memory_usage,$correctly_identified,$status"
        fi
    else
        if [[ ! -z $file ]]
        then 
            echo "Something went wrong while recording result for domain \"$domain_dir_name\": \"$res\"" >> "$file"
        else 
            echo "Something went wrong while recording result for domain \"$domain_dir_name\": \"$res\""
        fi
    fi
}

# main function
run_benchmarks () {
    local domain_file=$1
    local instance_file=$2

    local filename=$(basename -- "$instance")
    local extension="${filename##*.}"
    local instance_name="${filename%.*}"

    echo "Domain: $domain_dir_name"
    echo "Instance: $instance_name"
    for benchmark in "${benchmarks[@]}"; do
        if [[ $benchmark == "tck-covreach" ]]
        then
            echo -e "\tRunning TChecker covered subsumption reachability."
            record_result "$instance_name" "tck-covreach" "$(ground_and_time_tchecker $domain_file $instance_file $instance_name 'covreach' 'dfs')"
        elif [[ $benchmark == "tck-aLU" ]]
        then
            echo -e "\tRunning TChecker aLU abstracted subsumption reachability."
            record_result "$instance_name" "tck-aLUcovreach" "$(ground_and_time_tchecker $domain_file $instance_file $instance_name 'aLU-covreach' 'dfs')"
        elif [[ $benchmark == "tamer-ctp-ground" ]]
        then
            echo -e "\tRunning TAMER ctp (ground)."
            record_result "$instance_name-ground" "TAMER-ctp" "$(ground_and_time_tamer $domain_file $instance_file $instance_name 'ctp')"
        elif [[ $benchmark == "tamer-ftp-ground" ]]
        then
            echo -e "\tRunning TAMER ftp (ground)."
            record_result "$instance_name-ground" "TAMER-ftp" "$(ground_and_time_tamer $domain_file $instance_file $instance_name 'ftp')"
        elif [[ $benchmark == "tamer-ctp" ]]
        then
            echo -e "\tRunning TAMER ctp."
            record_result "$instance_name" "TAMER-ctp" "$(time_tamer $domain_file $instance_file 'ctp')"
        elif [[ $benchmark == "tamer-ftp" ]]
        then
            echo -e "\tRunning TAMER ftp."
            record_result "$instance_name" "TAMER-ctp" "$(time_tamer $domain_file $instance_file 'ftp')"
        elif [[ $benchmark == "nuxmv" ]]
        then
            echo -e "\tRunning nuXmv."
            record_result "$instance_name" "nuXmv" "$(time_nuxmv_on_pddl $domain_file $instance_file $instance_name)"
        elif [[ $benchmark == "nuxmv-ground" ]]
        then
            echo -e "\tRunning nuXmv (ground)."
            record_result "$instance_name-ground" "nuXmv" "$(ground_and_time_nuxmv $domain_file $instance_file $instance_name)"
        elif [[ $benchmark == "uppaal" ]]
        then
            echo -e "\tRunning UPPAAL."
            record_result "$instance_name" "UPPAAL" "$(time_uppaal_on_pddl $domain_file $instance_file $instance_name)"
        elif [[ $benchmark == "uppaal-ground" ]]
        then
            echo -e "\tRunning UPPAAL (ground)."
            record_result "$instance_name-ground" "UPPAAL" "$(ground_and_time_uppaal $domain_file $instance_file $instance_name)"
        else
            echo -e "Benchmark \"$benchmark\" unknown."
        fi
    done
}

show_help () {
  echo "usage:"
  echo "run.sh [args] dir"
  echo "creates <out_dir>/<instance>.muntax from <dir>/<instance>-domain.pddl and <dir>/<instance>-problem.pddl"
  echo "-h : help"
  echo "-p : pddl_directory; (<pddl_dir>) for PDDL (<in_dir>/domain.pddl and <pddl_dir>/instances/<instance>.pddl)"
  echo "-i : instances; e.g. -i path/to/instance1.pddl -i path/to/instance2.pddl ; if left out, then inferred from pddl_dir"
  echo "-d : domain; e.g. domain.pddl ; if left out, then inferred from pddl_dir"
  echo "-o : where to output all files to ; if left out, then into subdirectories in this one"
  echo "-b : set of benchmarks ; -b <tck-covreach> -b <tck-aLU> -b <tamer-ctp> ; if left out just grounds the problem"
  echo "-f : log file ; if unspecified writes to stdout"
}

# https://stackoverflow.com/a/14203146

OPTIND=1         # Reset in case getopts has been used previously in the shell.

while getopts "h?p:i:b:d:o:f:" opt; do
  case $opt in
    h|\?)
      show_help
      exit 0
      ;;
    p) pddl_dir=$OPTARG
      ;;
    i) instances+="$OPTARG"
      ;;
    d) domain=$OPTARG
      ;;
    b) benchmarks+=("$OPTARG")
      ;;
    o) out_dir=$OPTARG
      ;;
    f) file=$OPTARG
      ;;
  esac
done

# obtaining files if none provided
get_instances () {
    echo "$1"/instances/*.pddl
}

get_domain () {
    echo "$1"/domain.pddl
}

find_instance () {
    for i in $2
    do
        echo $1/instances/$i.pddl
    done
}

find_domain () {
    echo $1/$2.pddl
}

# either we have a directory and a few instances
# or we have a domain and a few instances

instances=()
# if we have no instances, we take all
if [ -z ${pddl_dir+x} ]
then 
    echo "No directory for PDDL specified"
    if [ -z ${instances+x} ]
    then
        echo "No instances specified"
        exit
    fi

    if [ -z ${domain+x} ]
    then
        echo "No domain specified"
        exit
    fi
else 
    if [ -z ${instances+x} ]
    then
        echo "No instances specified. Grabbing all from $pddl_dir/instances/"
        instances=$(get_instances $pddl_dir)
    else 
        instances=$(find_instances $pddl_dir $instances)
    fi

    if [ -z ${domain+x} ]
    then
        echo "No domain specified. Using $pddl_dir/domain.pddl"
        domain=$(get_domain $pddl_dir)
    else
        domain=$(find_domain $pddl_dir $domain)
    fi
fi


if [[ (! -z ${pddl_dir}) && (! $(basename $(dirname $pddl_dir)) == ".") && (! $(basename $(dirname $pddl_dir)) == "/") ]] 
then
    echo "Using directory containing PDDL files as name for new directory."
    domain_dir_name=$(basename $pddl_dir)
else 
    echo "Using domain name to identify new directory."
    domain_dir_name=$(basename $domain)
fi

# set up output file
if [[ ! -z $file ]]
then 
    echo "domain,instance,solver,time(s),memory(kB),identified as unsolvable,status" >> "$file"
fi
# make all folders
make_dirs

# run benchmarks and such
if [[ ! -z ${benchmarks} ]]
then
    for instance in $instances 
    do
        run_benchmarks $domain $instance
    done
else
    echo "No benchmarks specified. Grounding."
    for instance in $instances 
    do
        ground_instance $domain $instance
    done
fi
# this script is for a single domain and multiple instances

# what do we want to do?
# run a single instance on every benchmark

# run all instances on every benchmark

# run a single instance on a single benchmark

# run all instances on a single benchmark

# what do we need?
# - a folder for pddl
# - a folder for muntax and renamings and cert
# - a folder for tchecker
# - a folder for uppaal
# - a folder for nuxmv

# which benchmarks do we have?
# - running tchecker with aLU subsumption
# - running tchecker with coverage subsumption
# - running munta?
# - checking coverage subsumption certificates
# - running tamer
# - running uppaal
# - running nuXmv

# what information do we need?
# - time (according to program or time shell command?)
# - maximum memory usage (according to program or shell?)
# tchecker reports in KiB

# What else is needed?
# A good format for returned values

# what do we need to limit?
# - memory usage (do not let exceed; hitting limit does not cause termination)
# - time (hitting limit causes termination)



