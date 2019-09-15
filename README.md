# Random Number Generator for GCP

## App Engine

### Requirements

* Java Development Kit
* Python 3.6 or greater
* Google Cloud SDK
* Bash (for executing test scripts)

### Installation

1. In Google Cloud Console, create a new project
   * https://cloud.google.com/resource-manager/docs/creating-managing-projects
2. Install Google Cloud SDK if you haven't already
   * https://cloud.google.com/sdk/install
3. If you have already set a project for Google Cloud SDK, change to your new project
   * https://stackoverflow.com/a/42448976
4. This repository contains two folders `random-number-generator` and `random-number-generator-java`, both of which contain app.yaml deployment files for Google App Engine. 
   * Ensure App Engine is enabled for your project
     * `gcloud services enable appengineflex.googleapis.com`
5. Compile Java application
   1. Navigate into `random-number-generator-java`
   2. On Windows: 
      1. `.\gradlew shadowJar`
      2. `copy .\build\libs\rng-java-1.0-all.jar .\random-number-generator-java.jar`
   3. On Linux:
      1. `./gradlew shadowJar`
      2. `cp ./build/libs/rng-java-1.0-all.jar ./random-number-generator-java.jar`
6. Navigate to the root folder of this repository
7. Deploy the services
   1. `gcloud app deploy ./random-number-generator/app.yaml ./random-number-generator-java/app.yaml`
   2. This will take a long time
8. Once your apps are deployed, you may find their URLs in your App Engine services list
   1. By default they will be of the form:
      1. Python: `http://your-project-id.appspot.com`
      2. Java: `http://java-dot-your-project-id.appspot.com`

### Testing

* The clientside-tests folders in both `random-number-generator` and `random-number-generator-java` contain a `test-python.sh` and a `test-java.sh` script respectively.
  * You will need to modify either the PYTHON_URL or JAVA_URL in the script to match your app engine URLs
  * You can run the script on any system with access to `bash`, `curl`, `sort`, `uniq`, and `wc`. Most Linux systems should suffice
  * You will be given output about connection speed and transfer sizes for several minutes. At the end of execution, the output of all 10 tests will be printed. The final output represents the number of unique entries seen in each test. Each number should be >= 750
  * Raw test data will be stored in `language-output-#.txt`
* You can test the code itself through the included unit tests:
  * Java: `./gradlew test`
  * Python: `python3 test_main.py`



