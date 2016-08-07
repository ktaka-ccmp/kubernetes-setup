#!/bin/bash

watch -n 1 "kubectl get svc -o wide ; kubectl get pod -o wide ;kubectl get node"
