/*
 * This file is part of the Software Factory project
 * Copyright (C) Pelagicore AB
 * SPDX-License_identifier: LGPL-2.1
 * This file is subject to the terms of the LGPL-2.1 license.
 * Please see the LICENSE file for details.
 */

pipeline {
    agent {
        node { label 'Sphinx' }
    }

    stages {
        stage('Download') {
            steps {
                // Delete old files
                sh 'rm -rf .[^.] .??* *'

                // Checkout the git repository and refspec pointed to by jenkins
                checkout scm

                // Update the submodule
                sh "git submodule init"
                sh "git submodule update"
            }
        }

        // Configure the software with cmake
        stage('Configure') {
            steps {
                script {
                    String buildParams = "-DENABLE_PDF=OFF "
                    sh "rm -fr build"
                    sh "cmake -H. -Bbuild ${buildParams}"
                }
            }
        }

        stage("Build") {
            steps {
                sh "cd build && make"
            }
        }

        stage('Archive') {
            steps {
                script {
                    // Only store the HTML output in a directory with the same name
                    // as the branch it is on, except we replace slashes with
                    // dashes.
                    String directoryName = env.BRANCH_NAME.replace("/","-")
                    sh "rm -rf ${directoryName}"
                    sh "mv build/docs/html/ ${directoryName}"

                    // Archive
                    archive "${directoryName}/**/*"
                }
            }
        }
    }

}
