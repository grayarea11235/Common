echo "Greetings Professor Falken"

fortune

JAVA_HOME="/usr/lib/jvm/open-jdk"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="/snap/bin:$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
      # include .bashrc if it exists
          if [ -f "$HOME/.bashrc" ]; then
                . "$HOME/.bashrc"
                    fi
fi

export PATH=$PATH:/home/cpd/.local/bin:/usr/local/bin
