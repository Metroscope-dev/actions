#!/bin/sh -l

echo "kubeconfig :"
echo "---------------------------------------------"
echo "$1"
echo "---------------------------------------------"
echo "image :"
echo "---------------------------------------------"
echo "$2"
echo "---------------------------------------------"
echo "deployment :"
echo "---------------------------------------------"
echo "$3"
echo "---------------------------------------------"
echo "container :"
echo "---------------------------------------------"
echo "$4"
echo "---------------------------------------------"


echo "::set-output name=current::{$2##*:}"
