# 1. Use Node 24 (The only version this repo supports)
FROM node:24-bookworm

# 2. Install system tools needed for building
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# 3. Install the brains: OpenCode, Claude, Gemini, and the OpenAI official CLI
RUN npm install -g pnpm opencode-ai @anthropic-ai/claude-code @google/gemini-cli openai

# 4. Set working directory
WORKDIR /app

# 5. Copy all files from GitHub
COPY . .

# 6. Install project dependencies
RUN pnpm install

# 7. EXPOSE PORTS (The ones you specified)
EXPOSE 3000 7456 4096

# 8. Start both the Daemon and the Web Dashboard concurrently
# tools-dev handles orchestrating the background processes.
CMD pnpm --filter @open-design/daemon dev & pnpm --filter @open-design/web dev & wait
