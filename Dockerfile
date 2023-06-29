FROM jenkins/jenkins:2.401.2-lts-alpine

# force upgrade to the latest
RUN jenkins-plugin-cli --plugins \
    ant \
    bouncycastle-api \
    command-launcher \
    external-monitor-job \
    javadoc \
    jdk-tool \
    pam-auth \
    configuration-as-code \
    email-ext \
    mailer \
    slack \
    http_request \
    google-hangouts-chat-notifier:1.0:https://storage.googleapis.com/jenkins-bot-production.appspot.com/plugin/1.0/google-hangouts-chat-notifier.hpi \
    htmlpublisher \
    git \
    cloudbees-folder \
    greenballs \
    simple-theme-plugin \
    ansicolor \
    dashboard-view \
    view-job-filters \
    google-login \
    dependency-check-jenkins-plugin \
    antisamy-markup-formatter \
    matrix-auth \
    role-strategy \
    basic-branch-build-strategies \
    workflow-aggregator \
    blueocean \
    blueocean-jira \
    timestamper \
    ws-cleanup \
    build-timeout \
    credentials-binding \
    job-dsl \
    global-post-script \
    kubernetes-cli \
    google-kubernetes-engine \
    build-user-vars-plugin \
    validating-string-parameter \
    jacoco \
    cobertura \
    kubernetes \
    ldap \
    jira

# switch to root for easy debugging
USER root

ENV TZ=Australia/Melbourne

COPY entrypoint.sh /

RUN apk --no-cache add tzdata curl dpkg openssl && \
    # install gosu
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
    curl -fsSL "https://github.com/tianon/gosu/releases/download/1.14/gosu-$dpkgArch" -o /usr/local/bin/gosu && \
    chmod +x /usr/local/bin/gosu && \
    gosu nobody true && \
    # complete gosu
    chmod +x /entrypoint.sh && \
    apk del curl dpkg && \
    rm -rf /apk /tmp/* /var/cache/apk/*

ENTRYPOINT ["/entrypoint.sh"]
