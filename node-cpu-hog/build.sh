export INPUT=$(cat krknctl-input.json | tr -d "\n")

envsubst < Dockerfile.template > Dockerfile
