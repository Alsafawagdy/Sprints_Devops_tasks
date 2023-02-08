@Library('var') _

pipeline {
     agent any
    parameters {
        booleanParam(name:'project', defaultValue: true, description:'this paramater help you to know project name')
        choice(name: 'namespace', choices:['dev','prod','stage'], description: '' ) 
    }

    stages {
        stage('check') {
            steps {
                check(namespace)
            }
        }

        stage('test') {
            when {
                expression{
                    params.project == true 
                }
            }
            steps {
                test()
            }
        }
        
        stage('deployment') {  
            steps {
                deployment()
            }
        }    
    }

}