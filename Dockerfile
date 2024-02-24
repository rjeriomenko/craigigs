FROM dorowu/ubuntu-desktop-lxde-vnc

# Add a new user, set their password, and use the user
RUN useradd -m docker && echo "docker:docker" | chpasswd \
  && adduser docker sudo
USER docker

# Install nvm, node, and npm
RUN echo password | sudo -S curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash \
	&& source ~/.bashrc \
	&& nvm install --lts

# Install git
RUN echo password | sudo -S add-apt-repository -y ppa:git-core/ppa \
	&& echo password | sudo -S apt update \
	&& echo password | sudo -S apt install git -y

# Install vsc
RUN curl -o vscinstall.deb https://vscode.download.prss.microsoft.com/dbazure/download/stable/903b1e9d8990623e3d7da1df3d33db3e42d80eda/code_1.86.2-1707854558_amd64.deb \
	&& echo password | sudo -S apt install ./vscinstall.deb \
	&& rm ./vscinstall.deb \
	&& export DONT_PROMPT_WSL_INSTALL=true

# Create project directory, clone this github repo, then install dependencies
RUN mkdir Projects \
	&& cd $_ \
	&& git clone https://github.com/rjeriomenko/craigigs.git \
	&& cd craigigs \
	&& npm i electron puppeteer