#!/bin/bash

AWSBIN=/usr/local/bin/aws

$AWSBIN cloudformation create-stack --template-body file://tpl.yaml --stack-name tp2gbstack