#!/bin/bash

# Function to calculate the size of the string in bytes, convert to bits, and convert to hex
string_size_to_hex() {
    local input_string="$1"
    local byte_size=$(( $(echo -n "$input_string" | wc -c) + 30 ))
    local bit_size=$((byte_size * 8))
    local bit_size_reduced=$((bit_size - 144))
    local hex_size=$(printf "%X" "$bit_size")
    local hex_size_reduced=$(printf "%X" "$bit_size_reduced")
    echo "$hex_size $hex_size_reduced"
}

# Read the input string
if [ -n "$1" ]; then
    input_string="$1"
else
    read -p "Enter the input string: " input_string
fi

# Calculate the string size in bits and convert to hex
read hex_size hex_size_reduced < <(string_size_to_hex "$input_string")

# Output the result
#echo "String size in bits: $(( $(echo -n "$input_string" | wc -c) * 8 ))"
#echo "String size in bytes: $(( $(echo -n "$input_string" | wc -c) / 4 - 1))"
#echo "String size in hex (bits): $hex_size"
#echo "String size reduced by 144 bits: $(( ($(echo -n "$input_string" | wc -c) * 8) - 144 ))"
#echo "String size reduced by 144 bits in hex: $hex_size_reduced"
size=$(( $(echo -n "$input_string" | wc -c) / 4 - 1))
size_hex=$(printf "%X" "$size")

if [ $size -ge 112 ] #if hex is longer than 112 reduce it to 112 to avoid negative values
  then
  size=112
fi

center=$(expr 112 - $size)
txt_centr=$(expr $center / 2)
#echo $txt_centr
center_hex=$(printf "%X" "$txt_centr")


    # Check if the hex number is 1 byte (1 or 2 characters long)
    if [[ ${#center_hex} -eq 1 ]]; then
        # Add a leading zero
        center_hex="0$center_hex"
    fi

    # Return the processed hex number
    #echo $center_hex


output=${hex_size}00001050001${hex_size_reduced}0${center_hex}0030${size_hex}$input_string
#output=${hex_size}00001050001${hex_size_reduced}000003070$input_string # Use when other option doesn't work

# Function to calculate CRC-16/XMODEM checksum
calculate_crc16_xmodem() {
    local hex_input="$1"
    local crc=0x0000
    local polynomial=0x1021

    # Convert hex input to bytes
    for (( i=0; i<${#hex_input}; i+=2 )); do
        byte="0x${hex_input:$i:2}"
        byte=$(printf "%d" "$byte")
        crc=$((crc ^ (byte << 8)))

        # Process each bit in the byte
        for (( j=0; j<8; j++ )); do
            if ((crc & 0x8000)); then
                crc=$(((crc << 1) ^ polynomial))
            else
                crc=$((crc << 1))
            fi
        done

        crc=$((crc & 0xFFFF)) # Ensure CRC remains within 16 bits
    done

    printf "%04X\n" "$crc"
}

# Function to flip the bytes of a 16-bit checksum
flip_bytes() {
    local checksum="$1"
    echo "${checksum:2:2}${checksum:0:2}"
}

# Read the hex input string
hex_input_string=$output

# Validate the hex input
if [[ ! "$hex_input_string" =~ ^[0-9A-Fa-f]+$ ]]; then
    echo "Invalid hex input string. Please enter a valid hex string."
    exit 1
fi

# Calculate the CRC-16/XMODEM checksum
crc16_checksum=$(calculate_crc16_xmodem "$hex_input_string")

# Flip the bytes of the checksum
flipped_checksum=$(flip_bytes "$crc16_checksum")

# Output the result
#echo "CRC-16/XMODEM checksum: $crc16_checksum"
#echo "Flipped checksum: $flipped_checksum"
#echo ${output}$flipped_checksum
echo `python3 ./sendit.py -s ${output}$flipped_checksum`
