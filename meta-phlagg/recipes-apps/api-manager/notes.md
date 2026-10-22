
1. What the SVN Repository Layout Looks Like

Your application repository should look like a clean, standard development project. It does not need any Yocto-specific configuration files.
Example Structure inside /svn/api-manager/trunk:
text
api-manager/
├── CMakeLists.txt         <-- Your standard project build configuration
├── LICENSE                <-- Needed for LIC_FILES_CHKSUM validation
├── src/
│   ├── main.cpp
│   ├── api_server.cpp
│   └── api_server.h
└── include/
    └── api_manager.h
Use code with caution.

2. What Your CMakeLists.txt Must Contain

To ensure Yocto can successfully compile and package your application for production, your CMakeLists.txt must do two things properly: link dependencies using variables and include installation rules.
Here is a standard, production-ready CMakeLists.txt template:

```cmake
cmake
cmake_minimum_required(VERSION 3.10)
project(api-manager VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 1. Look for dependencies (Yocto handles providing these cross-compiled libraries)
find_package(Threads REQUIRED)

# 2. Define your executable binary
add_executable(api-manager 
    src/main.cpp 
    src/api_server.cpp
)

target_include_directories(api-manager PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_link_libraries(api-manager PRIVATE Threads::Threads)

# 3. CRITICAL FOR YOCTO: Tell CMake where to install the final output file.
# Yocto relies on the "GNUInstallDirs" module to map to the correct production directories.
include(GNUInstallDirs)

install(TARGETS api-manager
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}  # Resolves to /usr/bin inside your image
)
```
