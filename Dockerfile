# templateOption default overrides Dockerfile default and build args. 
FROM quay.io/fedora/fedora-minimal:39
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ARG USERNAME=vscode
ARG USERSHELL=zsh
ARG USERPGK=${USERPGK:-"docker"}
ARG USER_UID=1000
ARG WORKSPACES=/workspaces
ARG USER_GID=${USER_UID}
RUN microdnf -y install \
    dnf-plugins-core \
    coreutils \
    git \
    gh \
    gcc \
    gcc-c++ \
    less \
    ncurses \
    passwd \
    iproute \
    ca-certificates \
    openssl-libs \
    openssh-clients \
    procps \
    procps-ng \
    psmisc \
    rsync \
    shadow-utils \
    strace \
    sudo \
    tar \
    tmux \
    unzip \
    util-linux \
    wget \
    which \
    xz \
    zip \
    $USERSHELL \
    $USERPGK \
 && ln -s /bin/dnf-3 /usr/bin/dnf \
 && groupadd --gid ${USER_GID} ${USERNAME} \
 && useradd --uid ${USER_UID} -s /usr/bin/${USERSHELL} --gid ${USER_GID} -m ${USERNAME} \
 && usermod -aG wheel ${USERNAME} \
 && echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME} \
 && chmod 0440 /etc/sudoers.d/${USERNAME} \
 && mkdir -p ${WORKSPACES} \
 && chown -R ${USERNAME} ${WORKSPACES} \
 && chown -R ${USERNAME} /usr/local/bin/ \
 && chown -R ${USERNAME} /home/${USERNAME} \
 && echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME} \
 && microdnf clean all \
 && rm -rf /var/cache/dnf \ 
 && rm -rfd /tmp/* \
 && passwd -d ${USERNAME}
ENV PATH="$HOME/bin:$HOME/.local/bin:/home/linuxbrew/.linuxbrew/bin/:/home/linuxbrew/.linuxbrew/sbin/:$PATH"
USER ${USERNAME}
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
WORKDIR ${WORKSPACES}
LABEL version="0.1.0"
LABEL org.opencontainers.image.authors="disev@d1sev.dev"
LABEL org.opencontainers.image.description="This Containerfile creates a _CONTAINER_USER vscode for devcontainer usage based on \
    a fedora-minimal image, required by devcontainer cli to create a Codespaces-compatible user enviroment."
LABEL org.opencontainers.image.source=https://github.com/coffedora/devcontainer