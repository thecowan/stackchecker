#!/bin/bash
cd /stacks
echo "# TYPE docker_stack_checker_last_run_timestamp_seconds gauge"
# echo "# UNIT docker_stack_checker_last_run_timestamp_seconds seconds"
echo "# HELP docker_stack_checker_last_run_timestamp_seconds time the stack checker was last run"
echo "docker_stack_checker_last_run_timestamp_seconds $(date +%s)"
echo

echo "# TYPE docker_stack_checker_stack_running gauge"
echo "# HELP docker_stack_checker_stack_running gauge State of each stack found in the source directory vs its actual running state"
declare -A states
for file in *.yaml; do 
	stack="${file%.*}"
	states["$stack"]=0
done

while read -r stackname; do
	states["$stackname"]=1
done <<< $(docker stack ls --format "{{.Name}}")

for stackname in "${!states[@]}"; do
        echo "docker_stack_checker_stack_running{stack=\"$stackname\"} ${states[$stackname]}"
done
echo

running_out=""
desired_out=""
newline=$'\n'
while read -r servicename replicas; do
	IFS='/' read -r running desired <<< "$replicas"
	IFS='_' read -r stack service <<< "$servicename"
	running_out+="docker_stack_checker_service_running{stack=\"$stack\",service=\"$service\"} $running"
	running_out+="${newline}"
	desired_out+="docker_stack_checker_service_desired{stack=\"$stack\",service=\"$service\"} $desired"
	desired_out+="${newline}"
done <<< $(docker service ls --format "{{.Name}} {{.Replicas}}")

echo "# TYPE docker_stack_checker_service_running gauge"
echo "# HELP docker_stack_checker_service_running Number of currently running replicas for each service"
echo "$running_out"
echo

echo "# TYPE docker_stack_checker_service_desired gauge"
echo "# HELP docker_stack_checker_service_running Number of desired replicas for each service"
echo "$desired_out"
