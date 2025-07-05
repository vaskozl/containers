#!/bin/sh

set -e  # Exit immediately if a command exits with a non-zero status

CONFIG_FILE="generated-config.yml"

# Ensure yq is installed
if ! command -v yq >/dev/null 2>&1; then
  echo "Error: yq is not installed. Please install it and retry." >&2
  exit 1
fi

# Ensure required environment variables are set
: "${GHCR_USER:?Error: GHCR_USER is not set}"
: "${GHCR_PASSWORD:?Error: GHCR_PASSWORD is not set}"
: "${REPO:?Error: REPO is not set}"

# Initialize config file
cat > "$CONFIG_FILE" <<EOF
stages:
  - publish
EOF

# Process YAML files
for file in *.yaml; do
  [ -f "$file" ] || continue  # Skip if not a file

  # Extract package and version
  FIRST=$(yq e '.contents.packages[0]' "$file")
  IFS='=' read -r PKG VERSION <<EOF
$FIRST
EOF


  echo "Creating job for $file as $PKG:${VERSION:-latest}"

  # Append job to config
  cat >> "$CONFIG_FILE" <<EOF
publish:$PKG:
  stage: publish
  image: ghcr.io/vaskozl/apko:latest
  only:
    changes:
      - hack/generate-jobs.sh
      - $file
  variables:
    TAG: $VERSION
  script:
    - apko login ghcr.io -u "\$GHCR_USER" -p "\$GHCR_PASSWORD"
    - apko login docker.io -u "\$DOCKER_USER" -p "\$DOCKER_PASSWORD"
    - |
      IMAGES="${REPO}${PKG}:latest vszl/${PKG}:latest"
      if echo "\$TAG" | grep -qE '^v?([0-9]+[\\.\\-])+r[0-9]+';then
        # Strip version segments from right to left
        while [ -n "\$TAG" ]; do
          IMAGES="\$IMAGES ${REPO}${PKG}:\$TAG vszl/${PKG}:\$TAG"
          TAG=\$(echo \$TAG | sed -r 's/[v\\.\\-]?r?[0-9]+$//')
        done
      fi
    - apko publish --sbom=false "$file" \$IMAGES
EOF
done

echo "Configuration generated in $CONFIG_FILE"
