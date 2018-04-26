FROM ubuntu:16.04 as build

RUN apt-get update && apt-get install -fy git cmake build-essential
RUN mkdir ~/blender-git && \
    cd ~/blender-git && \
    git clone https://git.blender.org/blender.git && \
    cd blender && \
    git submodule update --init --recursive && \
    git submodule foreach git checkout master && \
    git submodule foreach git pull --rebase origin master

RUN apt-get install -yf sudo
ENV BUILD_CMAKE_ARGS="-D WITH_PYTHON_INSTALL=OFF -D WITH_PLAYER=OFF -D WITH_PYTHON_MODULE=ON -D PYTHON_VERSION=3.6"
ENV CMAKE_CXX_FLAGS='-fPIC'
ENV CXXFLAGS='-fPIC'
ENV CFLAGS='-fPIC'
RUN cd ~/blender-git && ./blender/build_files/build_environment/install_deps.sh
RUN cd ~/blender-git/blender && make CXXFLAGS="-fPIC" CFLAGS="-fPIC"

FROM python:3.6
COPY --from=build /root/blender-git/build_linux/bin /root/blender-git