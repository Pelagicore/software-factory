#!/usr/bin/groovy

/*
 * This file is part of the Software Factory project
 * Copyright (C) Pelagicore AB
 * SPDX-License_identifier: LGPL-2.1
 * This file is subject to the terms of the LGPL-2.1 license.
 * Please see the LICENSE file for details.
 */


node {
    try {

        // Stages are subtasks that will be shown as subsections of the finiished build in Jenkins.
        stage('Download') {
            // Delete old files
            sh 'rm -rf .[^.] .??* *'
            // Checkout the git repository and refspec pointed to by jenkins
            checkout scm
        }

        // Configure the software with cmake
        stage('Configure') {
            String buildParams = "-DENABLE_PDF=OFF "
            sh "rm -fr build"
            sh "cmake -H. -Bbuild ${buildParams}"
        }

        stage("Build") {
            sh "cd build && make"
        }

        stage('Archive') {
            // Store the artifacts of the entire build
            archive "**/*"

        }
    }

    catch(err) {
        // Do not add a stage here.
        // When "stage" commands are run in a different order than the previous run
        // the history is hidden since the rendering plugin assumes that the system has changed and
        // that the old runs are irrelevant. As such adding a stage at this point will trigger a
        // "change of the system" each time a run fails.
        println "Something went wrong!"
        currentBuild.result = "FAILURE"
    }
}

