#!/bin/bash

function prog_exists {
    command -v $1

    if [ $? -eq 0 ]
    then
	echo -e "$1 \e[1mexists"
    else
	echo "There be no $ here!"
    fi
}

# function run_program {

# }

# Check for python
#echo $?

progs=(
    "python"
    "python3"
    "pip"
    "virtualenv"
    "pyenv"
)
for i in "${progs[@]}"; do
    prog_exists $i
done

# command -v python
# if [ $? -eq 0 ]
# then
#     echo "Python exists"
# else
#     echo "There be no python here! The front line is everywhere!"
# fi

#echo $?
#command -v python3
