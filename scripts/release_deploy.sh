#!/bin/sh
cd /Users/ab024ll/repos/absa/develop/jacoco/scripts/
rm -rf jacoco_release
git clone https://github.com/AbsaOSS/jacoco.git jacoco_release
cd jacoco_release
git checkout master
mvn deploy -Ppublic -Psonatype-oss-release -PgenerateComponentPreload -DskipTests