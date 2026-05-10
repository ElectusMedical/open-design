# Use the latest Node.js version as the base
FROM node:22-bookworm

# 1. Install system tools needed for building software
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# 2. Install OpenCode CLI globally so the design tool can "see" it
# This makes 'opencode' a command the system understands
RUN npm install -g opencode-ai

# 3. Set the working directory inside the container
WORKDIR /app

# 4. Copy the files from your GitHub fork into the container
COPY . .

# 5. Install the Design Tool's specific requirements
# We use pnpm because it's faster and what this project prefers
RUN npm install -g pnpm && pnpm install

# 6. Skip the build (not needed for this repo) 
# and go straight to exposing ports
EXPOSE 3000 7456 4096

# 7. Start the daemon and web interface
# We use 'dev' because this repo is designed as a live-environment tool
CMD ["pnpm", "run", "dev"]
