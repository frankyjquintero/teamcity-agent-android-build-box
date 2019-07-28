FROM jetbrains/teamcity-minimal-agent:latest

LABEL maintainer="Franky J. Quintero"

ENV ANDROID_HOME="/opt/android-sdk"

# Buscar ultima version aqui https://developer.android.com/studio/index.html
ENV ANDROID_SDK_TOOLS_VERSION="4333796"


# Establecer Localizacion
ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8"

RUN apt-get clean && apt-get update -qq && apt-get install -qq -y apt-utils locales && locale-gen $LANG

# Configurar DEBIAN_FRONTEND en no interactivo a través de ENV
ENV DEBIAN_FRONTEND="noninteractive" \
    TERM=dumb \
    DEBIAN_FRONTEND=noninteractive

# Las variables deben ser referencias una vez creadas.
ENV ANDROID_SDK_HOME="$ANDROID_HOME"

ENV PATH="$PATH:$ANDROID_SDK_HOME/tools/bin:$ANDROID_SDK_HOME/tools:$ANDROID_SDK_HOME/platform-tools"

COPY README.md /README.md

WORKDIR /tmp

# Installing packages
RUN apt-get update  && \
    apt-get install locales && \
    locale-gen "$LANG" && \
    apt-get -y install --no-install-recommends \
        curl \
        git \
        pkg-config \
        unzip \
        wget \
        zip \
        zlib1g-dev

# Instalar SDK TOOL Android
# Linux	sdk-tools-linux-4333796.zip	147 MB	92ffee5a1d98d856634e8b71132e8a95d96c83a63fde1099be3d86df3106def9
RUN echo "Installing sdk tools ${ANDROID_SDK_TOOLS_VERSION}" && \
    wget --output-document=sdk-tools.zip \
        "https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS_VERSION}.zip" && \
    mkdir --parents "$ANDROID_HOME" && \
    unzip -q sdk-tools.zip -d "$ANDROID_HOME" && \
    rm --force sdk-tools.zip

# Install SDKs
# ¡Por favor, manténgalos en orden descendente!
# El sí es para aceptar todas las licencias de herramientas no estándar.
RUN mkdir --parents "$ANDROID_HOME/.android/" && \
    echo '### User Sources for Android SDK Manager' > \
        "$ANDROID_HOME/.android/repositories.cfg" && \
    yes | "$ANDROID_HOME"/tools/bin/sdkmanager --licenses

# Android SDK Platform 28	72.06 MB
RUN echo "Installing platforms" && \
    yes | "$ANDROID_HOME"/tools/bin/sdkmanager \
        "platforms;android-28"

# Android SDK Platform-Tools	tools	29.0.1	11.71 MB
RUN echo "Installing platform tools " && \
    yes | "$ANDROID_HOME"/tools/bin/sdkmanager \
        "platform-tools"

# Android SDK Build-Tools 28.0.3	tools	28.0.3	55.15 MB
RUN echo "Installing build tools " && \
    yes | "$ANDROID_HOME"/tools/bin/sdkmanager \
        "build-tools;28.0.3"

# https://androidsdkmanager.azurewebsites.net/Extras
RUN echo "Installing extras => extras;android;m2repository" && \
    yes | "$ANDROID_HOME"/tools/bin/sdkmanager \
        "extras;android;m2repository"

RUN echo "Installing extras => extras;google;m2repository" && \
    yes | "$ANDROID_HOME"/tools/bin/sdkmanager \
        "extras;google;m2repository"

RUN echo "Installing play services => extras;google;google_play_services" && \
    yes | "$ANDROID_HOME"/tools/bin/sdkmanager \
        "extras;google;google_play_services"

RUN echo "Installing play services => extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2" && \
    yes | "$ANDROID_HOME"/tools/bin/sdkmanager \
        "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2"

RUN echo "Installing play services => extras;m2repository;com;android;support;constraint;constraint-layout;1.0.1" && \
    yes | "$ANDROID_HOME"/tools/bin/sdkmanager \
        "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.1"


# Copy sdk license agreement files.
RUN mkdir -p $ANDROID_HOME/licenses
COPY sdk/licenses/* $ANDROID_HOME/licenses/

RUN chmod 777 $ANDROID_HOME/.android
