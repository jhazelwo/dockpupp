dockpupp
========
## PuppetDB and master running in a CentOS 7 Docker container.
- First [Install Docker](http://docs.docker.com/linux/step_one/)
- Created to make testing Puppet modules easier.
- This is a single-server setup, the master is its own node.
- Copy (or map) your modules to ./modules, they will be mapped to the container
 when it is run.
- Any YAML files in your module directories will be merged into
 /var/lib/hiera/common.yaml when the container boots so that the Hiera data is
 automatically available to your modules. Changes made to common.yaml are lost
 when you 'exit'.
- The container is disposable, your data is not.
 * **Changes to /opt/modules/* in a container WILL APPLY to the ./modules directory of the host system.**
- To build the image run ./Build.sh
- To start a container based on that image run ./Go.sh


# other
- I recommend [rfkrocktk/puppetmaster](https://github.com/rfkrocktk/docker-puppetmaster) if you need a more fully-featured setup.

