#!/bin/bash
echo "TaskIDs: 68ae2944b4304368836abed22bbb6331,f6752ffd7321491bb27317617860285e"
echo "ClusterName: vedant-ecs-test"
task="68ae2944b4304368836abed22bbb6331,f6752ffd7321491bb27317617860285e"
ClusterName="vedant-ecs-test"

IFS=',' read -r -a taskArray <<< "$task"
pidArr=()

if [ ! -d /var/lib/ecs/data/metadata ]; then
  echo "The container metadata is not present please check the experiment prerequisite"
  exit 1
fi

for index in "${!taskArray[@]}"
do
  if [ -d /var/lib/ecs/data/metadata/${ClusterName}/${taskArray[index]} ]; then
    for targetContainer in /var/lib/ecs/data/metadata/${ClusterName}/${taskArray[index]}/*/    
    do  
        targetContainer=${targetContainer%*/}
        echo "[Info]: Targeting Container: ${targetContainer##*/}"
        echo "[Info]: Feching container id ..."
        CONTAINER_ID=$(jq  -r '.ContainerID' /var/lib/ecs/data/metadata/${ClusterName}/${taskArray[index]}/${targetContainer##*/}/ecs-container-metadata.json)
        echo "[Info]: Feching pid ..."
        PID=$(docker inspect $CONTAINER_ID | jq '.[].State.Pid')
        echo "[Info]: CONTAINER_ID: $CONTAINER_ID, PID: $PID"
        pidArr+=("$PID")

        chaos_command="nsenter -t ${PID} -p stress-ng --vm 1 --vm-bytes 100M -t 100s -v"

        cgroup_path="/sys/fs/cgroup/memory/ecs/${taskArray[index]}/${CONTAINER_ID}"

        echo "Starting chaos injection with : ${chaos_command}"

        # Runnig stress command as paused command
        ( kill -SIGSTOP $BASHPID; exec ${chaos_command} ) &

        # Getting process_id of the paused stress command
        chaos_process_pid=$(echo $!)

        # Adding process_id to cgroup for metrics tracking
        echo ${chaos_process_pid} > ${cgroup_path}/tasks

        # sending SIGCONT signal to paused stress process for resuming the same
        kill -SIGCONT ${chaos_process_pid}
    done
  fi
done

echo "[Cleanup]: Finishing chaos injection"
