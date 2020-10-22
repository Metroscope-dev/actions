#!/usr/bin/env bash

cat <&0 > all.yaml
kustomize build . && rm all.yaml
