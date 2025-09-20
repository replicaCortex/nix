set -e

read -rp "name project: " PROJECT_NAME
if [ -z "$PROJECT_NAME" ]; then
  exit 1
fi

if [ ! -f CMakeLists.txt ]; then
  read -rp "pybind11?(y/n): " PYBIND

  if [ "$PYBIND" == "y" ] || [ "$PYBIND" == "yes" ]; then

    cat >>CMakeLists.txt <<EOF
cmake_minimum_required(VERSION 3.20)

project(${PROJECT_NAME})

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_SCAN_FOR_MODULES OFF)

# include(FetchContent)

# FetchContent_Declare(
# name
# GIT_REPOSITORY https://github.com/
# )

# set(BUILD_SHARED_LIBS OFF CACHE BOOL "Build shared libraries" FORCE)
# set(BUILD_EXAMPLES OFF CACHE BOOL "Build examples" FORCE)

# FetchContent_MakeAvailable(name)

file(GLOB SRC "src/*.cc")

find_package(pybind11 REQUIRED)

pybind11_add_module(${PROJECT_NAME} \${SRC})

target_link_options(${PROJECT_NAME} PRIVATE "-flto=auto")
target_compile_options(${PROJECT_NAME} PRIVATE "-flto")
EOF
  else
    cat >>CMakeLists.txt <<EOF
cmake_minimum_required(VERSION 3.20)

project(${PROJECT_NAME})

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_SCAN_FOR_MODULES OFF)

# include(FetchContent)

# FetchContent_Declare(
# name
# GIT_REPOSITORY https://github.com/
# )

# set(BUILD_SHARED_LIBS OFF CACHE BOOL "Build shared libraries" FORCE)
# set(BUILD_EXAMPLES OFF CACHE BOOL "Build examples" FORCE)

# FetchContent_MakeAvailable(name)

file(GLOB SRC "src/*.cc")

find_package(pybind11 REQUIRED)

pybind11_add_module(${PROJECT_NAME} \${SRC})

target_link_options(${PROJECT_NAME} PRIVATE "-flto=auto")
target_compile_options(${PROJECT_NAME} PRIVATE "-flto")
EOF
  fi
fi

read -rp "name python project: " PYPROJECT_NAME

if [ ! -f shell.nix ]; then
  if [ "$PYBIND" == "y" ] || [ "$PYBIND" == "yes" ]; then

    mkdir "${PYPROJECT_NAME}"
    cat >>shell.nix <<EOF
{
  pkgs ? import <nixpkgs> {},
  mode ? "dev",
}: let
  python-with-packages = pkgs.python312.withPackages (ps: [
    ps.pybind11
  ]);

  packgs = with pkgs; [
    cmake
    gcc
    ninja
    python-with-packages
  ];
in
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      packgs
    ];

    shellHook =
      if mode == "cmake"
      then ''
        alias m="ninja && mv *.so ../${PYPROJECT_NAME}/ && mv ./compile_commands.json .. 2>/dev/null"
        alias g="gdb -tui ${PROJECT_NAME}"

        alias c="cmake -G "Ninja" .."
        alias nvc="nv ../CMakeLists.txt"
        alias nvs="nv ../shell.nix"
      ''
      else '''';
  }
EOF
  else
    cat >>shell.nix <<EOF
{
  pkgs ? import <nixpkgs> {},
  mode ? "dev",
}: let
  packgs = with pkgs; [
    cmake
    gcc
    ninja
    gdb
  ];
in
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      packgs
    ];

    shellHook =
      if mode == "cmake"
      then ''
        alias m="ninja && ./${PROJECT_NAME}"
        alias g="gdb -tui ${PROJECT_NAME}"

        alias c="cmake -G "Ninja" .. && mv ./compile_commands.json .. 2>/dev/null"
        alias nvc="nv ../CMakeLists.txt"
        alias nvs="nv ../shell.nix"
      ''
      else '''';
  }
EOF
    EOF
  fi
fi

mkdir src
mkdir build

# --- git ---

git init -q
git branch -m main -q

if [ ! -f .gitignore ]; then
  cat >>.gitignore <<EOF
.cache
build
EOF
fi

git add .
git commit -m "init commit" -q

# --- clangd ---

if [ ! -f .clangd ]; then
  cat >>.clangd <<EOF
CompileFlags:
  Add: [-xc++, -std=c++20, -W*, -pedantic]
  # Add: [-xc, -std=c23, -W*, -pedantic ]

Diagnostics:
  ClangTidy:
    MissingIncludes: Strict
    Add:
      [
        clang-diagnostic-*,
        clang-analyzer-*,
        readability-*,
        modernize-*,
        bugprone-*,
        misc-*,
        performance-*,
        cppcoreguidelines-*,
        cert-*,
        google-*,
      ]

Completion:
  AllScopes: Yes
  ArgumentLists: FullPlaceholders
  HeaderInsertion: IWYU
  CodePatterns: All
EOF
fi

if [ ! -f .clang-format ]; then
  cat >>.clang-format <<EOF
# Google C/C++ Code Style settings

Language: Cpp
BasedOnStyle: Google
EOF
fi

if [ ! -f .clang-tidy ]; then
  cat >>.clang-tidy <<EOF
CheckOptions:
  readability-identifier-naming.ClassMemberCase: lower_case
  readability-identifier-naming.ClassMemberSuffix: '_'
  readability-identifier-naming.ClassConstantCase: CamelCase
  readability-identifier-naming.ClassConstantPrefix: 'k'
  readability-identifier-naming.FunctionCase: CamelCase
  readability-identifier-naming.ClassMethodCase: CamelCase
  readability-identifier-naming.LocalVariableCase: lower_case
  readability-identifier-naming.ParameterCase: lower_case
  readability-identifier-naming.GlobalConstantCase: CamelCase
  readability-identifier-naming.GlobalConstantPrefix: 'k'
  readability-identifier-naming.ClassCase: CamelCase
  readability-identifier-naming.StructCase: CamelCase
  readability-identifier-naming.TypeAliasCase: CamelCase
  readability-identifier-naming.EnumConstantCase: CamelCase
  readability-identifier-naming.EnumConstantPrefix: 'k'
EOF
fi

# --- quarto ---

read -rp "quarto?(y/n): " quarto

if [ -n "$quarto" ]; then
  submodel=true
fi

if [ "${quarto,,}" == "y" ] || [ "${quarto,,}" == "yes" ]; then
  mkdir -p report
  cd report

  QSETUP_PATH=$(find "$HOME/nix" -name "qsetup.sh" -type f | head -n 1)
  "$QSETUP_PATH" "$submodel"
fi
