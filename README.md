# dockpupp
- [First install Docker](http://docs.docker.com/linux/step_one/)
- A Docker container running a Puppet master on CentOS 7.
- Created to make testing Puppet modules easier.
- This is a single-server setup, the master is its own node.
- Put (or map) your modules in ./modules, they will be mapped to the container
 when it is run.
- Create yaml files in ./hiera if you need to provide Hiera data to the node.
- The container is disposable, your data is not. **Changes to /var/lib/hiera/*
 or /opt/modules/* in a container WILL APPLY to the ./modules and ./hiera
 directories of the host systems.**
- To build the image run ./Build.sh
- To start a container based on that image run ./Go.sh

