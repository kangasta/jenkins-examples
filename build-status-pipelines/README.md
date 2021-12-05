# Build status pipelines and Job DSL

This example contains pipelines to produce builds with success, unstable, failed, aborted, and not-built statuses as well as Job DSL script to create a folder with projects that have these five different statuses.

## Preparing the Jenkins instance

The pipeline provided by this example can be added to any Jenkins instance you have administrator access. For example, Jenkins configuration from [Docker-in-Docker](../dind-jenkins/) example can be used.

In order to be able to run the seed project we will need [Job DSL](https://plugins.jenkins.io/job-dsl/) plugin. Install the plugin through Available tab in [Manage Jenkins > Manage Plugins](http://localhost:8080/pluginManager/available).

## Creating and running the seed project

To run the job DSL script, create a new pipeline with following script as an inline pipeline script and run the created pipeline.

```groovy
node {
    git branch: 'main', url: 'https://github.com/kangasta/jenkins-examples.git'
    jobDsl targets: 'build-status-pipelines/jobs.groovy'
}
```

The execution will likely fail with `ERROR: script not yet approved for use` message. To enable this script, navigate to [Manage Jenkins > In-process Script Approval](http://localhost:8080/scriptApproval/), inspect the script, and click Approve. Then try to run the created seed project again. It should now succeed and list the created resources.
