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

  TAG="${VERSION:-latest}"

  echo "Creating job for $file as radarr:$TAG"

  # Append job to config
  cat >> "$CONFIG_FILE" <<EOF
publish:$PKG:
  stage: publish
  image: ghcr.io/vaskozl/apko
  only:
    changes:
      - $file
  script:
    - apko login ghcr.io -u "$GHCR_USER" -p "$GHCR_PASSWORD"
    - apko publish "$file" "${REPO}${PKG}:${TAG}"
EOF
done

echo "Configuration generated in $CONFIG_FILE"
