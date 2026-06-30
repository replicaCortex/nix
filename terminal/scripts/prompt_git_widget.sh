#!/usr/bin/env bash

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    exit 0
fi

BRANCH=$(git branch --show-current 2>/dev/null)

if [ -z "$BRANCH" ]; then
    BRANCH=$(git rev-parse --short HEAD 2>/dev/null)
fi

DIRTY=""
if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
    DIRTY="*" 
fi

echo "  ${BRANCH}${DIRTY} "
