# Dockerfile for 4diac FORTE with OPC UA support

FROM centos:7
MAINTAINER Ricardo Santana <rsantana@kenos.com.br>

# Needed packages to compile 4diac
RUN yum -y install epel-release && \
    yum -y install python-setuptools git gcc-c++ cmake3 make && \
    easy_install six && \
    mkdir ~/4diac && cd $_ && \
    git clone -b develop https://git.eclipse.org/r/4diac/org.eclipse.4diac.forte forte && \
    git clone https://github.com/open62541/open62541.git --branch=v0.3.0 open62541 && \
    mkdir ~/4diac/open62541/build && cd $_ && \
    cmake3 -DBUILD_SHARED_LIBS=ON \
           -DCMAKE_BUILD_TYPE=Debug \
           -DUA_ENABLE_AMALGAMATION=ON .. && \
    make -j && \
    mkdir ~/4diac/forte/build && cd $_ && \
    cmake3 -DCMAKE_BUILD_TYPE=Debug -DFORTE_ARCHITECTURE=Posix -DFORTE_MODULE_CONVERT=ON \
           -DFORTE_COM_ETH=ON -DFORTE_MODULE_IEC61131=ON -DFORTE_COM_OPC_UA=ON \
           -DFORTE_COM_OPC_UA_INCLUDE_DIR=$HOME/4diac/open62541/build \
           -DFORTE_COM_OPC_UA_LIB_DIR=$HOME/4diac/open62541/build/bin \
           -DFORTE_COM_OPC_UA_LIB=libopen62541.so .. && \
    make -j && \
    yum -y remove python-setuptools git gcc-c++ cmake3 make && \
    yum clean all && \
    rm -rf /var/cache/yum

EXPOSE 61499

EXPOSE 4840
  
CMD ["/root/4diac/forte/build/src/forte"]