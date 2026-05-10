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

# 6. Build the web application
RUN pnpm run build

# 7. Tell the container which ports to open
# 3000 is for the Website, 7456 is for the MCP bridge to your IDE
EXPOSE 3000 7456 4096

# 8. Start the engine
# This launches the Open Design interface
CMD ["pnpm", "run", "start"]
