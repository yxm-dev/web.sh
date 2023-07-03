<<<<<<< HEAD
#! /bin/bash

install_dir=~/.config/web.sh
=======
! /bin/bash

WEB_install_dir=~/.config/web.sh
>>>>>>> a252fea (...)

# declaring
    declare -a web_browser
    declare -A web_browser_CLI
    declare -A web_browser_is_term_based
    declare -a search_engine
    declare -A search_engine_base
    declare -a search_engine_function
# including cfile
<<<<<<< HEAD
    source $install_dir/cfile
=======
    source $WEB_install_dir/cfile
>>>>>>> a252fea (...)

# WEB FUNCTION
    function web(){
## Auxiliary Data
### array of options
        declare -a options
        options[0]="-s"
        options[1]="--search" 
        options[2]="-c"
        options[3]="--config"
        options[4]="-h"
        options[5]="--help"
### arrays of browser options
        declare -a dash_web_browser
        declare -a dash_dash_web_browser
        for i in ${!web_browser[@]}; do
            dash_web_browser[$i]="-${web_browser[$i]}"
            dash_dash_web_browser[$i]="--${web_browser[$i]}"
        done
### arrays of search engine options
        declare -a dash_search_engine
        declare -a dash_dash_search_engine
        for i in ${!search_engine[@]}; do
            dash_search_engine[$i]="-${search_engine[$i]}"
            dash_dash_search_engine[$i]="--${search_engine[$i]}"
        done
### web browser functions
        for i in ${web_browser[@]}; do
            if [[ "${web_browser_is_term_based[$i]}" == "no" ]] ||
               [[ "${web_browser_is_term_based[$i]}" == "n" ]] ||
               [[ "${web_browser_is_term_based[$i]}" == "No" ]] ||
               [[ "${web_browser_is_term_based[$i]}" == "N" ]] ||
               [[ "${web_browser_is_term_based[$i]}" == "NO" ]]; then
                    eval "function ${i}_web_browser_function(){
                        ${web_browser_CLI[$i]} \$1 & disown && exit
                        }"
            elif [[ "${web_browser_is_term_based[$i]}" == "yes" ]] ||
                 [[ "${web_browser_is_term_based[$i]}" == "y" ]] ||
                 [[ "${web_browser_is_term_based[$i]}" == "Yes" ]] ||
                 [[ "${web_browser_is_term_based[$i]}" == "Y" ]] ||
                 [[ "${web_browser_is_term_based[$i]}" == "YES" ]]; then
                    eval "function ${i}_web_browser_function(){
                          ${web_browser_CLI[$i]} \$1
                        }"
            fi
        done       
### search engine functions
        for i in ${search_engine[@]}; do 
            eval "function ${i}_search_engine_function(){
                term=\${1// /+}
                search=${search_engine_base[$i]}?q=\$term
            }"
        done
## Web Function Properly
### config option
        if [[ "$1" == "-c" ]] || [[ "$1" == "--config" ]] || [[ "$1" == "-cfg" ]]; then
            echo "executing config..."
### help option
        elif [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
            echo "displaying help..."
### search mode
        elif [[ "$1" == "-s" ]] || [[ "$1" == "--search" ]]; then
#### read search mode, main browser/search engine
            if [[ -z $2 ]]; then
                read -e -r -p "Search in ${main_search_engine} for: " main_term
                ${main_search_engine}_search_engine_function "$main_term"
                ${main_web_browser}_web_browser_function $search
            fi
#### read search mode
            end1=${#search_engine[@]}
            end2=${#web_browser[@]}
            for (( i=0; i<=$end1; i++ ))
            do
                for (( j=0; i<=$end2; j++ ))
                do
##### main browser
                    if ([[ "$2" == "--${search_engine[$i]}" ]] ||
                        [[ "$2" == "-${search_engine[$i]}" ]]) && 
                        [[ -z "$3" ]]; then
                        read -e -r -p "Search in ${search_engine[$i]} for: " term
                        ${search_engine[$i]}_search_engine_function $term
                        ${main_web_browser}_web_browser_function $search
##### main search engine
                    elif ([[ "$2" == "--${web_browser[$j]}" ]] ||
                          [[ "$2" == "-${web_browser[$j]}" ]]) &&
                          [[ -z "$3" ]]; then
                            if [[ -x "$(command ${web_browser[$j]})" ]]; then
                                read -e -r -p "Search in ${web_browser[$j]} for: " term
                                ${main_search_engine}_search_engine_function $term
                                ${web_browser[$j]}_web_browser_function $search
                            else
                                echo "The browser \"${web_browser[$j]}\" is not installed."
                                break
                            fi
                            break
                                 
##### main browser/search engine
                    elif ( ([[ "$2" == "--${web_browser[$j]}" ]] ||
                          [[ "$2" == "-${web_browser[$j]}" ]]) &&
                         ([[ "$3" == "--${search_engine[$i]}" ]] ||
                          [[ "$3" == "-${search_engine[$i]}" ]]) )
                       ( ([[ "$3" == "--${web_browser[$j]}" ]] ||
                          [[ "$3" == "-${web_browser[$j]}" ]]) &&
                         ([[ "$2" == "--${search_engine[$i]}" ]] ||
                          [[ "$2" == "-${search_engine[$i]}" ]]) ); then
                            if [[ -x "$(command ${web_browser[$j]})" ]]; then
                                read -e -r -p "Search in ${search_engine[$i]} with ${web_browser[$j]} for: " term
                                ${search_engine[$i]}_search_engine_function $term
                                ${web_browser[$j]}_web_browser_function $search
                            else
                                echo "The browser \"${web_browser[$j]}\" is not installed."
                                break
                            fi
                    fi
                done
            done
#### direct search mode using the n>1 variables.
            if [[ ! "${dash_search_engine[@]}" =~ "$2" ]] && 
               [[ ! "${dash_dash_search_engine[@]}" =~ "$2" ]] &&
               [[ ! "${dash_web_browser[@]}" =~ "$2" ]] &&
               [[ ! "${dash_dash_web_browser[@]}" =~ "$2" ]]; then
                    declare -a array
                    array[0]=$2
                    end=$(($#-2))
                    for (( i=1; i<=$#; i++ ))
                    do
                        j=$(($i+2))
                        array[$i]="${array[$i-1]} ${!j}"
                    done
                    var=${array[${end}]}
                    var=${var// /+}
                    ${main_search_engine}_search_engine_function "$var"
                    ${main_web_browser}_web_browser_function $search
            fi
### open url mode
        elif [[ ! ${opt[@]} =~ "$1" ]] && [[ -z "$2" ]]; then
                expression=${1//s /+}
                ${main_search_engine}_function $expression
                ${main_web_browser}_function $search
        else
### error
            echo "option not defined for \"web\" function."
        fi
## Unseting Auxiliary Functions
        for i in ${web_browser[@]}; do
            eval "unset -f ${i}_web_browser_function
                  unset -f ${i}_search_engine_function
                 "
        done
    }

# ALIASES
    alias webs="web -s"
    alias webc="web -c"
    alias webh="web -h"

