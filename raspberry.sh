#!/bin/bash

# Set the ngrok server address and port
NGROK_SERVER="0.tcp.ngrok.io"
NGROK_PORT="1988"

# Set the AT command to establish TCP connection
TCP_CONNECT_CMD="AT+CIPSTART=\"TCP\",\"$NGROK_SERVER\",$NGROK_PORT"

# Send the AT command to establish TCP connection
echo -e "Sending TCP connection request to $NGROK_SERVER:$NGROK_PORT\n"
echo -e "AT command: $TCP_CONNECT_CMD\n"
echo -e "$TCP_CONNECT_CMD\n" > /dev/ttyS0

# Wait for a response (adjust sleep duration as needed)
sleep 5

# Check if the TCP connection is successfully established
# This might require parsing the response from the SIM7600 module
# For simplicity, we assume the connection is successful

# Continuously send the AT+CGPSINFO command and send the output through the socket
while true; do
  echo -e "Requesting GPS info...\n"
  echo -e "AT command: AT+CGPSINFO\n"
  echo -e "AT+CGPSINFO\n" > /dev/ttyS0

  # Wait for a response (adjust sleep duration as needed)
  sleep 5

  # Check if there is any data available on the serial port
  if [ -s /dev/ttyS0 ]; then
    # Read the response from the serial port and send it through the socket
    GPS_INFO=$(cat /dev/ttyS0)
    echo -e "Sending GPS info over TCP connection...\n"
    echo -e "$GPS_INFO\n" > /dev/ttyS0
  fi

  # Wait before sending the next command
  sleep 5
done

# Close the TCP connection (this will never be reached in the current script)
echo -e "Closing TCP connection...\n"
echo -e "AT command: AT+CIPCLOSE\n"
echo -e "AT+CIPCLOSE\n" > /dev/ttyS0

echo -e "Script completed.\n"
