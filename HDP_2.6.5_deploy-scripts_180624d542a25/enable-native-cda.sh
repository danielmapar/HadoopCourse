#!/usr/bin/env sh
#this script determines what flavor of the sandbox is running and downloads the complementary one required for CDA
set -x

registry="hortonworks"
hdpVersion="2.6.5"
hdfVersion="3.1.1"
hdfSandbox="sandbox-hdf"
hdpSandbox="sandbox-hdp"

# housekeeping

#load the docker image
if docker images | grep sandbox-hdp ; then
 echo "hdp" > sandbox-flavor
elif docker images | grep sandbox-hdf; then
 echo "hdf" > sandbox-flavor
fi
 sed 's/sandbox-hdf-standalone-cda-ready/sandbox-hdf/g' assets/generate-proxy-deploy-script.sh > assets/generate-proxy-deploy-script.sh.new
 mv -f assets/generate-proxy-deploy-script.sh.new assets/generate-proxy-deploy-script.sh
 sed 's/sandbox-hdp-security/sandbox-hdp/g' assets/generate-proxy-deploy-script.sh > assets/generate-proxy-deploy-script.sh.new
 mv -f assets/generate-proxy-deploy-script.sh.new assets/generate-proxy-deploy-script.sh

flavor=$(cat sandbox-flavor)
if [ "$flavor" = "hdf" ]; then
 # we have an hdf sandbox running so we need to download and start the hdp coutnerpart
 version="$hdpVersion"
 name="$hdpSandbox"
 sed 's/hdpEnabled=false/hdpEnabled=true/g' assets/generate-proxy-deploy-script.sh > assets/generate-proxy-deploy-script.sh.new
 mv -f assets/generate-proxy-deploy-script.sh.new assets/generate-proxy-deploy-script.sh
 hostname="sandbox-hdp.hortonworks.com"
elif [ "$flavor" = "hdp" ]; then
 # we have an hdp sandbox running so we need to download and start the hdp coutnerpart
 version="$hdfVersion"
 name="$hdfSandbox"
 sed 's/hdfEnabled=false/hdfEnabled=true/g' assets/generate-proxy-deploy-script.sh > assets/generate-proxy-deploy-script.sh.new
 mv -f assets/generate-proxy-deploy-script.sh.new assets/generate-proxy-deploy-script.sh
 hostname="sandbox-hdf.hortonworks.com"
fi

docker pull "$registry/$name:$version"

containerExists=$(docker ps -a | grep -o $name | head -1)
if [ ! -z  $containerExists ]; then
  if [ "$name" = $containerExists ]; then
    docker start $name
  fi
else
  docker run --privileged --name $name -h $hostname --network=cda --network-alias=$hostname -d $registry/$name:$version
  sleep 2
  echo "Remove existing postgres run files. Please wait ..."
  docker exec -t "$name" sh -c "rm -rf /var/run/postgresql/*; systemctl restart postgresql;"
fi

#Deploy the proxy container.
chmod +x assets/generate-proxy-deploy-script.sh
assets/generate-proxy-deploy-script.sh 2>/dev/null
#check to see if it's windows
if uname | grep MINGW; then
 sed -i -e 's/\( \/[a-z]\)/\U\1:/g' sandbox/proxy/proxy-deploy.sh
fi
chmod +x sandbox/proxy/proxy-deploy.sh 2>/dev/null
sandbox/proxy/proxy-deploy.sh 

#add the hostname to localhost
echo "You need to add  'sandbox-hdp.hortonworks.com' and 'sandbox-hdf.hortonworks.com' into your hosts file"
