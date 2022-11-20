/**
 * Pipeline for deploying main behaviosense backend resources to AWS
 **/

TF_IMG = "terraform:latest"

CONFIG = [
    prod: [
        'aws_region': 'ap-south-1',
        'credentials': 'external-jenkins-access'
    ]
]


pipeline {
    parameters {
        choice(
            name: 'ENV',
            choices: ['dummy', 'dev', 'sit', 'prod'],
            description: 'Select Target Environment'
        )
    } // parameters

    options {
        buildDiscarder(logRotator(numToKeepStr: '20'))
    } // options

    agent {
        label 'docker-builder'
    } // agent

    stages {
        stage('Setup Environment') {
            steps {
                script {
                    ENV = params.ENV
                    if (ENV == null || ENV == 'dummy') {
                        currentBuild.result = 'ABORTED'
                        error("Invalid or missing Environment: ${ENV}")
                    }
                    echo "Deploying to ${ENV}"
                    ENV_CONF = CONFIG[ENV]
                    AWS_REGION = ENV_CONF['aws_region']
                    CREDENTIALS = ENV_CONF['credentials']
                    BUCKET_NAME = "$ENV-tyropower-infra-$AWS_REGION"
                    SCRIPT_BUCKET_NAME = "$ENV-tyropower-data-$AWS_REGION"
                } // script
            } // steps
        } // stage
        stage('Pre Deploy') {
            steps {
                script{
                    docker.image("${TF_IMG}").inside {
                        echo 'creating key pair'
                        withAWS(region: AWS_REGION, credentials: CREDENTIALS) {
                            dir("infra-setup/deploy-scripts") {
                                sh "python add-key-pairs.py $BUCKET_NAME $AWS_REGION"
                                sh "python s3-bucket.py $SCRIPT_BUCKET_NAME $AWS_REGION"
                            }
                        }
                    }
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                script{
                    docker.image("${TF_IMG}").inside {
                        withAWS(region: AWS_REGION, credentials: CREDENTIALS) {
                            dir("${ENV}") {
                                sh "terraform init"
                                PLANSTATUS = sh(returnStatus: true, script: "terraform plan -detailed-exitcode -lock=true -out jenkins-backend.tfplan")
                                if (PLANSTATUS == 1) {
                                    currentBuild.result = 'ABORTED'
                                    error("Terraform Plan failed, check output.")
                                }
                            } // dir
                        } // withAWS
                    }
                } // script
            } // steps
        } // stage

        stage('Approve Plan') {
            when { expression { (PLANSTATUS == 2) }}
            steps {
                script {
                    USERINPUT = input(id: 'ConfirmPlan',
                        message: 'Apply Terraform Plan?',
                        parameters: [ [
                            $class: 'BooleanParameterDefinition',
                            defaultValue: false,
                            description: 'Apply Terraform Plan',
                            name: 'confirm'
                        ] ]
                    )
                } // script
            } // steps
        } // stage

        stage('Terraform Apply') {
            when {
                allOf {
                    expression { (PLANSTATUS == 2) }
                    expression { (USERINPUT == true) }
                }
            }
            steps {
                script {
                    docker.image("${TF_IMG}").inside {
                        withAWS(region: AWS_REGION, credentials: CREDENTIALS) {
                            dir("${ENV}") {
                                sh "terraform apply -lock=true -input=false jenkins-backend.tfplan"
                            }
                        } // withAWS
                    }
                }

            } // steps
        } // stage
    } // stages

    post {
        always {
            node('docker-builder') {
                cleanWs()
            }
        } // always
    } // post
} // pipeline