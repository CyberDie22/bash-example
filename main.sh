version = "$(uname -v)"
if [[ "$version" == *"Ubuntu"* ]]; then
    echo "Ubuntu"
else
    echo "Unsupported operating system"
fi