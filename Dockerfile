FROM jupyter/jupyterhub

RUN apt-get update && apt-get upgrade -y && apt-get install -y wget libsm6 \
  libxrender1 libfontconfig1 libglib2.0-0

# Install PyData modules and IPython dependencies
RUN conda update --quiet --yes conda && \
    conda install --quiet --yes numpy scipy pandas matplotlib cython \
    pyzmq scikit-learn seaborn six statsmodels theano pip tornado \
    jinja2 sphinx pygments nose readline sqlalchemy ipython jupyter \
    requests

# Set up IPython kernel
#RUN rm -rf /usr/local/share/jupyter/kernels/* && \
#    ipython kernel install
#   python -m IPython kernelspec install-self # deprecated
# Install Python kernels
RUN conda create -n ipykernel_py3 python=3 ipykernel
RUN conda create -n ipykernel_py2 python=2 ipykernel
RUN bash -c "source activate ipykernel_py2"
RUN python -m ipykernel install --user

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN conda clean -y -t

#------------------------------------
# Set up shared notebooks folder
RUN mkdir /opt/shared_nbs
RUN chmod a+rwx /opt/shared_nbs

# Push Jupyter configs
COPY jupyterhub_config.py /srv/jupyterhub/jupyterhub_config.py

COPY users /tmp/users
COPY scripts/COPY_user.sh /tmp/COPY_user.sh
RUN bash /tmp/COPY_user.sh /tmp/users
RUN rm /tmp/COPY_user.sh /tmp/users

# Test
RUN python -c "import numpy, scipy, pandas, matplotlib"

COPY key.pem /srv
COPY server.crt /srv

CMD ["jupyterhub", "-f", "/srv/jupyterhub/jupyterhub_config.py"]
