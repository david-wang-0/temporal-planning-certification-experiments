TIMEOUT=300s
MEM_LIMIT=56000000 # kibibytes

out_dir="."
domain_dir_name="domain"
benchmarks=()


run_with_timeout () {
    local f=$1
    local regex="real\s+([0-9]+)m([0-9]+),([0-9]+)s.+"
    msg=$(timeout $TIMEOUT bash -c "ulimit -HSv $MEM_LIMIT && { time $f; } 2>&1")
    err=$?
    if [[ $err == 124 ]] ## time out
    then 
        echo "-1"
    elif [[ $err == 1 ]] ## out of memory
    then
        echo "-2"
    elif [[ $err == 0 ]] ## okay
    then
        if [[ $msg =~ $regex ]]
        then 
            echo "${BASH_REMATCH[1]}:${BASH_REMATCH[2]}.${BASH_REMATCH[3]}"
            # "minutes:seconds.milliseconds"
        else
            echo "-3" ## unknown
        fi
    else
        echo "-3" ## unknown
    fi
}

ground_example () {
    local in_domain=$1
    local in_problem=$2
    local out_domain=$3 
    local out_problem=$4
    ./grounder --write-pddl $out_domain $out_problem $in_domain $in_problem >> /dev/null
}

convert_to_muntax () {
    local domain=$1
    local problem=$2
    local muntax=$3

    ./plan_cert -domain $domain -problem $problem -model $muntax >> /dev/null
}

convert_to_tck () {
    local muntax=$1
    local tck=$2
    python -m convert_models.convert $muntax $tck
}

ground_and_convert_to_muntax () {
    ground_example $1 $2 $3 $4
    convert_to_muntax $3 $4 $5
}

ground_and_convert_to_tck () {
    ground_example $1 $2 $3 $4
    convert_to_muntax $3 $4 $5
    convert_to_tck $5 $6
}

rename () {
    local muntax=$1
    local rename=$2
    ./plan_cert -model $muntax -renaming $rename
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


get_instances () {
    local pddl_dir=$1
    echo "$pddl_dir"/instances/*.pddl
}

get_domain () {
    local pddl_dir=$1
    echo "$pddl_dir"/*domain.pddl
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

run_tamer () {
    local ground_problem=$1
    local ground_domain=$2
    local mode=$3

    ./tamer solve -a $mode -t constant-promoter -P $ground_problem $ground_domain
}
export -f run_tamer

time_tamer () {
    local ground_problem=$1
    local ground_domain=$2
    local mode=$3

    run_with_timeout "run_tamer $ground_problem $ground_domain $mode"
}


ground_dir_name () {
    echo "$out_dir/ground-pddl-problems/$domain_dir_name"
}

muntax_dir_name () {
    echo "$out_dir/muntax-dir/$domain_dir_name"
}

tck_dir_name () {
    echo "$out_dir/tck-dir/$domain_dir_name"
}

make_dirs() {
    echo "Making folders"
    mkdir -p $(ground_dir_name)
    mkdir -p $(muntax_dir_name)
    mkdir -p $(tck_dir_name)
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

run_tck() {
    local problem=$1
    local instance=$2
    local file_name=$3
    local algo=$4
    local search_order=$5

    local ground_domain_file=$(ground_domain_file $file_name)
    local ground_problem_file=$(ground_problem_file $file_name)
    local muntax_file=$(muntax_file $file_name)
    local tck_file=$(tck_file $file_name)
    local dot_file=$(dot_file $file_name 'covreach')

    ground_and_convert_to_tck $problem $instance $ground_domain_file $ground_problem_file $muntax_file $tck_file
    time_tchecker $tck_file $dot_file $algo $search_order
}

ground_and_run_tamer () {
    local problem=$1
    local instance=$2
    local file_name=$3
    local mode=$4

    local ground_domain_file=$(ground_domain_file $file_name)
    local ground_problem_file=$(ground_problem_file $file_name)
    ground_example $problem $instance $ground_domain_file $ground_problem_file

    time_tamer $ground_domain_file $ground_problem_file $mode
}



ground_instance () {
    local problem=$1
    local instance=$2

    local filename=$(basename -- "$instance")
    local extension="${filename##*.}"
    local file_name="${filename%.*}"

    local ground_domain_file=$(ground_domain_file $file_name)
    local ground_problem_file=$(ground_problem_file $file_name)
    ground_example $problem $instance $ground_domain_file $ground_problem_file
}

run_benchmarks () {
    local domain=$1
    local instance=$2

    local filename=$(basename -- "$instance")
    local extension="${filename##*.}"
    local file_name="${filename%.*}"

    echo "Domain: $domain"
    echo "Instance: $instance"
    for benchmark in $benchmarks; do
        if [[ $benchmark == "tck-covreach" ]]
        then
            echo "TChecker covered subsumption reachability: "
            run_tck $domain $instance $file_name 'covreach' 'dfs' 
        elif [[ $benchmark == "tck-aLU" ]]
        then
            echo "TChecker aLU abstracted subsumption reachability: "
            run_tck $domain $instance $file_name 'aLU-covreach' 'dfs'
        elif [[ $benchmark == "tamer-ctp-ground" ]]
        then
            echo "TAMER ctp (ground):"
            ground_and_run_tamer $domain $instance $file_name 'ctp'
        elif [[ $benchmark == "tamer-ftp-ground" ]]
        then
            echo "TAMER ftp (ground):"
            ground_and_run_tamer $domain $instance $file_name 'ftp'
        elif [[ $benchmark == "tamer-ctp" ]]
        then
            echo "TAMER ctp:"
            time_tamer $domain $instance 'ctp'
        elif [[ $benchmark == "tamer-ftp" ]]
        then
            echo "TAMER ftp:"
            time_tamer $domain $instance 'ftp'
        elif [[ $benchmark == "nuXmv" ]]
        then
            echo "unimplemented"
        elif [[ $benchmark == "uppaal" ]]
        then
            echo "unimplemented"
        else
            echo "Benchmark \"$benchmark\" unknown"
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
  echo "-b : set of benchmarks ; <tck-covreach> <tck-aLU> <tamer-ctp> ; if left out just grounds the problem"
}

# https://stackoverflow.com/a/14203146

OPTIND=1         # Reset in case getopts has been used previously in the shell.

while getopts "h?p:i:b:d:o:" opt; do
  case "$opt" in
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
  esac
done

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

make_dirs
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
# - running munta
# - checking coverage subsumption certificates
# - running tamer
# - running uppaal
# - running nuXmv

# what information do we need?
# - time (according to program)
# - maximum memory usage (according to program)
# tchecker reports in KiB

# what do we need to limit?
# - memory usage (do not let exceed; hitting limit does not cause termination)
# - time (hitting limit causes termination)



