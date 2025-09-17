set -e

read -rp "name project: " PROJECT_NAME

if [ ! -f CMakeLists.txt ]; then
  cat >>CMakeLists.txt <<EOF
cmake_minimum_required(VERSION 3.20)

project(${PROJECT_NAME})

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# include(FetchContent)

# FetchContent_Declare(
# name
# GIT_REPOSITORY https://github.com/
# )

# set(BUILD_SHARED_LIBS OFF CACHE BOOL "Build shared libraries" FORCE)
# set(BUILD_EXAMPLES OFF CACHE BOOL "Build examples" FORCE)

# FetchContent_MakeAvailable(name)

file(GLOB SRC "src/*.cc")

add_executable(${PROJECT_NAME} \${SRC})

# target_link_libraries(${PROJECT_NAME} PRIVATE name)
EOF
fi

if [ ! -f shell.nix ]; then
  cat >>shell.nix <<EOF
{
  pkgs ? import <nixpkgs> {},
  mode ? "dev",
}: let
  packgs = with pkgs; [
    cmake
    gcc
    gnumake
  ];
in
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      packgs
    ];

    shellHook =
      if mode != "cmake"
      then ''
      ''
      else ''

        alias m="make && ./${PROJECT_NAME} && mv ./compile_commands.json .."
        alias g="gdb -tui ${PROJECT_NAME}"

        alias c="cmake .."
        alias nvc="nv ../CMakeLists.txt"
        alias nvs="nv ../shell.nix"
      '';
  }
EOF
fi

mkdir src
mkdir build

# --- Clangd ---

if [ ! -f .clangd ]; then
  cat >>.clangd <<EOF
CompileFlags:
  Add: [-xc++, -std=c++20, -W*, -pedantic ]
  # Add: [-xc, -std=c23, -W*, -pedantic ]

Diagnostics:
  ClangTidy:
    MissingIncludes: Strict
    Add: [ clang-diagnostic-*, clang-analyzer-*, readability-*, modernize-*, bugprone-*, misc-*, performance-*, cppcoreguidelines-*, cert-*, google-* ]

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

if [ "${quarto,,}" == "y" ] || [ "${quarto,,}" == "yes" ]; then
  mkdir report
  cd report

  QSETUP_PATH=$(find "$HOME/nix" -name "qsetup.sh" -type f | head -n 1)
  "$QSETUP_PATH"
fi
