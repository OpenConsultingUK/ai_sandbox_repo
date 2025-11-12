# Use a multi-stage build to reduce the size of the final image.
FROM python:3.12-slim-bookworm AS python_builder

# Pin uv to a specific version to make container builds reproducible.
ENV UV_VERSION=0.8.8
ENV UV_PYTHON_DOWNLOADS=never

# Set ENV variables that make Python more friendly to running inside a container.
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONBUFFERED=1

# By default, pip caches copies of downloaded packages from PyPI.
ENV PIP_NO_CACHE_DIR=1
ENV WORKDIR=/src

WORKDIR ${WORKDIR}

# Install uv into the global environment to isolate it from the venv it creates.
RUN pip install "uv==${UV_VERSION}"

# This path MUST match the one used in the final image
ENV UV_PROJECT_ENVIRONMENT=/opt/venv

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies (including google-adk) into the virtual environment
RUN uv sync --no-install-project --all-extras

# Copy source files
COPY README.md ./
COPY src src

# Install the project itself
RUN uv sync --no-editable

## Final Image
FROM python:3.12-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONBUFFERED=1
ENV UV_PROJECT_ENVIRONMENT=/opt/venv

ENV HOME=/home/user
ENV APP_HOME=${HOME}/app

# Create the home directory for the new user.
RUN mkdir -p ${HOME}

# Create the user so the program doesn't run as root.
RUN groupadd -r user && \
    useradd -r -g user -d ${HOME} -s /sbin/nologin -c "Container image user" user

# Setup application install directory.
RUN mkdir ${APP_HOME}

WORKDIR ${APP_HOME}

# Copy and activate pre-built virtual environment.
COPY --from=python_builder ${UV_PROJECT_ENVIRONMENT} ${UV_PROJECT_ENVIRONMENT}
ENV PATH="${UV_PROJECT_ENVIRONMENT}/bin:${PATH}"

# Give access to the entire home folder to the new user.
RUN chown -R user:user ${HOME}

USER user

#CMD ["adk", "web", "--port", "8000"]
CMD ["/opt/venv/bin/python", "-m", "adk", "api_server", "--module", "fact.agent", "--host", "0.0.0.0", "--port", "8000"]