#!/bin/bash

temp=$(sensors | grep -m 1 'edge:' | awk '{print $2}')
echo "GPU $temp"

