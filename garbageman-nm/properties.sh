#!/bin/bash
# ==============================================================================
# Garbageman Nodes Manager - Umbrel Properties Script
# ==============================================================================
# This script is executed by Umbrel to display app information in the UI
# It outputs YAML-formatted data that appears in the app's "Properties" tab
#
# When users click on the app in Umbrel's dashboard and navigate to "Properties",
# they will see the information defined below (password, URLs, etc.)
#
# Umbrel runs this script inside the container with access to /data volumes
set -e

# ==============================================================================
# Read Auto-Generated Password
# ==============================================================================
# The password is generated during container startup by docker_entrypoint.sh
# It's a cryptographically secure random string stored in the container's data volume
PASSWORD_FILE="/data/webui-password.txt"

if [ -f "$PASSWORD_FILE" ]; then
    WEBUI_PASSWORD=$(cat "$PASSWORD_FILE")
else
    # If the file doesn't exist yet, the container may still be starting up
    WEBUI_PASSWORD="Not generated yet (check logs)"
fi

# ==============================================================================
# Service Port Configuration
# ==============================================================================
# These match the ports exposed by the container (defined in docker-compose.yml)
# Umbrel's app_proxy may route traffic differently, but these are the direct ports
UI_PORT="5173"          # Next.js Web UI
API_PORT="8080"         # Fastify REST API
SUPERVISOR_PORT="9000"  # Multi-daemon supervisor API

# ==============================================================================
# Output Properties in YAML Format
# ==============================================================================
# Umbrel expects properties in a specific YAML structure
# Each property has:
#   - type: Data type (string, number, boolean)
#   - value: The actual value to display
#   - description: Helper text shown to user
#   - copyable: Whether to show a copy-to-clipboard button
#   - qr: Whether to show a QR code
#   - masked: Whether to hide the value by default (for sensitive data)

cat <<EOF
version: 1
data:
  WebUI Password:
    type: string
    value: "$WEBUI_PASSWORD"
    description: Use this password to access the WebUI
    copyable: true    # Show copy button
    qr: false         # Don't show QR code
    masked: true      # Hide by default (click to reveal)
  
  WebUI URL:
    type: string
    value: "http://umbrel.local:$UI_PORT"
    description: Access the Garbageman management interface
    copyable: true    # Show copy button
    qr: true          # Show QR code (useful for mobile access)
    masked: false     # Always visible
  
  API Endpoint:
    type: string
    value: "http://umbrel.local:$API_PORT"
    description: Direct API access (requires authentication)
    copyable: true
    qr: false
    masked: false
  
  Supervisor API:
    type: string
    value: "http://umbrel.local:$SUPERVISOR_PORT"
    description: Multi-daemon supervisor control interface
    copyable: true
    qr: false
    masked: false
  
  Data Directory:
    type: string
    value: "/data"
    description: Persistent data location inside container
    copyable: false   # No need to copy this
    qr: false
    masked: false
EOF
