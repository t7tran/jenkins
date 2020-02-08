FROM jenkins/jenkins:2.204.2-alpine

# force upgrade to the latest
RUN /usr/local/bin/install-plugins.sh ant && \
    /usr/local/bin/install-plugins.sh bouncycastle-api && \
    /usr/local/bin/install-plugins.sh command-launcher && \
    /usr/local/bin/install-plugins.sh external-monitor-job && \
    /usr/local/bin/install-plugins.sh javadoc && \
    /usr/local/bin/install-plugins.sh jdk-tool && \
    /usr/local/bin/install-plugins.sh pam-auth && \
    /usr/local/bin/install-plugins.sh windows-slaves && \
# Distributed Builds plugins
    /usr/local/bin/install-plugins.sh ssh-slaves && \
    /usr/local/bin/install-plugins.sh configuration-as-code && \
# install Notifications and Publishing plugins
    /usr/local/bin/install-plugins.sh email-ext && \
    /usr/local/bin/install-plugins.sh mailer && \
    /usr/local/bin/install-plugins.sh slack && \
    /usr/local/bin/install-plugins.sh http_request && \
# Artifacts
    /usr/local/bin/install-plugins.sh htmlpublisher && \
# SCM
    /usr/local/bin/install-plugins.sh git && \
# UI
    /usr/local/bin/install-plugins.sh cloudbees-folder && \
    /usr/local/bin/install-plugins.sh greenballs && \
    /usr/local/bin/install-plugins.sh simple-theme-plugin && \
    /usr/local/bin/install-plugins.sh ansicolor && \
    /usr/local/bin/install-plugins.sh dashboard-view && \
    /usr/local/bin/install-plugins.sh view-job-filters && \
# Security
    /usr/local/bin/install-plugins.sh google-login && \
    /usr/local/bin/install-plugins.sh dependency-check-jenkins-plugin && \
    /usr/local/bin/install-plugins.sh antisamy-markup-formatter && \
    /usr/local/bin/install-plugins.sh matrix-auth && \
    /usr/local/bin/install-plugins.sh role-strategy && \
# Workflow/Pipeline
    /usr/local/bin/install-plugins.sh basic-branch-build-strategies && \
    /usr/local/bin/install-plugins.sh workflow-aggregator && \
    /usr/local/bin/install-plugins.sh blueocean && \
    /usr/local/bin/install-plugins.sh timestamper && \
    /usr/local/bin/install-plugins.sh ws-cleanup && \
    /usr/local/bin/install-plugins.sh build-timeout && \
    /usr/local/bin/install-plugins.sh credentials-binding && \
    /usr/local/bin/install-plugins.sh job-dsl && \
    /usr/local/bin/install-plugins.sh global-post-script && \
    /usr/local/bin/install-plugins.sh kubernetes-cli && \
    /usr/local/bin/install-plugins.sh google-kubernetes-engine && \
# Reporting
    /usr/local/bin/install-plugins.sh jacoco && \
    /usr/local/bin/install-plugins.sh cobertura && \
# Scaling
    /usr/local/bin/install-plugins.sh kubernetes && \
# LDAP
    /usr/local/bin/install-plugins.sh ldap && \
# JIRA plugin
    /usr/local/bin/install-plugins.sh jira

# switch to root for easy debugging
USER root

ENV TZ=Australia/Melbourne

COPY entrypoint.sh /

RUN apk --no-cache add tzdata curl dpkg openssl && \
    # install gosu
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
    curl -fsSL "https://github.com/tianon/gosu/releases/download/1.11/gosu-$dpkgArch" -o /usr/local/bin/gosu && \
    chmod +x /usr/local/bin/gosu && \
    gosu nobody true && \
    # complete gosu
    chmod +x /entrypoint.sh && \
    apk del curl dpkg && \
    rm -rf /apk /tmp/* /var/cache/apk/*

ENTRYPOINT ["/entrypoint.sh"]
