# The Ultimate Hands-On Hadoop - Tame your Big Data!

* Install Horton works stack (that contains Hadoop and other tools)
    * `cd HDP_3.0.1_docker-deploy-scripts_18120587fc7fb/`
    * `sh docker-deploy-hdp30.sh`
        * In case you experience a port issue like: 
            * `C:\Program Files\Docker\Docker\Resources\bin\docker.exe: Error response from daemon: driver failed programming external connectivity on endpoint sandbox-proxy (2e13894570ec36a982eb51009448c128854214a8286088e01da9f7881b6dd100): Error starting userland proxy: Bind for 0.0.0.0:50070: unexpected error Permission denied.`
            * You can fix it by setting different ports inside the `sandbox/proxy/proxy-deploy.sh` file, this is dynamically generated when we run `sh docker-deploy-hdp30.sh`  
                * Edit file `sandbox/proxy/proxy-deploy.sh`
                * Modify conflicting port (first in keypair). For example, `6001:6001` to `16001:6001`
                * Save/Exit the File
                * Run bash script: bash `sandbox/proxy/proxy-deploy.sh`
                * Repeat steps for continued port conflicts
    * Verify sandbox was deployed successfully by issuing the command: `docker ps`
        * You should see two containers, one for the `nginx` proxy and another one for the actual tools
            * ![setup](images/setup-hortonworks.PNG)
        
           

