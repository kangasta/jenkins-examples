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

## Jenkins and SonarQube

This example uses the same Jenkins configuration as the [Docker-in-Docker](./dind-jenkins/) example. If you did any configuration in [dind-jenkins](./dind-jenkins/) directory, sync the project names with `-p`/`--project` option or `COMPOSE_PROJECT_NAME` environment variable to use the same volumes.

### Gettings started with SonarQube

To get started with SonarQube, access the [Web UI](http://localhost:9000) and login with `admin:admin` credentials. Create a access token in [My account > Security](http://localhost:9000/account/security/) and store the token. Use this access token to authenticate to SonarQube from CI instead of the username and password combination.

In order to test the SonarQube installation, run `sonar-scanner` in a code repository. This can be done, for example, by using the [sonarsource/sonar-scanner-cli](https://hub.docker.com/r/sonarsource/sonar-scanner-cli) Docker image:

```bash
# This command should be run in the repository root directory
docker run \
  --rm \
  --net host \
  -e SONAR_HOST_URL="http://localhost:9000" \
  -v ${PWD}:/usr/src \
  sonarsource/sonar-scanner-cli \
  -D"sonar.projectKey=$(basename ${PWD})" \
  -D"sonar.login=${your_sonar_access_token}"
```

If this succeeds, you are ready to move this analysis into Jenkins.

### Using SonarQube from Jenkins pipeline

First, install SonarQube Scanner plugin to your Jenkins instance through [Manage Jenkins > Manage plugins](http://localhost:8080/pluginManager/available) menu. Configure SonarQube instance to SonarQube servers section of the [Manage Jenkins > Configure System](http://localhost:8080/configure) menu: Use `http://sonarqube:9000` as the server URL and create a secret text credential for the access token you stored earlier.

After the SonarQube server is configured to Jenkins, sonar-scanner can be executed in a stage that uses the same [sonarsource/sonar-scanner-cli](https://hub.docker.com/r/sonarsource/sonar-scanner-cli) Docker image that was used in previous step as well. This can be done with a stage level Docker agent:

```Groovy
stage('Analyze') {
  agent {
    docker {
      image 'sonarsource/sonar-scanner-cli'
      // In order to be able to use http://sonarqube:9000 we need to be in the
      // same network as Jenkins and SonarQube are in.
      args '--net jenkins_default'
      // To quarantee that the workspace contains the sources pulled in previous
      // stage, we need to use the pipeline level workspace.
      reuseNode true
    }
  }
  steps {
    // The parameter must match the name you gave for the SonarQube server when
    // configuring it.
    withSonarQubeEnv('Sonar') {
      // Here, job name is used as the project key and current workspace as the
      // sources location.
      sh """
        sonar-scanner \
          -D'sonar.projectKey=${JOB_NAME}'\
          -D'sonar.sources=${WORKSPACE}'
      """
    }
  }
}
```

See [Jenkinsfile](./sonarqube-jenkins/Jenkinsfile) for a example of a complete pipeline. If you try to execute this example pipeline replace `${GIT_URL}` with the URL to your git repository of choice.

After the pipeline with sonar-scanner run has be executed, the job view in Jenkins should include the SonarQube quality gate status of the linked Sonar Project. Note that in this demo setup these links will not work as the Jenkins uses the `http://sonarqube:9000` URL for the SonarQube server which is likely not accessible from your browser. To see the projects in SonarQube, replace `http://sonarqube:9000` with `http://localhost:9000` in the URL.

Alternative for using `http://sonarqube:9000` or `http://localhost:9000` as the SonarQube URL would be to use your host machines local IP: `http://${HOST_IP}:9000`. On linux systems, you can find your local IP with `hostname -I` command. On Windows systems, you can find your local by looking for IP address from the output of `ipconfig` command. You only need to configure this to the [Manage Jenkins > Configure System](http://localhost:8080/configure) menu. When using local host IP, you can omit the network argument from docker agent block and the links from the job view should work as is.

Note that this setup should only be used for development. For anything production like, configure SonarQube to use database such as postgres, do not use root or admin credentials, and setup the Jenkins and SonarQube to a suitable private network. See also Jenkins and SonarQube documentation for production usage instructions.
