# Start from the code-server Debian base image
FROM codercom/code-server:4.0.2

USER coder

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Install unzip + rclone (support for remote filesystem)
RUN sudo apt-get update && sudo apt-get install unzip -y
RUN curl https://rclone.org/install.sh | sudo bash

# Copy rclone tasks to /tmp, to potentially be used
COPY deploy-container/rclone-tasks.json /tmp/rclone-tasks.json

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# You can add custom software and dependencies for your environment below
# -----------

# Install a VS Code extension:
# Note: we use a different marketplace than VS Code. See https://github.com/cdr/code-server/blob/main/docs/FAQ.md#differences-compared-to-vs-code
# RUN code-server --install-extension esbenp.prettier-vscode
RUN code-server --install-extension ms-python.python
RUN code-server --install-extension zhuangtongfa.material-theme
RUN code-server --install-extension dbaeumer.vscode-eslint

RUN curl https://github.com/VSCodeVim/Vim/releases/download/v1.23.2/vim-1.23.2.vsix --output vim-1.23.2.vsix
RUN code-server --install-extension ./vim-1.23.2.vsix
RUN rm ./vim-1.23.2.vsix

RUN curl -L https://raw.githubusercontent.com/chanwutk/code-server-init/main/ms-vscode-remote.remote-ssh-0.47.0.vsix?token=GHSAT0AAAAAABYV6QSQOJ2S2C47G7MXABE2YZAD5AQ --output remote-ssh.vsix
RUN code-server --install-extension ./remote-ssh.vsix
RUN rm ./remote-ssh.vsix

# Install apt packages:
# RUN sudo apt-get install -y ubuntu-make

# Copy files: 
# COPY deploy-container/myTool /home/coder/myTool

# -----------

# Port
ENV PORT=8080

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
