import argparse
import serial

def main():
    # Parse command-line arguments
    parser = argparse.ArgumentParser(description='Send custom string over RS485.')
    parser.add_argument('-s', '--string', required=True, help='Custom string to send.')
    args = parser.parse_args()

    # Configure the serial port for RS485 communication
    ser = serial.Serial(
        port='/dev/ttyUSB0',
        baudrate=4800,
        bytesize=serial.EIGHTBITS,
        parity=serial.PARITY_EVEN,
        stopbits=serial.STOPBITS_ONE
    )

    # Define the data to send (hex and ASCII)
    custom_string = args.string.encode('ascii')
    data = b'\x01' + b'20DDB' + custom_string + b'\x0D' + b'\x0A' + b'\x04'

    # Send the data
    ser.write(data)

    # Close the serial port
    ser.close()

if __name__ == '__main__':
    main()
