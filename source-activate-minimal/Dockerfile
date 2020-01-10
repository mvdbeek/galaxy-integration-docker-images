FROM bgruening/busybox-bash:0.1

RUN mkdir -p /usr/local/etc/conda/activate.d && echo 'export CONDA_VAR=CONDA_PREFIX_IS_${CONDA_PREFIX}' > /usr/local/etc/conda/activate.d/sourceme.sh
