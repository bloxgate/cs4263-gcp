# Random Number Generator for GCP

## Introduction

This document provides instructions on deploying a Random Number Generator into Google Cloud Platform. Upon completion of these instructions, you will have deployed random number generators written in both Java and Python through both Google App Engine and Google Compute Engine

### RNG Technical Details

* Generates a number in the range [1, 1000000]
* Sufficiently random so that at least 750 of any 1000 numbers are unique

### Existing Implementations

There is currently an existing deployment of these services, available at these locations:

#### App Engine

* Java: http://java.ae.se.gmaddra.me
* Python: http://python.ae.se.gmaddra.me

#### Compute Engine

* Java: http://java.se.gmaddra.me
* Python: http://python.se.gmaddra.me

**Note: The original source code was located in GCP source repositories which [cannot be made public,](https://cloud.google.com/source-repositories/docs/configure-access-control#granting_member_access) so we've repuploaded the code into this repository for ease of use.**

### Authors

* Sam Penwell
* Gregory Maddra
* Britt Richardson
* Ross Trujillo



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



## Compute Engine

### Local Requirements

* Access to the Google Cloud Console
* Access to the two `.tar.gz` files included in this repository
* Have created a new Google Cloud project, or use the same project as App Engine

### Installation

1. From the Google Cloud Console's dashboard, navigate to your Compute Engine VM Instances

   * If prompted, go ahead and enable Compute Engine for the project

2. Create a g1-small instance running CentOS 7 with a 10 GB disk
    ![Instance Configuration](https://github.com/bloxgate/cs4263-gcp/blob/image-addition/vm_creation.PNG)

   1. Enable HTTP and HTTPS traffic
   2. Assign a static IP address to your VM
      1. Go to VM details and hit *Edit*
      2. Click on the pencil next to nic0 in network interfaces
      3. Change External IP to Create IP address
         1. Assign a name of your choice and hit reserve
         2. Press done
         3. Hit the save button at the bottom of the page
      ![Static External IP](https://github.com/bloxgate/cs4263-gcp/blob/image-addition/vm_static_ip.PNG)

3. Use the SSH button to connect to your VM

   1. The Cloud Console used here allows for easier file uploads!

4. CentOS 7 comes with Security Enabled Linux (SELinux) by default. We need to modify it's configuration for our services to communicate over the network. Execute the following commands **on the instance**:

   1. `sudo semanage port -m -t http_port_t -p tcp 8080`
   2. `sudo semanage port -m -t http_port_t -p tcp 4567`

5. Install the software requirements for our services, by executing the following commands:

   1. `sudo yum -y update`
   2. `sudo yum -y install python36 python36-setuptools`
   3. `sudo easy_install-3.6 pip`
   4. `sudo yum -y install java-11-openjdk java-11-openjdk-devel`
   5. `sudo yum -y install nginx`
   6. `sudo systemctl enable nginx`
   7. `sudo systemctl start nginx`
   8. `sudo yum -y install nano`

6. We now need to update the nginx configuration, so that it knows how to talk to our services:

   1. `sudo nano /etc/nginx/nginx.conf`

   2. Look for the `server` block that contains the line `listen 80 default_server`

   3. Look for the following entry:

      ```
      location / {
      }
      ```

   4. Replace the above with the following:

      ```
      location / {
      }
      
      location /java {
          proxy_pass http://127.0.0.1:8080/;
      }
      
      location /python {
          proxy_pass http://127.0.0.1:4567/;
      }
      ```
    ![nginx configuration](https://github.com/bloxgate/cs4263-gcp/blob/image-addition/nginx_conf.PNG)

   5. Save and exit

      1. `control-o` to save; `control-x` to exit

   6. Verify your edits by running `sudo nginx -t`

      1. If successful: `sudo systemctl restart nginx`
      2. If there is a configuration error, double check that you updated the correct section

7. Upload our code

   1. `sudo mkdir -p /opt/rng/java`
   2. `sudo mkdir -p /opt/rng/python`
   3. Use the upload files option in the Cloud Shell to upload both `.tar.gz` files
      1. Go to the cog in the top right corner of your VM shell, Upload files is an option in the drop down menu.
   4. `sudo tar xvf random-number-generator.tar.gz -C /opt/rng/python/`
   5. `sudo tar xvf random-number-generator-java.tar.gz -C /opt/rng/java/`
   6. `sudo chown -R root:root /opt/rng`

8. Build the Java Application

   1. `sudo -s`
   2. `cd /opt/rng/java`
   3. `yum install -y dos2unix`
   4. `dos2unix ./gradlew`
   5. `./gradlew shadowJar`
   6. `cp ./build/libs/rng-java-1.0-all.jar ./random-number-generator-java.jar`
   7. `exit`

9. Install Python dependencies

   1. `sudo python3 -m pip install -r /opt/rng/python/requirements.txt`

10. Enable services:

    1. `sudo ln -s /opt/rng/java/rng-java.service /lib/systemd/system/rng-java.service`
    2. `sudo ln -s /opt/rng/python/rng-python.service /lib/systemd/system/rng-python.service`
    3. `sudo systemctl daemon-reload`
    4. `sudo systemctl enable rng-java && sudo systemctl start rng-java`
    5. `sudo systemctl enable rng-python && sudo systemctl start rng-python`

11. Your services will now be accessible

    1. Recall the external IP address you created earlier
    2. The Java Application is available at `http://your.external.ip/java`
    3. The Python Application is available at `http://your.external.ip/python`

### Server-side Testing

* It is possible to test the code that you have deployed on your VM. This is considerably faster than the client-side tests.
  1. On your VM: `sudo -s`
  2. `cd /opt/rng/java/`
  3. `./gradlew test`
  4. `cd /opt/rng/python`
  5. `python3 test_main.py`
  6. `exit`
* Source code for both tests has been provided in this repository
  * Java: `random-number-generator-java/src/test/java/`
  * Python: `random-number-generator/test_main.py`

### Client-side Testing

* You can use the same process used for App Engine testing to perform a client side test! Simply update either the `JAVA_URL` or `PYTHON_URL` in the scripts to point to the address of the VM's service instead!
