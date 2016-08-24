#!/bin/bash

watch -n 1 "kubectl get svc -o wide ; kubectl get rc -o wide ; kubectl get pod -o wide ; kubectl get secret -o wide ; kubectl get ing -o wide ; kubectl get node -o wide"
