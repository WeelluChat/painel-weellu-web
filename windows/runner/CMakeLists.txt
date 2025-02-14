cmake_minimum_required(VERSION 3.14)
project(runner LANGUAGES CXX)

# Define o nome do alvo
set(BINARY_NAME MonitorWeellu)  # Defina o nome do alvo sem espaços

# Define o alvo da aplicação. Para alterar seu nome, altere BINARY_NAME no
# CMakeLists.txt superior, não o valor aqui, ou `flutter run` não funcionará mais.
#
# Qualquer novo arquivo de origem que você adicionar à aplicação deve ser adicionado aqui.
add_executable(${BINARY_NAME} WIN32
  "flutter_window.cpp"
  "main.cpp"
  "utils.cpp"
  "win32_window.cpp"
  "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
  "Runner.rc"
  "runner.exe.manifest"
)

# Aplicar o conjunto padrão de configurações de construção. Isso pode ser removido para aplicativos
# que precisam de configurações de construção diferentes.
apply_standard_settings(${BINARY_NAME})

# Adicionar definições de pré-processador para a versão de construção.
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION=\"${FLUTTER_VERSION}\"")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_MAJOR=${FLUTTER_VERSION_MAJOR}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_MINOR=${FLUTTER_VERSION_MINOR}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_PATCH=${FLUTTER_VERSION_PATCH}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_BUILD=${FLUTTER_VERSION_BUILD}")

# Desabilitar macros do Windows que colidem com funções da biblioteca padrão C++.
target_compile_definitions(${BINARY_NAME} PRIVATE "NOMINMAX")

# Adicionar bibliotecas de dependência e diretórios de inclusão. Adicione quaisquer
# dependências específicas da aplicação aqui.
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE "dwmapi.lib")
target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_SOURCE_DIR}")

# Executar as partes da construção da ferramenta Flutter. Isso não deve ser removido.
add_dependencies(${BINARY_NAME} flutter_assemble)
