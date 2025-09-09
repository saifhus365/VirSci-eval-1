#!/bin/bash
#SBATCH --job-name=virsci
#SBATCH --gres=gpu:ampere:1
#SBATCH --mem=32g
#SBATCH --cpus-per-task=8
#SBATCH --time=12:00:00
#SBATCH --output=logs/%j.out
#SBATCH --error=logs/%j.err
#SBATCH --container-image=ghcr.io#<USERNAME>/virsci:latest
#SBATCH --container-mounts=/path/to/data:/workspace/data

# Start Ollama server in background
ollama serve &

# Wait a bit for Ollama to be ready
sleep 10

# Pull required models once (can be cached across jobs if container is persistent)
ollama pull llama3.1
ollama pull llama3.1:70b
ollama pull mxbai-embed-large

# Run VirSci
cd sci_platform
python run.py --runs 1 --team_limit 2
