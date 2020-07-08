FROM jenkins/jenkins:2.235.1-alpine

# force upgrade to the latest
RUN echo -e '\
    ant \n\
    bouncycastle-api \n\
    command-launcher \n\
    external-monitor-job \n\
    javadoc \n\
    jdk-tool \n\
    pam-auth \n\
    windows-slaves \n\
  # Distributed Builds plugins \n\
    ssh-slaves \n\
    configuration-as-code \n\
  # install Notifications and Publishing plugins \n\
    email-ext \n\
    mailer \n\
    slack \n\
    http_request \n\
    google-hangouts-chat-notifier:1.0:true:https://storage.googleapis.com/jenkins-bot-production.appspot.com/plugin/1.0/google-hangouts-chat-notifier.hpi \n\
  # Artifacts \n\
    htmlpublisher \n\
  # SCM \n\
    git \n\
  # UI \n\
    cloudbees-folder \n\
    greenballs \n\
    simple-theme-plugin \n\
    ansicolor \n\
    dashboard-view \n\
    view-job-filters \n\
  # Security \n\
    google-login \n\
    dependency-check-jenkins-plugin \n\
    antisamy-markup-formatter \n\
    matrix-auth \n\
    role-strategy \n\
  # Workflow/Pipeline \n\
    basic-branch-build-strategies \n\
    workflow-aggregator \n\
    blueocean \n\
    timestamper \n\
    ws-cleanup \n\
    build-timeout \n\
    credentials-binding \n\
    job-dsl \n\
    global-post-script \n\
    kubernetes-cli \n\
    google-kubernetes-engine \n\
  # Reporting \n\
    jacoco \n\
    cobertura \n\
  # Scaling \n\
    kubernetes \n\
  # LDAP \n\
    ldap \n\
    jira \n\
    ' | /usr/local/bin/install-plugins.sh

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
