# Docker Teamcity Minimal Agent Android Build Box 

[![docker icon](https://dockeri.co/image/frankyjquintero/teamcity-agent-android-build-box)](https://hub.docker.com/r/frankyjquintero/teamcity-agent-android-build-box/)


## Introduction

A **docker** image build with teamcity-minimal-agent + **Android** build environment.


## What Is Inside

It includes the following components:

* Ubuntu 18.04
* Android SDK 28
* Android build tools:
  * 28.0.3
* Android NDK r20
* extra-android-m2repository
* extra-google-m2repository
* extra-google-google\_play\_services


## Docker Pull

The docker image is publicly automated build on [Docker Hub](https://hub.docker.com/r/frankyjquintero/teamcity-agent-android-build-box/) based on the Dockerfile in this repo, so there is no hidden stuff in it. To pull the latest docker image:

    docker pull frankyjquintero/teamcity-agent-android-build-box:latest

## Usage

### Use the image to build an Android project

You can use this docker image to build your Android project with a single docker command:

    cd <android project directory>  # change working directory to your project root directory.
    docker run --rm -v `pwd`:/project frankyjquintero/teamcity-agent-android-build-box bash -c 'cd /project; ./gradlew build'

Run docker image with interactive bash shell:

    docker run -v `pwd`:/project -it frankyjquintero/teamcity-agent-android-build-box


## Docker Build Image

If you want to build the docker image by yourself, you can use following command.

    docker build -t frankyjquintero/teamcity-agent-android-build-box .



## Contribution

If you want to enhance this docker image or fix something, feel free to send [pull request](https://github.com/frankyjquintero/teamcity-agent-android-build-box/pull/new/master).


## References

* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
* [Best practices for writing Dockerfiles](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/)
* [Build your own image](https://docs.docker.com/engine/getstarted/step_four/)
* [uber android build environment](https://hub.docker.com/r/uber/android-build-environment/)
* [Refactoring a Dockerfile for image size](https://blog.replicated.com/refactoring-a-dockerfile-for-image-size/)

