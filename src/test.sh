#!/bin/bash

He_Name_Size=${#He_Name}

if [[ $He_Name -eq ""] || [ $He_Name_Size -lt 6 ]]
then
	echo "Please set He_Name first and make sure it is at least 5 characters in length with no special characters.  Visit https://github.com/RetailDevCrews/helium to get started"
else
	cat ../example.tfvars | sed "s/<<He_Name>>/$He_Name/g" > terraform.tfvars
fi



