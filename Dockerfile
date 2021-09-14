# Big image but it's cached on gitpod nodes already
FROM gitpod/workspace-full:latest

# Install tools as the gitpod user
USER gitpod
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install helper tools
RUN brew update && brew upgrade && brew install \
    gawk coreutils pre-commit tfenv terraform-docs \
    tflint tfsec instrumenta/instrumenta/conftest \
    && brew install --ignore-dependencies cdktf \
    && brew cleanup
RUN tfenv install latest && tfenv use latest

# ZSH SHELL: Uses "Spaceship" theme with some customization.
# Uses some bundled plugins and installs some more from github
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)" -- \
    -t https://github.com/denysdovhan/spaceship-prompt \
    -a 'SPACESHIP_PROMPT_ADD_NEWLINE="false"' \
    -a 'SPACESHIP_PROMPT_SEPARATE_LINE="false"' \
    -p git \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions

# Let us give ZSH on Gitpod a try
# COPY .gitpod.bashrc /home/gitpod/.bashrc.d/custom

# Give back control
USER root
#  and revert back to default shell
#  otherwise adding Gitpod Layer will fail
SHELL ["/bin/sh", "-c"]
