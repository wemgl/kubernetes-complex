#!/usr/bin/env bash

names=("client" "server" "worker")

for name in "${names[@]}"; do
    echo "build ${name} image for commit ${GIT_COMMIT}"
    docker build -t wemgl/multi-${name}:latest -t wemgl/multi-${name}:${GIT_COMMIT} -f ./${name}/Dockerfile ./${name}
    echo "push ${name} image for commit ${GIT_COMMIT}"
    docker push wemgl/multi-${name}:latest
    docker push wemgl/multi-${name}:${GIT_COMMIT}
done

echo "apply kubernetes configuration files"
kubectl apply -f k8s

for name in "${names[@]}"; do
    echo "set ${name} image for commit ${GIT_COMMIT}"
    kubectl set image deployments/${name}-deployment ${name}=wemgl/multi-${name}:${GIT_COMMIT}
done
