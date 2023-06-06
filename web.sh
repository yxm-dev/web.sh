#! /bin/bash 

install_dir=~/.config/web.sh
source $install_dir/data

    function web(){
        while [[ "$1" == "-s" ]] || [[ "$1" == "--search" ]]; do
            if [[ -z $2 ]]; then 
                read -e -r -p "Search in ${main_search_engine} for: " main_term
                ${main_search_engine}_function $main_term
                ${main_browser}_function $search
                exit
            fi
            for i in ${!Ns[@]}; do
                if [[ "$2" == "${search_engine[$i]}" ]] && [[ -z $3 ]]; then
                    read -e -r -p "Search in ${search_engine[$i]} for: " term
                    ${search_engine[$i]}_function $term
                    ${main_browser}_function $search
                    exit
                fi
            done
            for i in ${!Ns[@]}; do
            for j in ${!Nb[@]}; do
                if [[ "$2" == "${search_engine[$i]}" ]] && 
                    [[ "$3" == "${browser[$j]}" ]] || 
                    [[ "$2" == "${browser[$j]}" ]] && 
                    [[ "$3" == "${search_engine[$i]}" ]]; then
                        read -e -r -p "Search in ${search_engine[$i]}, from ${browser[$j]}, for: " term
                        ${search_engine[$i]}_function $term
                        ${browser_function[$j]} $search
                        exit
                fi
            done    
            done
                ${main_search_engine}_function $2 $3 $4 $5 $6
                ${main_browser}_function $search
            done

        if [[ "$1" == "-c" ]] || [[ "$1" == "--config" ]]; then
            echo "executing config..."
        elif [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
            echo "displaying help..."
        else
            for i in ${!Nb[@]}; do
                if [[ "$main_browser" == "${browser[$i]}" ]]; then
                   ${browser_function[$i]} $1

                fi
            done
        fi
        }
