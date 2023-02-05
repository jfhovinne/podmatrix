command=${args[command]}
source=${args[--source]}
target=${args[--target]}
eval "images=(${args[--image]})"
eval "tags=(${args[--tag]})"
i=0
pids=()

exec() {
  set +e
  if [[ -n ${source} ]] && [[ -n ${target} ]]; then
    >&2 echo "Copying ${source} to ${target}"
    podman cp $source $CT:$target
    >&2 echo "Executing command"
    podman exec $CT bash -c "cd $target && ${command}"
    exitcode=$?
  else
    >&2 echo "Executing command"
    podman exec $CT bash -c "${command}"
    exitcode=$?
  fi
  set -e
  >&2 echo "Stopping ${image}:${tag}"
  podman stop $CT > /dev/null
  >&2 echo "Removing ${image}:${tag}"
  podman rm $CT > /dev/null
  exit $exitcode
}

for image in "${images[@]}"; do
  for tag in "${tags[@]}"; do
    >&2 echo "Launching ${image}:${tag}"
    CT=$(podman run -itd ${image}:${tag} /bin/sh)
    exec "$CT" &
    pids[${i}]=$!
    ((i+=1))
  done
done

for pid in ${pids[*]}; do
  wait $pid
done
