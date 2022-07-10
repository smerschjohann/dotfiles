TIME_FROM_SERVER=$(curl -v --insecure --silent https://www.google.com/ 2>&1 | grep '< date' | sed -e 's/< date: //' | sed -e 's/\r//');
# Set stored time
sudo date -s "$TIME_FROM_SERVER"
date
