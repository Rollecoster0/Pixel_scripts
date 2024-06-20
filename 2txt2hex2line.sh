#!/bin/bash

# Define the mapping of letters to prewritten text
declare -A letter_mapping=(
  ["A"]="7e0909097e00"
  ["B"]="7f4949493600"
  ["C"]="3e4141412200"
  ["D"]="7f4141413e00"
  ["E"]="7f4949494100"
  ["F"]="7f0909090100"
  ["G"]="3e4149493100"
  ["H"]="7f0808087f00"
  ["I"]="7f00"
  ["J"]="204040403f00"
  ["K"]="7f0814224100"
  ["L"]="7f4040404000"
  ["M"]="7f060c067f00"
  ["N"]="7f061c307f00"
  ["O"]="3e4141413e00"
  ["P"]="7f0909090600"
  ["R"]="7f0919294600"
  ["S"]="264949493200"
  ["T"]="01017f010100"
  ["U"]="3f4040403f00"
  ["V"]="031c601c0300"
  ["W"]="7f3018307f00"
  ["X"]="413608364100"
  ["Y"]="030478040300"
  ["Z"]="615149454300"
  ["Q"]="3e4151613e00"
  ["Ę"]="1f1575510000"
  ["ę"]="1f1575510000"
  ["Ł"]="7f5048444000"
  ["ł"]="7f5048444000"
  ["Ż"]="6959494d4b00"
  ["ż"]="6959494d4b00"
  ["Ń"]="7e0c1a317e00"
  ["ń"]="7e0c1a317e00"
  ["Ó"]="384446453800"
  ["ó"]="384446453800"
  ["Ą"]="3e09097e4000"
  ["ą"]="3e09097e4000"
  ["Ś"]="244a4b522400"
  ["ś"]="244a4b522400"
  ["Ć"]="3c4243422400"
  ["ć"]="3c4243422400"
  ["Ź"]="62525b4a4600"
  ["ż"]="62525b4a4600"
  ["Ä"]="7c1312137c00"
  ["ä"]="7c1312137c00"
  ["Ü"]="3c4140413c00"
  ["ü"]="3c4140413c00"
  ["Ö"]="384544453800"
  ["ö"]="384544453800"
  ["1"]="04027f000000"
  ["2"]="625149460000"
  ["3"]="224949360000"
  ["4"]="302c73200000"
  ["5"]="4f4949310000"
  ["6"]="3e4949300000"
  ["7"]="016119070000"
  ["8"]="364949493600"
  ["9"]="064949493e00"
  ["0"]="3e4141413e00"
  ["'"]="0300"
  [","]="c000"
  ["."]="4000"
  ["!"]="5f00"
  [":"]="2200"
  ["-"]="08080800"
  ["?"]="060159090600"
  [" "]="0000"

  # Add more mappings as needed
)

unknown_char="060159090600"

# Function to convert input text to the mapped text
convert_text() {
  local input_text="$1"
  local converted_text=""
  local upper_text=$(echo "$input_text" | tr '[:lower:]' '[:upper:]')
  for (( i=0; i<${#upper_text}; i++ )); do
    char="${upper_text:$i:1}"
    if [[ -n "${letter_mapping[$char]}" ]]; then
      converted_text+="${letter_mapping[$char]}"
    else
      converted_text+="$unknown_char"  # display "?" if char not found
    fi
  done
  echo "$converted_text"
}

# Function to interlace two strings after every 2nd bit with padding of "00"
interlace_strings() {
  local str1="$2"
  input_string=$str1
  truncated_string=${input_string:0:224} #limit string lenght to 112 px
  str1=$truncated_string
  local str2="$1"
  input_string=$str2
  truncated_string=${input_string:0:224} #limit string lenght to 112 px
  str2=$truncated_string
  local result=""
  local chunk="00"

  # Determine the lengths of the two strings
  len1=${#str1}
  len2=${#str2}

  # Calculate padding needed to center the shorter string
  if [ $len1 -gt $len2 ]; then
    padding_length=$(( (len1 - len2) / 2 ))
    str2=$(printf "%0${padding_length}s" | tr ' ' '0')$str2$(printf "%0${padding_length}s" | tr ' ' '0')
    [ $(( (len1 - len2) % 2 )) -ne 0 ] && str2+="00"  # if odd, add one more 00 at the end
  elif [ $len2 -gt $len1 ]; then
    padding_length=$(( (len2 - len1) / 2 ))
    str1=$(printf "%0${padding_length}s" | tr ' ' '0')$str1$(printf "%0${padding_length}s" | tr ' ' '0')
    [ $(( (len2 - len1) % 2 )) -ne 0 ] && str1+="00"  # if odd, add one more 00 at the end
  fi

  # Determine the maximum length of the two strings
  max_length=$(( ${#str1} > ${#str2} ? ${#str1} : ${#str2} ))

  # Loop through each character in chunks of 2 in the longer of the two strings
  for (( i=0; i<max_length; i+=2 )); do
    # Append two characters from str1 if available, otherwise append "00"
    if [ $i -lt ${#str1} ]; then
      result="$result${str1:$i:2}"
    else
      result="$result$chunk"
    fi
    # Append two characters from str2 if available, otherwise append "00"
    if [ $i -lt ${#str2} ]; then
      result="$result${str2:$i:2}"
    else
      result="$result$chunk"
    fi
  done

  echo "$result"
}

# Main function to parse arguments and run the script
main() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -s1)
        input_text1="$2"
        shift 2
        ;;
      -s2)
        input_text2="$2"
        shift 2
        ;;
      *)
        echo "Unknown option: $1"
        exit 1
        ;;
    esac
  done

  if [[ -z "$input_text1" || -z "$input_text2" ]]; then
    echo "Both -s1 and -s2 arguments are required."
    exit 1
  fi

  converted_text1=$(convert_text "$input_text1")
  converted_text2=$(convert_text "$input_text2")

  interlaced_text=$(interlace_strings "$converted_text1" "$converted_text2")

    echo `./size.sh $interlaced_text`
    echo $interlaced_text


}

main "$@"
