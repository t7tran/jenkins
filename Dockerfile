FROM jenkins/jenkins:2.126-alpine

# Distributed Builds plugins
RUN /usr/local/bin/install-plugins.sh ssh-slaves && \
# install Notifications and Publishing plugins
    /usr/local/bin/install-plugins.sh email-ext && \
    /usr/local/bin/install-plugins.sh mailer && \
    /usr/local/bin/install-plugins.sh slack && \
# Artifacts
    /usr/local/bin/install-plugins.sh htmlpublisher && \
# UI
    /usr/local/bin/install-plugins.sh greenballs && \
    /usr/local/bin/install-plugins.sh simple-theme-plugin && \
# Scaling
    /usr/local/bin/install-plugins.sh kubernetes && \
# Matrix-base security
    /usr/local/bin/install-plugins.sh matrix-auth

# switch to root for easy debugging
USER root

# install Maven
RUN apk --no-cache add tzdata curl dpkg openssl maven && \
    # install gosu
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
    curl -fsSL "https://github.com/tianon/gosu/releases/download/1.10/gosu-$dpkgArch" -o /usr/local/bin/gosu && \
    chmod +x /usr/local/bin/gosu && \
    gosu nobody true && \
    # complete gosu
    apk del curl dpkg && \
    rm -rf /apk /tmp/* /var/cache/apk/*

ENTRYPOINT ["gosu", "jenkins", "/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]
