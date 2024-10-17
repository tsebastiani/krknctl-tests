set -xo pipefail

source CI/tests/common.sh

command="docker"
#command=$(command_to_run)
#echo "final $command"
#if [ "$command" == "" ]
#then
#  echo "please install podman or docker before continuing"
#  exit 1
#fi
function functional_test_node_cpu {
  export WAIT_DURATION=5
  export TOTAL_CHAOS_DURATION=10

  container_name="node_cpu_test"
  get_node_name
  $command-compose build node-cpu-hog
  . ./get_docker_params.sh

  image_id=$($command images --all --format "{{.ID}}" | head -n 1)
  $command run --name=$container_name --net=host $PARAMS -v /root/.kube/config:/root/.kube/config:Z -d $image_id
  $command logs -f $container_name
  final_exit_code=$(get_exit_code $command $container_name)
  echo "exit code final: $final_exit_code"
  $command rm -f $container_name
  $command rmi -f $image_id
  exit $final_exit_code
}

functional_test_node_cpu