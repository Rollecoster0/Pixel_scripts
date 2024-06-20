#!/bin/bash

for (( ; ; )); do

	comp=`date +%H:%M`
		if [ "$time" != "$comp" ]

		then

			time=`date +%H:%M` #get current system time

declare -A letter_mapping=(
  ["1"]="0018001c000e0007ffffffff0000"
  ["2"]="f00cf80edc07ce03c703c383c1c7c0fec07c0000"
  ["3"]="300c700ee187c183c183c3c3e7e77e7e3c3c0000"
  ["4"]="0f000fc00cf00c3c0c0fff03ff000c000000"
  ["5"]="31ff71ffe1c3c0e3c063c063e0e37fc33f830000"
  ["6"]="3ffc7ffee307c183c183c183e3877f0e3e0c0000"
  ["7"]="0003c003f0033c030f0303c300f3003f000f0000"
  ["8"]="3e7c7ffee3c7c183c183c183e3c77ffe3e7c0000"
  ["9"]="307c70fee1c7c183c183c183e0c77ffe3ffc0000"
  ["0"]="3ffc7ffee007c003c003c003e0077ffe3ffc0000"
  [":"]="0c300c300000"
  # Add more mappings as needed
)

# Function to convert input text to the mapped text+-+-
convert_text() {
  local input_text="$1"
  local converted_text=""
  for (( i=0; i<${#input_text}; i++ )); do
    char="${input_text:$i:1}"
    if [[ -n "${letter_mapping[$char]}" ]]; then
      converted_text+="${letter_mapping[$char]}"
    else
      converted_text+="$char"  # Keep the character unchanged if it's not in the mapping
    fi
  done
  echo "$converted_text"
}


# Main function
main() {
  input_text=$time
  converted_text=$(convert_text "$input_text")
  echo `./size.sh ${converted_text}`

}

main
		else
			sleep 1
		fi



done

