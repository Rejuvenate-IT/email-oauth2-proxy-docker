# Use a Python image based on Alpine Linux
FROM python:3.11-alpine

# Set the working directory
WORKDIR /app


# Install core dependencies
RUN pip install --no-cache-dir \
    cryptography \
    pyasyncore \
    boto3 \
    prompt_toolkit \
    pyjwt \
    google-auth \
	requests

# Get the original script
RUN wget -O emailproxy.py https://raw.githubusercontent.com/simonrob/email-oauth2-proxy/main/emailproxy.py

# Copy the Python script and shell script into the container
COPY emailproxy.py /app/
COPY run_email_proxy.sh /app/

# Make the shell script executable
RUN chmod +x /app/run_email_proxy.sh

# Run the shell script
CMD ["/bin/sh", "/app/run_email_proxy.sh"]
