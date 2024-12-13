#!/bin/bash

# Archivo bashrc donde se añadirán los alias y funciones
BASHRC="$HOME/.bashrc"

# La función que quieres añadir
GIT_REMOTE_DEFAULT_FUNC=$(cat << 'EOF'
git-remote-default() {
  # Verificar si GITHUB_USER no está definida
  if [ -z "$GITHUB_USER" ]; then
    if [ -z "$GITHUB_USER" ]; then
      echo "GITHUB_USER no está definido. Introduce tu nombre de usuario de GitHub:"
      read -p "Introduce tu nombre de usuario de GitHub (GITHUB_USER): " GITHUB_USER
      export GITHUB_USER=$GITHUB_USER
      echo "La variable GITHUB_USER se ha definido como: $GITHUB_USER"
      # Guardar GITHUB_USER en .bashrc para persistir
      echo "export GITHUB_USER=\"$GITHUB_USER\"" >> ~/.bashrc
    fi
  fi

  # Verificar si GITHUB_TOKEN no está definida
  if [ -z "$GITHUB_TOKEN" ]; then
    read -sp "Introduce tu token de GitHub (GITHUB_TOKEN): " GITHUB_TOKEN
    echo
    export GITHUB_TOKEN=$GITHUB_TOKEN
    echo "La variable GITHUB_TOKEN se ha definido para esta sesión."
    # Guardar GITHUB_TOKEN en .bashrc para persistir
    echo "export GITHUB_TOKEN=\"$GITHUB_TOKEN\"" >> ~/.bashrc
  fi

  # Solicitar el nombre del repositorio
  read -p "Nombre del repositorio: " repo

  # Verificar si se ingresó un nombre de repositorio
  if [ -z "$repo" ]; then
    echo "Error: No se ha proporcionado un nombre de repositorio."
    return 1
  fi

  # Añadir la URL remota
  git remote add origin https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/${GITHUB_USER}/$repo.git
  echo "URL remota añadida para el repositorio: ${GITHUB_USER}/$repo"
}
EOF
)

# Verificar si la función ya existe en .bashrc, si no, la añadimos
if ! grep -qxF "git-remote-default()" "$BASHRC"; then
  echo "" >> "$BASHRC"  # Añade una línea en blanco antes por legibilidad
  echo "# Función para configurar un repositorio remoto de forma predeterminada" >> "$BASHRC"
  echo "$GIT_REMOTE_DEFAULT_FUNC" >> "$BASHRC"
  echo "Función 'git-remote-default' añadida a $BASHRC"
else
  echo "La función 'git-remote-default' ya existe en $BASHRC"
fi

# Recargar el archivo .bashrc para aplicar los cambios
source ~/.bashrc
echo "Los cambios se han aplicado correctamente."
