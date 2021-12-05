pipeline {
    agent any
    options {
        timeout(time: 3, unit: 'MINUTES')
    }
    stages {
        stage('Sleep') {
            steps {
                sleep time: 5, unit: 'MINUTES'
            }
        }
    }
}
