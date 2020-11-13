#!/bin/bash

find ./src -type d -exec bash -c 'terraform-docs md "{}" > "{}"/README.md;' \;

find ./src -name "README.md" -size -1100c -type f -delete

printf "\n\033[35;1mUpdating the following READMEs with terraform-docs\033[0m\n\n"
  
find ./src -name "README.md"
