#!/bin/bash

func() {
	if [ -f $1 ] 
	then cat  $1
	else touch $1; chmod 700 $1; openssl rand -base64 8 > $1
	fi
}

func $1
func $2
