#!/bin/bash

# When you launch the script it should initially list all tcp connections in the port
# range 10000-10100. New found connections should be displayed in the console as soon
# as they're identified.

START_PORT=10000
END_PORT=10100
TIME_OUT=5

ports=()
all_ports=()

while true; do
  ports=( $(ss -t sport ge "${START_PORT}" and sport le "${END_PORT}" \
    | awk '{ print $4,$5,$6}') )
  count_ports="${#ports[@]}"

  k=4
  while [[ "${k}" -le "${count_ports}" ]]; do
    port="${ports[$k]}"
    if ! [[ "${all_ports[@]}" =~ "${port}" ]]; then
      echo "${ports[$k]}" "${ports[$k+1]}"
      all_ports+=("${port}")
    fi
    k="${k}"+2
    done

  if [[ "${#all_ports[@]}" -eq 0 ]]; then
    echo "No TCP listening sockets found bound to ports in ${START_PORT}-${END_PORT} range"
  fi

  sleep "${TIME_OUT}"
done
