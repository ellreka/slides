#!/bin/bash

ls ./presentations/ | fzf | xargs -I {} pnpm -r --filter=./presentations/{} run dev