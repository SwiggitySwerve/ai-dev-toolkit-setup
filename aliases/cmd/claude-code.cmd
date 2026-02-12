@echo off
REM Claude Code Aliases for Windows CMD
REM Run this file or add to AutoRun to load aliases

DOSKEY cc=claude $*
DOSKEY ccc=claude --continue $*
DOSKEY ccr=claude --resume $*
DOSKEY ccp=claude --print $*
DOSKEY ccd=claude doctor $*
DOSKEY ccv=claude --version
DOSKEY ccmod=claude --model $*
DOSKEY cchelp=claude --help
DOSKEY ccup=npm update -g @anthropic-ai/claude-code
