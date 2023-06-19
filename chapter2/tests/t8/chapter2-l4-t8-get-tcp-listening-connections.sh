#!/bin/bash

# When you launch the script it should initially list all tcp connections in the port
# range 10000-10100. New found connections should be displayed in the console as soon
# as they're identified.

start_port=10000
end_port=10100
time_out=5
all_ports=""

while true; do
  # Get the required ports
  ports=$( ss -ltnp "( sport ge "${start_port}" && sport le "${end_port}" )" )
  # Looking for new ports
  new_port=$( comm -13 <(echo "${all_ports}") <(echo "${ports}") 2> /dev/null )

  if [[ "${ports[@]}" == "State Recv-Q Send-Q Local Address:Port Peer Address:PortProcess" ]]; then
    echo "No TCP listening sockets found bound to ports in ${start_port}-${end_port} range"
  elif ! [[ -z "${new_port}" ]]; then
    unset '$ports[1]'
    # Display ports
    echo "${new_port}" | awk '{print $4,$5,$6,$7}'
  fi

  all_ports="${ports}"
  sleep "${time_out}";
done
