command=${args[command]}
source=${args[--source]}
target=${args[--target]}
eval "images=(${args[--image]})"
exitcode=0

for image in "${images[@]}"; do
  >&2 echo "Launching ${image}"
  CT=$(podman run -itd ${image} /bin/sh)
  set +e
  if [[ -n ${source} ]] && [[ -n ${target} ]]; then
    >&2 echo "Copying ${source} to ${target}"
    podman cp $source $CT:$target
    >&2 echo "Executing command"
    podman exec $CT bash -c "cd $target && ${command}"
    ((exitcode+=$?))
  else
    >&2 echo "Executing command"
    podman exec $CT bash -c "${command}"
    ((exitcode+=$?))
  fi
  set -e
  >&2 echo "Stopping ${image}"
  podman stop $CT > /dev/null
  >&2 echo "Removing ${image}"
  podman rm $CT > /dev/null
done

exit $exitcode
