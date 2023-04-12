#!/bin/bash

# The script should output the ports immediately after the shell is restarted,
# without restarting the script.

nohup $0 &

ports=()
all_ports=()

while true; do
  ports=( $(ss --tcp sport ge 10000 and sport le 10100 | awk '{ print $4,$5,$6,$7 }') )
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
    echo "No TCP listening sockets found bound to ports in 10000-10100 range"
  fi

  sleep 5
done
