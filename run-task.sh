#!/bin/sh

aws ecs run-task --cluster continuous-publication-delivery --launch-type FARGATE --task-definition continuous-publication-delivery --network-configuration awsvpcConfiguration={subnets=["subnet-0bf8b4d9b8d0fcad2","subnet-0eedd8f0b8f3e74ff"],securityGroups=["sg-0f9c779e63bb7b28b"],assignPublicIp="DISABLED"} --profile administrator --region eu-central-1