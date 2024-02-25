# Use ubuntu image with a vnc desktop prebuilt
FROM dorowu/ubuntu-desktop-lxde-vnc

# Install nvm, node, and npm
ENV NODE_VERSION=20.11.1
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=$HOME/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="$HOME/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"

# Install git
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E88979FB9B30ACF2 \
  && add-apt-repository -y ppa:git-core/ppa \
	&& apt update \
	&& apt install git -y

# Install vsc
RUN curl -o vscinstall.deb https://vscode.download.prss.microsoft.com/dbazure/download/stable/903b1e9d8990623e3d7da1df3d33db3e42d80eda/code_1.86.2-1707854558_amd64.deb \
	&& apt install ./vscinstall.deb \
	&& rm ./vscinstall.deb
ENV DONT_PROMPT_WSL_INSTALL=true

# Copy project files and install dependencies
WORKDIR /home/ubuntu/Projects/craigigs
COPY . .
RUN npm i electron puppeteer