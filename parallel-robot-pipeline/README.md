# Parallel Robot Framework pipeline

This directory provides an example of a Jenkins pipeline that executes Robot Framework automation tasks with docker agent in parallel stages as well as combines and stores the produced HTML/XML report files.

## Preparing the Jenkins instance

The pipeline provided by this example can be added to any Jenkins instance you have administrator access and can run pipeline stages with docker agent. For example, Jenkins configuration from [Docker-in-Docker](../dind-jenkins/) example can be used.

In order to be able to run the pipeline we will need [Docker Pipeline](https://plugins.jenkins.io/docker-workflow/) and [Robot Framework](https://plugins.jenkins.io/robot/) plugins. Install these plugins through _Available_ tab in [Manage Jenkins > Manage Plugins](http://localhost:8080/pluginManager/available) and restart the Jenkins instance after these plugins have been installed. The restart can be done, for example, from the plugins page or by restarting the container with `docker compose down` and `docker compose up`.

## Configure the pipeline

First, create a new pipeline via [New Item](http://localhost:8080/view/all/newJob) button in the rigth side menu of the Jenkins dashboard. The name of the pipeline could be for example `Screenshots` and it should be an pipeline.

In the configure pipeline view, scroll to the bottom and under Pipeline sub-header select `Pipeline script from SCM`. SCM type should be `Git` and Repository URL the url of this repository: `https://github.com/kangasta/jenkins-examples.git`. Ensure that branch specifier includes `main` branch of the repository and modify the Script Path to be `parallel-robot-pipeline/Jenkinsfile`.

After you have created the pipeline, try to execute it by clicking Build Now. All Robot Framework tasks should be in Skipped state as we did not specify URL variable, see `.robot` file for details. In addition, after the first execution Jenkins should have updated the project configuration to contain parameters defined in the pipeline and we can now pass target URL to our automation tasks in Build with Parameters menu.

Finally, If the robot log cannot be loaded after task execution, see [this stackoverflow post](https://stackoverflow.com/questions/36607394/error-opening-robot-framework-log-failed) for solution. To summarize, run following command in Jenkins Script Console to modify Jenkins servers Content Security Policy (CSP):

```groovy
System.setProperty("hudson.model.DirectoryBrowserSupport.CSP","sandbox allow-scripts; default-src 'none'; img-src 'self' data: ; style-src 'self' 'unsafe-inline' data: ; script-src 'self' 'unsafe-inline' 'unsafe-eval' ;")
```

## Running the example scripts locally

Build the Docker containers with `docker build`:

```sh
# Chromium
docker build . -f chromium.Dockerfile --tag rf-screenshot-gc

# Firefox
docker build . -f firefox.Dockerfile --tag rf-screenshot-ff
```

Execute the Robot Framework suites with `docker run`:

```sh
# Chromium
docker run --rm -v $(pwd)/out:/out rf-screenshot-gc -d /out -v URL:https://github.com/kangasta/jenkins-examples

# Firefox
docker run --rm -v $(pwd)/out:/out rf-screenshot-ff -d /out -v URL:https://github.com/kangasta/jenkins-examples
```
