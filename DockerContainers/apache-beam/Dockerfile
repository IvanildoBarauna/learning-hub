# This can be any container image,
FROM python:3.7-bullseye

# Install SDK. (needed for Python SDK)
RUN pip3 install --no-cache-dir apache-beam[gcp]==2.35.0

# Copy files from official SDK image, including script/dependencies.
COPY --from=apache/beam_python3.7_sdk:2.35.0 /opt/apache/beam /opt/apache/beam

# Perform any additional customizations if desired

# Set the entrypoint to Apache Beam SDK launcher.
ENTRYPOINT ["/opt/apache/beam/boot"]
