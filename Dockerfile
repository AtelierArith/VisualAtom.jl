FROM julia:1.8.5

# create user with a home directory
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

USER root

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    python3 \
    python3-dev \
    python3-distutils \
    python3-venv \
    python3-pip \
    git \
    unzip \
    wget \
    && \
    apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* # clean up

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    htop \
    nano \
    openssh-server \
    tig \
    tree \
    && \
    apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* # clean up

USER ${USER}

WORKDIR /workspace/VisualAtom.jl

# Perlin noise library for Python: https://github.com/caseman/noiseRUN 
RUN pip3 install noise

RUN julia -e 'using Pkg; Pkg.add(["Revise", "LiveServer", "Pluto", "PlutoUI", "PyCall"])' && \
    julia -e 'using Pkg; Pkg.add(["BenchmarkTools", "ProfileSVG", "JET", "JuliaFormatter"])'


ENV JULIA_PROJECT "@."

COPY ./src /workspace/VisualAtom.jl/src
COPY ./docs/Project.toml /workspace/VisualAtom.jl/docs
COPY ./Project.toml /workspace/VisualAtom.jl

USER root
RUN chown -R ${NB_UID} /workspace/VisualAtom.jl
USER ${USER}

RUN rm -f Manifest.toml && julia -e 'using Pkg; \
    Pkg.instantiate(); \
    Pkg.precompile()' && \
    # Check Julia version \
    julia -e 'using InteractiveUtils; versioninfo()'

WORKDIR ${HOME}
USER ${USER}
EXPOSE 8000

CMD ["julia"]
