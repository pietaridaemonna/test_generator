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


# FUNCTIONS ======================================================================

function create_test_tree () {
    mkdir test_suite_$1
    cd test_suite_$1
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
}

function run_until () {
    re=^[a-zA-Z0-9_-]$
    while [[ "$1" =~ ${re} ]]; do    #TODO match only alphanum and _
        echo "NON compliant name.. try again"
    done
}

function fatal_error {
    echo -e "${RED}=================================="
    echo -e "FATAL ERROR${NONE}"
    echo -e "==================================${NONE}"
    echo $1
    echo -e "=================================="
}

# Check if IP address is valid  
function validate_IP {
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

function create_group {
    echo -e "creating group ${YELLOW}$1${NONE}"
}

function create_hostnames_from_file {
    echo -e "creating hostnames from ${YELLOW}$1${NONE}"
}

function group_vars_deploy {
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
function run_setup {
    echo "running setup...."


    tree
}


# MAIN -----------------------------------------------------------------------------------------

echo "---------------------------------------------------------------------------------"
echo "Test GENERATOR"    
echo "---------------------------------------------------------------------------------------"
echo "ansible project generator. https://github.com/pietaridaemonna/test_generator"
echo "---------------------------------------------------------------------------------------"

# CHECK ARGUMENTS
while getopts ":df:" optname
  do
    case "$optname" in
      "d")
        echo -e "using ${YELLOW}dynamic${NONE} inventory (Cobbler, CMDB, etc..)"
        ;;
      "f")
        echo "USING CONFIG FILE, Option $optname has value $OPTARG"
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

if [ $OPTIND -eq 1 ]; then echo "No options were passed";
    run_setup
fi


exit $?