FROM dorowu/ubuntu-desktop-lxde-vnc

# Install nvm, node, and npm
ENV NVM_DIR=$HOME/.nvm
ENV NODE_VERSION=20.11.1

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash \
  && [ -s "$NVM_DIR/nvm.sh" ] \
  && . "$NVM_DIR/nvm.sh" \
	&& nvm install $NODE_VERSION \
  && nvm alias default $NODE_VERSION \
  && nvm use default
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/v$NODE_VERSION/bin:$PATH

WORKDIR /home/ubuntu
RUN echo 'export NVM_DIR="$HOME/.nvm"' > .bashrc \
  && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> .bashrc

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

# Create projects directories from this github repo, then install dependencies
WORKDIR /home/ubuntu/Projects/craigigs
COPY . /home/ubuntu/Projects/craigigs

# USER ubuntu
# RUN npm i electron puppeteer
# RUN code .

# USER root