#!/bin/bash


# TERMINAL COLORS -----------------------------------------------------------------
NONE='\033[00m'
RED='\033[01;31m'
GREEN='\033[01;32m'
YELLOW='\033[01;33m'
BLACK='\033[30m'
BLUE='\033[34m'
VIOLET='\033[35m'
CYAN='\033[36m'
GREY='\033[37m'

# VARIABLES -----------------------------------------------------------------------
selected_tests=()
ignored_test=()
test_results=()


# DECORATORS

# @TASK.name('jsdflksfjsdjf')
# @TASK.expected_result('skdf')
# @TASK.actual_result('lsdkfj')
# @TASK.run_time('time')

# TEST FUNCTIONS =================================================================

function test_failure () {
    echo -e "${RED}FAILURE${NONE}"
    echo -e "==================================${NONE}"
    echo $1
    echo -e "=================================="
}

function test_success () {
    echo -e "${GREEN}SUCCESS${NONE}"
    echo -e "==================================${NONE}"
    echo $1
    echo -e "=================================="
}

function test_unclear () {
    echo -e "${YELLOW}UNCLEAR${NONE}"
    echo -e "==================================${NONE}"
    echo $1
    echo -e "=================================="
}


# FUNCTIONS ======================================================================

function create_test_tree () {
    mkdir test_suite_$1

    cd test_suite_$1
    touch test_plan.suite
    mkdir tests
    cd tests

    cat <<EOF
    #!/usr/bin/env bats

@test "Check if linux" {
	run uname
	[ $output = "Linux" ]
}


# check if VT-x is on CPU, egrep '^flags.*(vmx|svm)' /proc/cpuinfo
@test "check if VT-x is on CPU" {
	run bash -c "egrep '^flags.*(vmx|svm)' /proc/cpuinfo"
	[ "$output" != "" ]
}

# check if VT-x is on CPU, egrep '^flags.*(vmx|svm)' /proc/cpuinfo
@test "check if tree installed" {
	run tree
	[ $status -eq 0 ]
}

# check if VT-x is on CPU, egrep '^flags.*(vmx|svm)' /proc/cpuinfo
@test "check if perl installed" {
    skip
	run perl -v
	[ $status -eq 0 ]
}
    EOF

    mkdir installation_test
    mkdir compatibility_test
    mkdir smoke_test
    mkdir regression_test
    mkdir acceptance_test
    mkdir alpha_test
    mkdir beta_test
    mkdir continuous_test
    mkdir destructive_test
    mkdir performance_test
    mkdir security_test
    mkdir internationalization_test
    cd ..

    mkdir DATA
}

function collect_CLOUD_tools () {
    sudo apt-get install python-pip
    pip install tox

    git clone https://github.com/cisco-oss-eng/Cloud99.git
    git clone https://github.com/openstack/rally.git
}

function run_until () {
    re=^[a-zA-Z0-9_-]$
    while [[ "$1" =~ ${re} ]]; do    #TODO match only alphanum and _
        echo "NON compliant name.. try again"
    done
}

function fatal_error () {
    echo -e "${RED}=================================="
    echo -e "FATAL ERROR${NONE}"
    echo -e "==================================${NONE}"
    echo $1
    echo -e "=================================="
}

# Check if IP address is valid  
function validate_IP () {
        local ip=$1
	local stat=1
	# Check the IP address under test to see if it matches the extended REGEX

	if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
		# Record current default field separator
		OIFS=$IFS
		# Set default field separator to .
		IFS='.'
		# Create an array of the IP Address being tested
		ip=($ip)
		# Reset the field separator to the original saved above IFS=$OIFS
		# Is each octet between 0 and 255?
		[[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
		# Set the return code.
		stat=$?
	fi
}

function create_group () {
    echo -e "creating group ${YELLOW}$1${NONE}"
}

function create_hostnames_from_file () {
    echo -e "creating hostnames from ${YELLOW}$1${NONE}"
}

function group_vars_deploy () {
    echo -e "Do you want to copy group_vars from local file? ${GREEN}[Y/N]${NONE}:"
    read answer

    case ${answer} in
    "Y") echo "enter ${GREEN}PATH${NONE} to group_vars file"
        read groupvar_path
        ;;
    "N") echo "generating defaults"
        echo "# here we assign variables to particular groups" > group_vars/db_group
        echo "# here we assign variables to particular groups" > group_vars/web_group
        echo "# here we assign variables to particular groups" > group_vars/app_group
        echo "# here we assign variables to particular groups" > group_vars/jump_group
        ;;
    *) echo "not an answer... generating defaults"
        echo "# here we assign variables to particular groups" > group_vars/db_group
        echo "# here we assign variables to particular groups" > group_vars/web_group
        echo "# here we assign variables to particular groups" > group_vars/app_group
        echo "# here we assign variables to particular groups" > group_vars/jump_group
        ;;
    esac
}

# MAIN SETUP
function run_setup () {
    echo "running setup...."


    tree
}


function print_options () {
    tree
}


# MAIN -----------------------------------------------------------------------------------------

echo "---------------------------------------------------------------------------------"
echo "Test GENERATOR"    
echo "---------------------------------------------------------------------------------------"
echo "Testing area generator. https://github.com/pietaridaemonna/test_generator"
echo "---------------------------------------------------------------------------------------"

# CHECK ARGUMENTS
while getopts ":sc" optname
  do
    case "$optname" in
      "s")
        echo -e "creating ${YELLOW}SOFTWARE TEST${NONE}"
        ;;
      "c")
        echo -e "creating ${YELLOW}CLOUD TEST${NONE}"
        ;;
      "?")
        fatal_error "INVALID ARGUMENT"
        exit 1
        ;;
      ":")
        echo "No argument value for option $OPTARG"
        ;;
      *)
      # Should not occur
        echo "Unknown error while processing options"
        ;;
    esac
  done

if [ $OPTIND -eq 1 ]; then echo "No options were passed.. use either -s [Software test] or -c [Cloud test]";
    print_options
fi

create_test_tree $1


exit $?