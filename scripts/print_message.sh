#!/bin/bash

# Run this command to make the script executable for workflow:
# git update-index --chmod=+x scripts/print_message.sh 

echo "Deploying to ${{ github.event.inputs.environment }} environment"
echo "The workflow is completed."