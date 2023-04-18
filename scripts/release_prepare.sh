#!/bin/sh
cd cd /Users/ab024ll/repos/absa/develop/jacoco/scripts/
rm -rf jacoco_release
git clone https://github.com/AbsaOSS/jacoco.git jacoco_release
cd jacoco_release
#mvn gitflow:release -B
mvn gitflow:release