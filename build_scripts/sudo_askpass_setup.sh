#!/bin/bash

echo "This script need sudo priviledge to run. Please enter your password"
echo "Proceeding..."
read -s -p "Enter your password: " password
echo

# Set the target path to the user's home directory
target_path="$HOME/bin"
echo "Setup is installing $target_path"
# Check if the target directory exists
if [ ! -d "$target_path" ]; then
echo "Target directory does not exist. Creating directory..."
mkdir -p "$target_path"
if [ ! -d "$target_path" ]; then
    echo "Please check Permission and Manual create directory!"
else
    echo "Created successfully directory: $target_path"
    fi
fi

# Create a new script file named "ubuntu_askpass.sh"
echo "Continue..."
touch $target_path/ubuntu_askpass.sh
echo "#!/bin/bash" > $target_path/ubuntu_askpass.sh
echo "echo '$password'" >> $target_path/ubuntu_askpass.sh

# Make the generated script executable
chmod +x $target_path/ubuntu_askpass.sh

# Export SUDO_ASKPASS
export SUDO_ASKPASS=$target_path/ubuntu_askpass.sh
echo "Successfully! Please check your setup: $target_path"