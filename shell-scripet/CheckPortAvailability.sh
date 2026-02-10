#!/bin/bash
PORT= ("80" "1199" "22")
if lsof -i:$PORT > /dev/null; then
echo "Port $PORT is in use."
else
echo "Port $PORT is free."
fi
