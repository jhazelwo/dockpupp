# dockpupp
- A Docker container running a Puppet master on CentOS 7.
- This is a single-server setup, the master is its own node, and is used to test Puppet modules.
1. ./Build.sh
2. ./Go.sh
- Put (or map) your modules in ./modules, then will be mapped to the container when it is run.
- Create yaml files in ./hiera if you need to provide Hiera data to the node. 

