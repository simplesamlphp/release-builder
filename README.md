# SimpleSAMLphp release builder

This is a minimalistic docker image to help build SimpleSAMLphp releases. It pulls a basic PHP image, installs
composer, node.js and composer on it, and checks out the branch of a given minor release. The image can then be run
in a container in order to execute the build script and produce the release tarball, which is left in the `build`
directory.

### Usage

First, clone this repository:

```bash
git clone https://github.com/simplesamlphp/release-builder.git
cd release-builder
```

Now, build the image:

```bash
export PHP_VER=x.y
docker build -t builder --build-arg php=$PHP_VER .
```

This will build a container and tag it as *builder*. Note that you need to specify the version of PHP, which should
be the minimum version of PHP supported by the release we want to build (e.g. `5.5`).

Now you can clone SimpleSAMLphp in the root of the repository:

```bash
git clone https://github.com/simplesamlphp/simplesamlphp.git simplesamlphp
```

Once docker finishes building the container, you can run it to build the exact release you want:

```bash
docker run --mount type=bind,source="$(pwd)/build/",target=/tmp --mount type=bind,source="$(pwd)/simplesamlphp/",target=/simplesamlphp builder X.Y.Z /simplesamlphp
```

Note that you have to bind the `build` and `simplesamlphp` directories in this repo to `/tmp` and `/simplesamlphp`
inside the container, respectively. `/tmp` is where the build script will work and generate the tarball, while
`/simplesamlphp` is where the build script expects to find the SimpleSAMLphp repository. This allows you to work on
a release without the need for tagging it in github. Apart from that, you only need to specify the version you want to
build (`X.Y.Z`).

#### Running the container with dinghy

[dinghy](https://github.com/codekitchen/dinghy) is an alternative to Docker in MacOS, with the advantage of being
much faster and usable than the native implementation of the operating system. If you are using dinghy, docker itself
will run inside a virtual machine, meaning the directory mapping will happen inside the virtual machine, and not your
local filesystem. In order to use this repo and get the tarball dropped into the `build` directory, you need to
map the root directory of this builder inside the dinghy virtual machine. This can be done by starting dinghy with a
couple of environment variables set to the appropriate path:

```bash
dinghy down
export DINGHY_HOST_MOUNT_DIR=$(pwd)
export DINGHY_GUEST_MOUNT_DIR=$(pwd)
dinghy up
``` 
