#!/bin/bash

# When you launch the script it should initially list all tcp connections in the port
# range 10000-10100. New found connections should be displayed in the console as soon
# as they're identified.

START_PORT=10000
END_PORT=10100
TIME_OUT=5
HEADER_LIST="Local Address:Port      Peer Address:Port"
all_ports=""

while true; do
  # Get the required ports
  ports=$( ss -ltnpH "( sport ge ${START_PORT} && sport le ${END_PORT} )" )
  # Looking for new ports
  new_port=$( comm -13 <(echo "${all_ports}") <(echo "${ports}") )

  if [[ -z "${ports}" ]]; then
    echo "No TCP listening sockets found bound to ports in ${START_PORT}-${END_PORT} range"
  elif [[ ! -z "${new_port}" ]]; then
    if [[ -z "${all_ports}" ]]; then
      echo "${HEADER_LIST}"
    fi
    # Display the new port in the table
    echo "${new_port}" | sed -E "s/[[:space:]]+/ /g" | cut -d' ' -f 4,5 | sed -E "s/ /\t\t/"
  fi

  all_ports="${ports}"
  sleep "${TIME_OUT}"
done
