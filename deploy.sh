#!/usr/bin/env bash

names=("client" "server" "worker")

for name in "${names[@]}"; do
    docker build -t wemgl/multi-${name}:latest -t wemgl/multi-${name}:${GIT_COMMIT} -f ./${name}/Dockerfile ./${name}
    docker push wemgl/multi-${name}:latest
    docker push wemgl/multi-${name}:${GIT_COMMIT}
done

kubectl apply -f k8s

for name in "${names[@]}"; do
    kubectl set image deployments/${name}-deployment ${name}=wemgl/multi-${name}:${GIT_COMMIT}
done
