# -------------------------------------------------------------------
# Custom OLAM EE with VMware + PostgreSQL + Windows + General modules
# -------------------------------------------------------------------

FROM container-registry.oracle.com/oracle_linux_automation_manager/olam-ee:latest

LABEL maintainer="moemyintshein@outlook.com" \
      description="Custom OLAM EE with VMware modules and dependencies" \
      vendor="btwo"

# ------------------------------------------------------
# 1. Switch to root for system-level installations
# ------------------------------------------------------
USER root

# ------------------------------------------------------
# 2. Install required system tools & Python 3.9
# ------------------------------------------------------
RUN yum -y install oraclelinux-developer-release-el8 && \
    yum -y install \
        python39 \
        python39-pip \
        python39-devel \
        gcc \
        gcc-c++ \
        make \
        git \
        openssl-devel \
        libffi-devel \
        tar \
        unzip \
        which \
        sudo \
        sshpass \
        openssh-clients && \
    yum clean all && \
    alternatives --set python3 /usr/bin/python3.9 && \
    python3 -m ensurepip --upgrade || true

# ------------------------------------------------------
# 3. Upgrade pip, setuptools, and wheel for modern builds
# ------------------------------------------------------
ENV PIP_BREAK_SYSTEM_PACKAGES=1
RUN pip3 install --upgrade pip setuptools wheel

# ------------------------------------------------------
# 4. Install Python packages required for VMware + DB
# ------------------------------------------------------
RUN pip3 install --no-cache-dir --ignore-installed \
        pyvmomi \
        requests \
        urllib3 \
        lxml \
        netaddr \
        ansible-core \
        ansible-runner \
        oracledb \
        pyodbc

# ------------------------------------------------------
# 5. Install Ansible Collections (VMware, DB, Windows)
# ------------------------------------------------------
RUN mkdir -p /usr/share/ansible/collections && \
    ansible-galaxy collection install \
        community.vmware \
        vmware.vmware \
        vmware.vmware_rest \
        community.postgresql \
        community.general \
        community.windows \
        --collections-path /usr/share/ansible/collections

# ------------------------------------------------------
# 6. Set Python 3.9 as default and clean image
# ------------------------------------------------------
RUN ln -sf /usr/bin/python3.9 /usr/bin/python && \
    python --version && \
    pip --version && \
    ansible-galaxy collection list && \
    yum clean all && \
    rm -rf /var/cache/yum

# ------------------------------------------------------
# 7. Set permissions back for OLAM runtime user
# ------------------------------------------------------
USER awx

# ------------------------------------------------------
# 8. Default command (keeps OLAM behavior)
# ------------------------------------------------------
CMD ["/usr/bin/launch_awx"]
