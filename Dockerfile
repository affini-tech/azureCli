FROM python:3.6.2-jessie

WORKDIR azure-cli
COPY . /azure-cli
# pip wheel - required for CLI packaging
# jmespath-terminal - we include jpterm as a useful tool
RUN pip install --no-cache-dir --upgrade pip wheel jmespath-terminal
# We also, install jp
RUN wget https://github.com/jmespath/jp/releases/download/0.1.2/jp-linux-amd64 -qO /usr/local/bin/jp && chmod +x /usr/local/bin/jp

# 1. Build packages and store in tmp dir
# 2. Install the cli and the other command modules that weren't included
# 3. Temporary fix - install azure-nspkg to remove import of pkg_resources in azure/__init__.py (to improve performance)
RUN /bin/bash -c 'TMP_PKG_DIR=$(mktemp -d); \
    for d in src/azure-cli src/azure-cli-core src/azure-cli-nspkg src/azure-cli-command_modules-nspkg src/command_modules/azure-cli-*/; \
    do cd $d; python setup.py bdist_wheel -d $TMP_PKG_DIR; cd -; \
    done; \
    MODULE_NAMES=""; \
    for f in $TMP_PKG_DIR/*; \
    do MODULE_NAMES="$MODULE_NAMES $f"; \
    done; \
    pip install --no-cache-dir $MODULE_NAMES; \
    pip install --no-cache-dir --force-reinstall --upgrade azure-nspkg azure-mgmt-nspkg;'

# Add usefull tools
RUN apt-get update && apt-get install vim jq -y

# Tab completion
RUN echo "source /usr/local/bin/az.completion.sh" >> /root/.bashrc

# Add documentation
RUN pip install mdv
RUN mv docs /
WORKDIR /docs
RUN echo "mdv /docs/azQuickStart.md" >> /root/.bashrc
RUN git clone https://github.com/Azure/azure-cli-samples.git

# Azure CLI 1.0 install
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
  apt-get install -y nodejs && \
  npm install -g azure-cli && \
  azure --completion >> ~/azure.completion.sh && \
  echo 'source ~/azure.completion.sh' >> ~/.bashrc


WORKDIR /

CMD bash
