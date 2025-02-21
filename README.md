JaCoCo Java Code Coverage Library
=================================

[![Build Status](https://dev.azure.com/jacoco-org/JaCoCo/_apis/build/status/JaCoCo?branchName=master)](https://dev.azure.com/jacoco-org/JaCoCo/_build/latest?definitionId=1&branchName=master)
[![Build status](https://ci.appveyor.com/api/projects/status/g28egytv4tb898d7/branch/master?svg=true)](https://ci.appveyor.com/project/JaCoCo/jacoco/branch/master)
[![Maven Central](https://img.shields.io/maven-central/v/za.co.absa.jacoco/jacoco.svg)](http://search.maven.org/#search|ga|1|za.co.absa.jacoco)

JaCoCo is a free Java code coverage library distributed under the Eclipse Public
License. Check the [project homepage](http://www.jacoco.org/jacoco)
for downloads, documentation and feedback.

Please use our [mailing list](https://groups.google.com/forum/?fromgroups=#!forum/jacoco)
for questions regarding JaCoCo which are not already covered by the
[extensive documentation](http://www.jacoco.org/jacoco/trunk/doc/).

Note: We do not answer general questions in the project's issue tracker. Please use our [mailing list](https://groups.google.com/forum/?fromgroups=#!forum/jacoco) for this.
-------------------------------------------------------------------------

# Fork differences
## Features
### Method filtration for `*.scala` files
On the fly logic for removing methods. All methods which are not part of their source file are removed from JaCoCo bundle.
#### Motivation
JaCoCo report contains big amount of inherited methods which is not needed/expected to cover by tests.
#### Inputs:
- `jacoco.exec` file (as JaCoCo bundle data source)
- built class files (as JaCoCo bundle data source)
- source class files (as source of truth for method filtration)

#### Outputs:
- reduced JaCoCo bundle as a source for report generation

#### Configuration
```
<execution>
    <id>jacoco-report</id>
    <goals>
        <goal>report</goal>
    </goals>
    <configuration>
        <title>${project.name} - ${scala.version}</title>
        <doMethodFiltration>true</doMethodFiltration>
        <doScalaMethodFiltration>true</doScalaMethodFiltration>
        <doManualScalaMethodFiltration>true</doManualScalaMethodFiltration>
        <srcRootDir>src/main/scala</srcRootDir>
        <methodExcludes>
            <exclude>com/package/patk/Classname@methodName</exclude>
        </methodExcludes>
    </configuration>
</execution>
```

#### Classes
- `org.jacoco.core.analysis.CoverageBundleMethodFilterConst.java`
- `org.jacoco.core.analysis.CoverageBundleMethodFilterScalaImpl.java`
- `org.jacoco.core.analysis.ClassCondensate.java`
- `org.jacoco.core.analysis.CoverageBundleMethodFilterScalaImplTest.java`

#### Possible log output messages
- `KEPT_by_SKIP_CLASS_NAME`
- `KEPT_by_SKIP_METHOD_NAME`
- `KEPT_by_EXISTING`
- `KEPT_by_EXCEPTION`
- `REMOVED_by_SKIP_CLASS_NAME_INIT_METHOD`
- `REMOVED - not found in class file.`
- `REMOVED - not found in classCondensate.`
- `REMOVED_BY_MANUAL_EXCLUDE - manually defined to remove from report`

#### Tips
Implemented filtration logic does not contain all possible scala code combinations. All class elements are removed if they are not found in source files. This can lead to unexpected removes of logic.
Suggestion for usage:
- Generate two JaCoCo reports: switched on/off method filtration.
- Do comparison of results.
- **If you identify missing method after filtration collect inputs and provide them to us to improved logic.**

## Known issues
- When used on project with Github Action madrapps/jacoco-report@v1.3 then overall % can be different. Detected 5% difference.


## How to use locally
Until Scala method filtering solution will be available in official library. You can use this workaround.

### How to get library with filtering logic
- Checkout this repository.
- Call `mvn install` in repository root dir.
- New snapshots should be available on path `$HOME/.m2/repository/za/co/absa/jacoco/*`

### How to use library in maven project
- Optional: add new version property in your `pom.xml` file
```
    <jacoco.version>0.8.10</jacoco.version>
```
- add new `profile` section in your `pom.xml` file
```
<profile>
    <id>code-coverage</id>
    <properties>
        <scalatest.argLine>${default.scalatest.argLine} ${argLine}</scalatest.argLine>
        <skip.integration.tests>false</skip.integration.tests>
        <skip.unit.tests>false</skip.unit.tests>
    </properties>
    <build>
        <plugins>
            <plugin>
                <groupId>za.co.absa.jacoco</groupId>
                <artifactId>jacoco-maven-plugin</artifactId>
                <version>${jacoco.version}</version>
                <executions>
                    <execution>
                        <id>jacoco-prepare-agent</id>
                        <goals>
                            <goal>prepare-agent</goal>
                        </goals>
                    </execution>
                    <execution>
                        <id>jacoco-report</id>
                        <goals>
                            <goal>report</goal>
                        </goals>
                        <configuration>
                            <title>${project.name} - ${scala.version}</title>
                            <doMethodFiltration>true</doMethodFiltration>
                            <doScalaMethodFiltration>true</doScalaMethodFiltration>
                            <doManualScalaMethodFiltration>true</doManualScalaMethodFiltration>
                            <methodExcludes>
                                <exclude>com/path/ClassName@methodName</exclude>
                            </methodExcludes>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</profile>
```
- to activate JaCoCo report generation call `mvn clean verify -Pcode-coverage`

### How to use library in sbt project
- For JaCoCo with sbt continue with steps in project [AbsaOSS/sbt-jacoco](https://github.com/AbsaOSS/sbt-jacoco)