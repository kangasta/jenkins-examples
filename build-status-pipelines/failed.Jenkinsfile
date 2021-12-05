pipeline {
    agent any
    stages {
        stage('Fail on purpose') {
            steps {
                sh 'exit 1'
            }
        }
    }
}
