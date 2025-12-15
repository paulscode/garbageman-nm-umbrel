# Garbageman Nodes Manager - Umbrel Community App Store

Community Umbrel app store for [Garbageman Nodes Manager](https://github.com/paulscode/garbageman-nm) - a modern web-based control plane for managing multiple Bitcoin nodes.

## About Garbageman Nodes Manager

**Features:**
- Modern dark neon war room aesthetic with real-time monitoring
- Run multiple Bitcoin daemon instances (Garbageman or Bitcoin Knots)
- Import pre-built binaries and pre-synced blockchains from GitHub
- Peer discovery via clearnet DNS seeds + Tor-based .onion discovery
- Automatic Libre Relay node detection
- Privacy-first with integrated Tor support

## What is this Repository?

This is a **community app store** that allows you to install Garbageman Nodes Manager on your Umbrel with one click from the Umbrel UI.

**Benefits of using this app store:**
- ✅ One-click installation from Umbrel dashboard
- ✅ WebUI password visible in app properties panel (no SSH needed)
- ✅ Automatic updates when new versions are released
- ✅ Integrated with Umbrel's app management system

## Repository Structure

```
garbageman-nm-umbrel/
├── README.md                      # This file
├── .gitignore                     # Git ignore patterns
├── umbrel-app-store.yml           # App store manifest
└── garbageman-nm/                 # App directory
    ├── umbrel-app.yml             # App metadata and manifest
    ├── docker-compose.yml         # Deployment config (uses pre-built multi-arch Docker Hub image)
    ├── exports.sh                 # Environment variable exports
    └── icon.svg                   # App icon
```

**Note:** Docker images are built from the main [garbageman-nm](https://github.com/paulscode/garbageman-nm) repository and published to Docker Hub as multi-arch images supporting both x86_64 (amd64) and aarch64 (arm64) architectures.

## For Users: How to Add This App Store

### Method 1: Via Umbrel UI (if available in your version)
1. Open Umbrel dashboard
2. Go to App Store settings
3. Add community app store: `https://github.com/paulscode/garbageman-nm-umbrel.git`

### Method 2: Via SSH (works on all versions)
```bash
# SSH into Umbrel
ssh umbrel@umbrel.local

# Edit Umbrel configuration
nano ~/umbrel/umbrel.yaml

# Add this app store under appRepositories:
appRepositories:
  - https://github.com/getumbrel/umbrel-apps.git
  - https://github.com/paulscode/garbageman-nm-umbrel.git

# Save and exit (Ctrl+O, Enter, Ctrl+X)

# Restart Umbrel to load the new app store
sudo systemctl restart umbrel.service
```

After restart, **Garbageman Nodes Manager** will appear in the Umbrel UI under the "Community" section.

### Installing the App

Once the app store is added:
1. Open Umbrel dashboard
2. Browse to "Community" apps
3. Find "Garbageman Nodes Manager"
4. Click "Install"
5. Wait for installation to complete
6. Access the app from your Umbrel dashboard
7. Click "Properties" tab to see your auto-generated WebUI password

## For Developers: Publishing Updates

If you're the maintainer and want to release a new version:

### 1. Build and Push Multi-Arch Docker Image

Docker images are built from the main [garbageman-nm](https://github.com/paulscode/garbageman-nm) repository:

```bash
# Navigate to main garbageman-nm repository
cd ../garbageman-nm

# Build and push multi-arch image using the provided script
./build-and-push-docker.sh 0.2.2.0

# This builds for linux/amd64 and linux/arm64 and pushes to Docker Hub
```

The script creates tags:
- `paulscode/garbageman-nm:0.2.2.0` (version tag)
- `paulscode/garbageman-nm:latest` (latest tag)

### 2. Update This Repository

```bash
cd garbageman-nm-umbrel

# Update version in umbrel-app.yml
# Update image tag in docker-compose.yml to match new version
```

Edit `garbageman-nm/umbrel-app.yml`:
- Update `version: "0.2.2.0"`

Edit `garbageman-nm/docker-compose.yml`:
- Update `image: paulscode/garbageman-nm:v0.2.2`

### 3. Commit and Release

```bash
git add garbageman-nm/umbrel-app.yml garbageman-nm/docker-compose.yml
git commit -m "feat: Update to v0.2.2 with multi-arch support"
git tag v0.2.2.0
git push origin master --tags
```

### 4. Users Get Updates

Users with this app store added will see the update available in their Umbrel dashboard and can update with one click.

## Development Notes

### Architecture Decisions

**Container Design:**
- Uses pre-built multi-arch Docker images from Docker Hub
- Images built from main garbageman-nm repository
- Single container with supervisord managing 3 services:
  1. Supervisor (port 9000) - Multi-daemon manager
  2. API (port 8080) - Fastify backend
  3. UI (port 5173) - Next.js frontend

**Platform Support:**
- x86_64 (amd64) - Intel/AMD processors
- aarch64 (arm64) - ARM processors (Raspberry Pi 5, etc.)

**Network:**
- IP Assignment: `10.21.21.201` (Umbrel private network)
- Above the range used by official Umbrel apps (10.21.21.1-100)

**Integration:**
- Umbrel app_proxy routes traffic to UI (port 5173)
- Uses Umbrel's environment variables (`$APP_DATA_DIR`, `$TOR_PROXY_IP`, etc.)
- Static default password: `garbageman` (shown in properties panel)

### Build Process

Docker images are NOT built in this repository. Instead:
1. Images are built from the main [garbageman-nm](https://github.com/paulscode/garbageman-nm) repo
2. Built using `build-and-push-docker.sh` script with buildx for multi-arch
3. Published to Docker Hub as `paulscode/garbageman-nm:VERSION`
4. This repository simply references the Docker Hub image in `docker-compose.yml`

### Versioning

- **Main repo** uses semantic versioning: `v0.2.2`
- **Docker tags** use format: `0.2.2.0`, `0.2.2.1`, etc.
- **Umbrel app** version follows: `0.2.2.0`
- The fourth digit (`.0`) allows for Umbrel-specific patches

## Technical Details

### Docker Image
This app uses pre-built multi-arch Docker images from Docker Hub:
- **Image**: `paulscode/garbageman-nm`
- **Current version**: `0.2.2.0`
- **Architectures**: linux/amd64 (x86_64), linux/arm64 (aarch64)
- **View on Docker Hub**: https://hub.docker.com/r/paulscode/garbageman-nm
- **Built from**: https://github.com/paulscode/garbageman-nm

### Network Configuration
- Internal IP: `10.21.21.201` (Umbrel private network)
- Web UI Port: `5173`
- API Port: `8080`
- Supervisor Port: `9000`
- Internal Tor daemon: `127.0.0.1:9050`

### Data Persistence
All data stored in `${APP_DATA_DIR}` with subdirectories:
- `/data/bitcoin` - Bitcoin daemon data directories
- `/data/envfiles` - Instance configuration files
- `/data/artifacts` - Imported binaries and blockchain archives
- `/data/tor` - Tor daemon data and hidden service keys

## Troubleshooting

### Image not found
- Verify image exists on Docker Hub: https://hub.docker.com/r/paulscode/garbageman-nm
- Check image tag matches in `garbageman-nm/docker-compose.yml`

### App not appearing after adding store
- Verify repository URL is correct: `https://github.com/paulscode/garbageman-nm-umbrel.git`
- Check Umbrel logs: `tail -f ~/umbrel/logs/umbrel.log`
- Restart Umbrel: `sudo systemctl restart umbrel.service`

### Properties script not working
- Ensure `properties.sh` is executable
- Verify `/data/webui-password.txt` exists in container
- Check container logs: `docker logs garbageman-nm_app_1`

### Installation fails
- Check Docker Hub is accessible from your Umbrel
- Verify sufficient disk space: `df -h`
- Check Umbrel system logs

## Support & Links

- **App Store Repository**: https://github.com/paulscode/garbageman-nm-umbrel
- **Main Project**: https://github.com/paulscode/garbageman-nm
- **Report Issues**: https://github.com/paulscode/garbageman-nm-umbrel/issues
- **Umbrel Documentation**: https://github.com/getumbrel/umbrel

## License

MIT License - see LICENSE file in the main garbageman-nm repository.
