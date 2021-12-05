# Jenkins examples

This repository contains examples for settings up Jenkins in container.

Note that by default each of the example docker-compose configurations will create their own volumes for the data. This might not be what you want. In order to use the same volumes for every docker-compose configuration, run docker-compose with `-p` (or `--project`) option. This can also be done by setting `COMPOSE_PROJECT_NAME` environment variable:

```bash
export COMPOSE_PROJECT_NAME=jenkins
```

## Jenkins image with Docker-in-Docker support

In order to run Jenkins container with Docker-in-Docker support, `cd` into [dind-jenkins](./dind-jenkins/) directory and run `docker-compose up`. See Dockerfile and docker-compose.yml for the configuration details.

```bash
cd dind-jenkins/

# If you want to see logs in the current terminal
docker-compose up --build

# Or if you want to run the container in the background
docker-compose up --build --detach
```

The initial amdmin password can be easily printed with `docker-compose exec`:

```bash
docker-compose exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

In order to get started the suggested plugins are often good a starting point. If you are planning to create pipeline projects with stages running in on-demand Docker containers, you will also need [Docker Pipeline](https://plugins.jenkins.io/docker-workflow/) plugin. This can be installed through the [Manage Jenkins > Manage plugins](http://localhost:8080/pluginManager/available) menu.

## Other examples

For other examples, detailed descriptions are available in the directory specific README files:

- [Build status pipelines and Job DSL](./build-status-pipelines)
- [Jenkins and SonarQube](./sonarqube-jenkins)
- [Parallel Robot Framework pipeline](./parallel-robot-pipeline)
