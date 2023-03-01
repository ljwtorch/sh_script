pipeline {
  agent {
    node {
      label 'master'
    }

  }
  stages {
    stage('print') {
      steps {
        echo 'hello'
      }
    }

    stage('shell script') {
      steps {
        sh 'echo "next step"'
      }
    }

  }
}