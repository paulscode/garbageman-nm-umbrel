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
├── umbrel-app-store.yml           # App store manifest
└── garbageman-nm/                 # App directory
    ├── umbrel-app.yml             # App metadata and manifest
    ├── docker-compose.yml         # Deployment config (uses Docker Hub image)
    ├── exports.sh                 # Environment variable exports
    └── properties.sh              # Script to display password in UI
```

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

1. **Build and push new Docker image:**
   ```bash
   # Build from source (see main garbageman-nm repo)
   # Then tag and push to Docker Hub:
   docker tag garbageman-nm:local paulscode/garbageman-nm:0.1.2.0
   docker push paulscode/garbageman-nm:0.1.2.0
   ```

2. **Update files in this repository:**
   - Update `version` in `garbageman-nm/umbrel-app.yml`
   - Update `image` tag in `garbageman-nm/docker-compose.yml`

3. **Commit and push to this repository:**
   ```bash
   git add .
   git commit -m "Release v0.1.2.0"
   git tag v0.1.2.0
   git push origin main --tags
   ```

4. **Users will see update available** in their Umbrel dashboard

## Screenshot Guidelines

Umbrel requires screenshot images for the app gallery. Add these to `garbageman-nm/`:

- `1.jpg` - Main dashboard view (1280x720 or 1920x1080)
- `2.jpg` - Instance management view
- `3.jpg` - Peer discovery or another feature

Screenshots should show the app's UI with realistic data.

## Technical Details

### Docker Image
This app uses pre-built Docker images from Docker Hub:
- **Image**: `paulscode/garbageman-nm`
- **Current version**: `0.1.1.0`
- **View on Docker Hub**: https://hub.docker.com/r/paulscode/garbageman-nm

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
