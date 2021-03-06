

#### Inputs



#### Libraries

qt_find_package(ZLIB PROVIDED_TARGETS ZLIB::ZLIB)
qt_find_package(ZSTD PROVIDED_TARGETS ZSTD::ZSTD)
qt_find_package(WrapDBus1 PROVIDED_TARGETS dbus-1)
qt_find_package(Libudev PROVIDED_TARGETS PkgConfig::Libudev)


#### Tests

# cxx14
qt_config_compile_test(cxx14
    LABEL "C++14 support"
    CODE
"#if __cplusplus > 201103L
// Compiler claims to support C++14, trust it
#else
#  error __cplusplus must be > 201103L (the value of C++11)
#endif


int main(int argc, char **argv)
{
    (void)argc; (void)argv;
    /* BEGIN TEST: */

    /* END TEST: */
    return 0;
}
"
    CXX_STANDARD 14
)

# cxx17
qt_config_compile_test(cxx17
    LABEL "C++17 support"
    CODE
"#if __cplusplus > 201402L
// Compiler claims to support C++17, trust it
#else
#  error __cplusplus must be > 201402L (the value for C++14)
#endif
#include <map>  // https://bugs.llvm.org//show_bug.cgi?id=33117
#include <variant>


int main(int argc, char **argv)
{
    (void)argc; (void)argv;
    /* BEGIN TEST: */
std::variant<int> v(42);
int i = std::get<int>(v);
std::visit([](const auto &) { return 1; }, v);
    /* END TEST: */
    return 0;
}
"
    CXX_STANDARD 17
)

# cxx2a
qt_config_compile_test(cxx2a
    LABEL "C++2a support"
    CODE
"#if __cplusplus > 201703L
// Compiler claims to support experimental C++2a, trust it
#else
#  error __cplusplus must be > 201703L (the value for C++17)
#endif


int main(int argc, char **argv)
{
    (void)argc; (void)argv;
    /* BEGIN TEST: */

    /* END TEST: */
    return 0;
}
"
    CXX_STANDARD 20
)

# precompile_header
qt_config_compile_test(precompile_header
    LABEL "precompiled header support"
    CODE
"

#ifndef HEADER_H
#error no go
#endif
int main(int argc, char **argv)
{
    (void)argc; (void)argv;
    /* BEGIN TEST: */

    /* END TEST: */
    return 0;
}
"# FIXME: qmake: ['CONFIG += precompile_header', 'PRECOMPILED_DIR = .pch', 'PRECOMPILED_HEADER = header.h']
)

# reduce_relocations
qt_config_compile_test(reduce_relocations
    LABEL "-Bsymbolic-functions support"
    CODE
"#if !(defined(__i386) || defined(__i386__) || defined(__x86_64) || defined(__x86_64__) || defined(__amd64))
#  error Symbolic function binding on this architecture may be broken, disabling it (see QTBUG-36129).
#endif


int main(int argc, char **argv)
{
    (void)argc; (void)argv;
    /* BEGIN TEST: */

    /* END TEST: */
    return 0;
}
"# FIXME: qmake: ['TEMPLATE = lib', 'CONFIG += dll bsymbolic_functions', 'isEmpty(QMAKE_LFLAGS_BSYMBOLIC_FUNC): error("Nope")']
)


qt_config_compile_test("separate_debug_info"
                   LABEL "separate debug information support"
                   PROJECT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/config.tests/separate_debug_info")
# signaling_nan
qt_config_compile_test(signaling_nan
    LABEL "Signaling NaN for doubles"
    CODE
"#include <limits>


int main(int argc, char **argv)
{
    (void)argc; (void)argv;
    /* BEGIN TEST: */
using B = std::numeric_limits<double>;
static_assert(B::has_signaling_NaN, \"System lacks signaling NaN\");
    /* END TEST: */
    return 0;
}
")

# sse2
qt_config_compile_test_x86simd(sse2 "SSE2 instructions")

# sse3
qt_config_compile_test_x86simd(sse3 "SSE3 instructions")

# ssse3
qt_config_compile_test_x86simd(ssse3 "SSSE3 instructions")

# sse4_1
qt_config_compile_test_x86simd(sse4_1 "SSE4.1 instructions")

# sse4_2
qt_config_compile_test_x86simd(sse4_2 "SSE4.2 instructions")

# aesni
qt_config_compile_test_x86simd(aesni "AES new instructions")

# f16c
qt_config_compile_test_x86simd(f16c "F16C instructions")

# rdrnd
qt_config_compile_test_x86simd(rdrnd "RDRAND instruction")

# rdseed
qt_config_compile_test_x86simd(rdseed "RDSEED instruction")

# shani
qt_config_compile_test_x86simd(shani "SHA new instructions")

# avx
qt_config_compile_test_x86simd(avx "AVX instructions")

# avx2
qt_config_compile_test_x86simd(avx2 "AVX2 instructions")

# avx512f
qt_config_compile_test_x86simd(avx512f "AVX512 F instructions")

# avx512er
qt_config_compile_test_x86simd(avx512er "AVX512 ER instructions")

# avx512cd
qt_config_compile_test_x86simd(avx512cd "AVX512 CD instructions")

# avx512pf
qt_config_compile_test_x86simd(avx512pf "AVX512 PF instructions")

# avx512dq
qt_config_compile_test_x86simd(avx512dq "AVX512 DQ instructions")

# avx512bw
qt_config_compile_test_x86simd(avx512bw "AVX512 BW instructions")

# avx512vl
qt_config_compile_test_x86simd(avx512vl "AVX512 VL instructions")

# avx512ifma
qt_config_compile_test_x86simd(avx512ifma "AVX512 IFMA instructions")

# avx512vbmi
qt_config_compile_test_x86simd(avx512vbmi "AVX512 VBMI instructions")

# posix_fallocate
qt_config_compile_test(posix_fallocate
    LABEL "POSIX fallocate()"
    CODE
"
#include <fcntl.h>
#include <unistd.h>

int main(int argc, char **argv)
{
    (void)argc; (void)argv;
    /* BEGIN TEST: */
(void) posix_fallocate(0, 0, 0);
    /* END TEST: */
    return 0;
}
")

# alloca_stdlib_h
qt_config_compile_test(alloca_stdlib_h
    LABEL "alloca() in stdlib.h"
    CODE
"
#include <stdlib.h>

int main(int argc, char **argv)
{
    (void)argc; (void)argv;
    /* BEGIN TEST: */
alloca(1);
    /* END TEST: */
    return 0;
}
")

# alloca_h
qt_config_compile_test(alloca_h
    LABEL "alloca() in alloca.h"
    CODE
"
#include <alloca.h>
#ifdef __QNXNTO__
// extra include needed in QNX7 to define NULL for the alloca() macro
#  include <stddef.h>
#endif
int main(int argc, char **argv)
{
    (void)argc; (void)argv;
    /* BEGIN TEST: */
alloca(1);
    /* END TEST: */
    return 0;
}
")

# alloca_malloc_h
qt_config_compile_test(alloca_malloc_h
    LABEL "alloca() in malloc.h"
    CODE
"
#include <malloc.h>

int main(int argc, char **argv)
{
    (void)argc; (void)argv;
    /* BEGIN TEST: */
alloca(1);
    /* END TEST: */
    return 0;
}
")

# stack_protector
qt_config_compile_test(stack_protector
    LABEL "stack protection"
    COMPILE_OPTIONS -fstack-protector-strong
    CODE
"#ifdef __QNXNTO__
#  include <sys/neutrino.h>
#  if _NTO_VERSION < 700
#    error stack-protector not used (by default) before QNX 7.0.0.
#  endif
#endif


int main(int argc, char **argv)
{
    (void)argc; (void)argv;
    /* BEGIN TEST: */

    /* END TEST: */
    return 0;
}
")



#### Features

# This belongs into gui, but the license check needs it here already.
qt_feature("android-style-assets" PRIVATE
    LABEL "Android Style Assets"
    CONDITION ANDROID
)
qt_feature("shared" PUBLIC
    LABEL "Building shared libraries"
    AUTODETECT NOT UIKIT
    CONDITION BUILD_SHARED_LIBS
)
qt_feature_config("shared" QMAKE_PUBLIC_QT_CONFIG)
qt_feature_config("shared" QMAKE_PUBLIC_CONFIG)
qt_feature("use_bfd_linker"
    LABEL "bfd"
    AUTODETECT false
    CONDITION NOT WIN32 AND NOT INTEGRITY AND NOT WASM AND tests.use_bfd_linker OR FIXME
    ENABLE INPUT_linker STREQUAL 'bfd'
    DISABLE INPUT_linker STREQUAL 'gold' OR INPUT_linker STREQUAL 'lld'
)
qt_feature_config("use_bfd_linker" QMAKE_PRIVATE_CONFIG)
qt_feature("use_gold_linker_alias"
    AUTODETECT false
    CONDITION NOT WIN32 AND NOT INTEGRITY AND NOT WASM AND tests.use_gold_linker OR FIXME
)
qt_feature("use_lld_linker"
    LABEL "lld"
    AUTODETECT false
    CONDITION NOT WIN32 AND NOT INTEGRITY AND NOT WASM AND tests.use_lld_linker OR FIXME
    ENABLE INPUT_linker STREQUAL 'lld'
    DISABLE INPUT_linker STREQUAL 'bfd' OR INPUT_linker STREQUAL 'gold'
)
qt_feature_config("use_lld_linker" QMAKE_PRIVATE_CONFIG)
qt_feature("developer-build"
    LABEL "Developer build"
    AUTODETECT OFF
)
qt_feature("private_tests" PRIVATE
    LABEL "Developer build: private_tests"
    CONDITION QT_FEATURE_developer_build
)
qt_feature_definition("developer-build" "QT_BUILD_INTERNAL")
qt_feature_config("developer-build" QMAKE_PUBLIC_QT_CONFIG
    NAME "private_tests"
)
qt_feature("debug"
    LABEL "Build for debugging"
    AUTODETECT QT_FEATURE_developer_build OR ( WIN32 AND NOT GCC ) OR APPLE
    CONDITION CMAKE_BUILD_TYPE STREQUAL Debug OR Debug IN_LIST CMAKE_CONFIGURATION_TYPES
)
qt_feature("debug_and_release" PUBLIC
    LABEL "Compile libs in debug and release mode"
    AUTODETECT 1
    CONDITION QT_GENERATOR_IS_MULTI_CONFIG
)
qt_feature_config("debug_and_release" QMAKE_PUBLIC_QT_CONFIG)
qt_feature("force_debug_info"
    LABEL "Add debug info in release mode"
    AUTODETECT CMAKE_BUILD_TYPE STREQUAL RelWithDebInfo OR RelWithDebInfo IN_LIST CMAKE_CONFIGURATION_TYPES
)
qt_feature_config("force_debug_info" QMAKE_PRIVATE_CONFIG)
qt_feature("separate_debug_info" PUBLIC
    LABEL "Split off debug information"
    AUTODETECT OFF
    CONDITION ( QT_FEATURE_shared ) AND ( QT_FEATURE_debug OR QT_FEATURE_debug_and_release OR QT_FEATURE_force_debug_info ) AND ( APPLE OR TEST_separate_debug_info )
)
qt_feature_config("separate_debug_info" QMAKE_PUBLIC_QT_CONFIG)
qt_feature("appstore-compliant" PUBLIC
    LABEL "App store compliance"
    PURPOSE "Disables code that is not allowed in platform app stores"
    AUTODETECT UIKIT OR ANDROID OR WINRT
)
qt_feature("simulator_and_device" PUBLIC
    LABEL "Build for both simulator and device"
    CONDITION UIKIT AND NOT QT_UIKIT_SDK
)
qt_feature_config("simulator_and_device" QMAKE_PUBLIC_QT_CONFIG)
qt_feature("force_asserts" PUBLIC
    LABEL "Force assertions"
    AUTODETECT OFF
)
qt_feature("headersclean"
    LABEL "Check for clean headers"
    AUTODETECT QT_FEATURE_developer_build
    CONDITION NOT WASM
)
qt_feature_config("headersclean" QMAKE_PRIVATE_CONFIG)
qt_feature("framework" PUBLIC
    LABEL "Build Apple Frameworks"
    CONDITION APPLE AND BUILD_SHARED_LIBS AND NOT CMAKE_BUILD_TYPE STREQUAL Debug
)
qt_feature_definition("framework" "QT_MAC_FRAMEWORK_BUILD")
qt_feature_config("framework" QMAKE_PUBLIC_QT_CONFIG
    NAME "qt_framework"
)
qt_feature_config("framework" QMAKE_PUBLIC_CONFIG
    NAME "qt_framework"
)
qt_feature("largefile"
    LABEL "Large file support"
    CONDITION NOT ANDROID AND NOT INTEGRITY AND NOT WINRT AND NOT rtems
)
qt_feature_definition("largefile" "QT_LARGEFILE_SUPPORT" VALUE "64")
qt_feature_config("largefile" QMAKE_PRIVATE_CONFIG)
qt_feature("testcocoon"
    LABEL "Testcocoon support"
    AUTODETECT OFF
)
qt_feature_config("testcocoon" QMAKE_PUBLIC_CONFIG)
qt_feature("sanitize_fuzzer_no_link"
    LABEL "Fuzzer (instrumentation only)"
    PURPOSE "Adds instrumentation for fuzzing to the binaries but links to the usual main function instead of a fuzzer's."
    AUTODETECT OFF
)
qt_feature_config("sanitize_fuzzer_no_link" QMAKE_PUBLIC_CONFIG)
qt_feature("coverage_trace_pc_guard"
    LABEL "trace-pc-guard"
    AUTODETECT OFF
)
qt_feature_config("coverage_trace_pc_guard" QMAKE_PUBLIC_CONFIG)
qt_feature("coverage_source_based"
    LABEL "source-based"
    AUTODETECT OFF
)
qt_feature_config("coverage_source_based" QMAKE_PUBLIC_CONFIG)
qt_feature("coverage"
    LABEL "Code Coverage Instrumentation"
    CONDITION QT_FEATURE_coverage_trace_pc_guard OR QT_FEATURE_coverage_source_based
)
qt_feature_config("coverage" QMAKE_PUBLIC_CONFIG)
qt_feature("plugin-manifests"
    LABEL "Embed manifests in plugins"
    AUTODETECT OFF
    EMIT_IF WIN32
)
qt_feature_config("plugin-manifests" QMAKE_PUBLIC_CONFIG
    NEGATE
    NAME "no_plugin_manifest"
)
qt_feature("c++11" PUBLIC
    LABEL "C++11"
)
qt_feature_config("c++11" QMAKE_PUBLIC_QT_CONFIG)
qt_feature("c++14" PUBLIC
    LABEL "C++14"
    CONDITION QT_FEATURE_cxx11 AND TEST_cxx14
)
qt_feature_config("c++14" QMAKE_PUBLIC_QT_CONFIG)
qt_feature("c++17" PUBLIC
    LABEL "C++17"
    CONDITION QT_FEATURE_cxx14 AND TEST_cxx17
)
qt_feature_config("c++17" QMAKE_PUBLIC_QT_CONFIG)
qt_feature("c++1z" PUBLIC
    LABEL "C++17"
    CONDITION QT_FEATURE_cxx17
)
qt_feature_config("c++1z" QMAKE_PUBLIC_QT_CONFIG)
qt_feature("c++2a" PUBLIC
    LABEL "C++2a"
    AUTODETECT OFF
    CONDITION QT_FEATURE_cxx17 AND TEST_cxx2a
)
qt_feature_config("c++2a" QMAKE_PUBLIC_QT_CONFIG)
qt_feature("c89"
    LABEL "C89"
)
qt_feature("c99" PUBLIC
    LABEL "C99"
    CONDITION c_std_99 IN_LIST CMAKE_C_COMPILE_FEATURES
)
qt_feature("c11" PUBLIC
    LABEL "C11"
    CONDITION QT_FEATURE_c99 AND c_std_11 IN_LIST CMAKE_C_COMPILE_FEATURES
)
qt_feature("reduce_exports" PRIVATE
    LABEL "Reduce amount of exported symbols"
    CONDITION NOT WIN32 AND CMAKE_CXX_COMPILE_OPTIONS_VISIBILITY
)
qt_feature_definition("reduce_exports" "QT_VISIBILITY_AVAILABLE")
qt_feature_config("reduce_exports" QMAKE_PUBLIC_QT_CONFIG)
qt_feature("reduce_relocations" PRIVATE
    LABEL "Reduce amount of relocations"
    CONDITION NOT WIN32 AND TEST_reduce_relocations
)
qt_feature_definition("reduce_relocations" "QT_REDUCE_RELOCATIONS")
qt_feature_config("reduce_relocations" QMAKE_PUBLIC_QT_CONFIG)
qt_feature("signaling_nan" PUBLIC
    LABEL "Signaling NaN"
    CONDITION TEST_signaling_nan
)
qt_feature("sse2" PRIVATE
    LABEL "SSE2"
    CONDITION ( ( TEST_architecture_arch STREQUAL i386 ) OR ( TEST_architecture_arch STREQUAL x86_64 ) ) AND TEST_subarch_sse2
)
qt_feature_definition("sse2" "QT_COMPILER_SUPPORTS_SSE2" VALUE "1")
qt_feature_config("sse2" QMAKE_PRIVATE_CONFIG)
qt_feature("sse3"
    LABEL "SSE3"
    CONDITION QT_FEATURE_sse2 AND TEST_subarch_sse3
)
qt_feature_definition("sse3" "QT_COMPILER_SUPPORTS_SSE3" VALUE "1")
qt_feature_config("sse3" QMAKE_PRIVATE_CONFIG)
qt_feature("ssse3"
    LABEL "SSSE3"
    CONDITION QT_FEATURE_sse3 AND TEST_subarch_ssse3
)
qt_feature_definition("ssse3" "QT_COMPILER_SUPPORTS_SSSE3" VALUE "1")
qt_feature_config("ssse3" QMAKE_PRIVATE_CONFIG)
qt_feature("sse4_1"
    LABEL "SSE4.1"
    CONDITION QT_FEATURE_ssse3 AND TEST_subarch_sse4_1
)
qt_feature_definition("sse4_1" "QT_COMPILER_SUPPORTS_SSE4_1" VALUE "1")
qt_feature_config("sse4_1" QMAKE_PRIVATE_CONFIG)
qt_feature("sse4_2"
    LABEL "SSE4.2"
    CONDITION QT_FEATURE_sse4_1 AND TEST_subarch_sse4_2
)
qt_feature_definition("sse4_2" "QT_COMPILER_SUPPORTS_SSE4_2" VALUE "1")
qt_feature_config("sse4_2" QMAKE_PRIVATE_CONFIG)
qt_feature("avx"
    LABEL "AVX"
    CONDITION QT_FEATURE_sse4_2 AND TEST_subarch_avx
)
qt_feature_definition("avx" "QT_COMPILER_SUPPORTS_AVX" VALUE "1")
qt_feature_config("avx" QMAKE_PRIVATE_CONFIG)
qt_feature("f16c"
    LABEL "F16C"
    CONDITION QT_FEATURE_avx AND TEST_subarch_f16c
)
qt_feature_definition("f16c" "QT_COMPILER_SUPPORTS_F16C" VALUE "1")
qt_feature_config("f16c" QMAKE_PRIVATE_CONFIG)
qt_feature("avx2" PRIVATE
    LABEL "AVX2"
    CONDITION QT_FEATURE_avx AND TEST_subarch_avx2
)
qt_feature_definition("avx2" "QT_COMPILER_SUPPORTS_AVX2" VALUE "1")
qt_feature_config("avx2" QMAKE_PRIVATE_CONFIG)
qt_feature("avx512f"
    LABEL "F"
    CONDITION QT_FEATURE_avx2 AND TEST_subarch_avx512f
)
qt_feature_definition("avx512f" "QT_COMPILER_SUPPORTS_AVX512F" VALUE "1")
qt_feature_config("avx512f" QMAKE_PRIVATE_CONFIG)
qt_feature("avx512er"
    LABEL "ER"
    CONDITION QT_FEATURE_avx512f AND TEST_subarch_avx512er
)
qt_feature_definition("avx512er" "QT_COMPILER_SUPPORTS_AVX512ER" VALUE "1")
qt_feature_config("avx512er" QMAKE_PRIVATE_CONFIG)
qt_feature("avx512cd"
    LABEL "CD"
    CONDITION QT_FEATURE_avx512f AND TEST_subarch_avx512cd
)
qt_feature_definition("avx512cd" "QT_COMPILER_SUPPORTS_AVX512CD" VALUE "1")
qt_feature_config("avx512cd" QMAKE_PRIVATE_CONFIG)
qt_feature("avx512pf"
    LABEL "PF"
    CONDITION QT_FEATURE_avx512f AND TEST_subarch_avx512pf
)
qt_feature_definition("avx512pf" "QT_COMPILER_SUPPORTS_AVX512PF" VALUE "1")
qt_feature_config("avx512pf" QMAKE_PRIVATE_CONFIG)
qt_feature("avx512dq"
    LABEL "DQ"
    CONDITION QT_FEATURE_avx512f AND TEST_subarch_avx512dq
)
qt_feature_definition("avx512dq" "QT_COMPILER_SUPPORTS_AVX512DQ" VALUE "1")
qt_feature_config("avx512dq" QMAKE_PRIVATE_CONFIG)
qt_feature("avx512bw"
    LABEL "BW"
    CONDITION QT_FEATURE_avx512f AND TEST_subarch_avx512bw
)
qt_feature_definition("avx512bw" "QT_COMPILER_SUPPORTS_AVX512BW" VALUE "1")
qt_feature_config("avx512bw" QMAKE_PRIVATE_CONFIG)
qt_feature("avx512vl"
    LABEL "VL"
    CONDITION QT_FEATURE_avx512f AND TEST_subarch_avx512vl
)
qt_feature_definition("avx512vl" "QT_COMPILER_SUPPORTS_AVX512VL" VALUE "1")
qt_feature_config("avx512vl" QMAKE_PRIVATE_CONFIG)
qt_feature("avx512ifma"
    LABEL "IFMA"
    CONDITION QT_FEATURE_avx512f AND TEST_subarch_avx512ifma
)
qt_feature_definition("avx512ifma" "QT_COMPILER_SUPPORTS_AVX512IFMA" VALUE "1")
qt_feature_config("avx512ifma" QMAKE_PRIVATE_CONFIG)
qt_feature("avx512vbmi"
    LABEL "VBMI"
    CONDITION QT_FEATURE_avx512f AND TEST_subarch_avx512vbmi
)
qt_feature_definition("avx512vbmi" "QT_COMPILER_SUPPORTS_AVX512VBMI" VALUE "1")
qt_feature_config("avx512vbmi" QMAKE_PRIVATE_CONFIG)
qt_feature("aesni"
    LABEL "AES"
    CONDITION QT_FEATURE_sse2 AND TEST_subarch_aes
)
qt_feature_definition("aesni" "QT_COMPILER_SUPPORTS_AES" VALUE "1")
qt_feature_config("aesni" QMAKE_PRIVATE_CONFIG)
qt_feature("rdrnd"
    LABEL "RDRAND"
    CONDITION TEST_subarch_rdseed
)
qt_feature_definition("rdrnd" "QT_COMPILER_SUPPORTS_RDRND" VALUE "1")
qt_feature_config("rdrnd" QMAKE_PRIVATE_CONFIG)
qt_feature("rdseed"
    LABEL "RDSEED"
    CONDITION TEST_subarch_rdseed
)
qt_feature_definition("rdseed" "QT_COMPILER_SUPPORTS_RDSEED" VALUE "1")
qt_feature_config("rdseed" QMAKE_PRIVATE_CONFIG)
qt_feature("shani"
    LABEL "SHA"
    CONDITION QT_FEATURE_sse2 AND TEST_subarch_sha
)
qt_feature_definition("shani" "QT_COMPILER_SUPPORTS_SHA" VALUE "1")
qt_feature_config("shani" QMAKE_PRIVATE_CONFIG)
qt_feature("x86SimdAlways"
    LABEL "Intrinsics without -mXXX option"
    CONDITION ( ( TEST_architecture_arch STREQUAL i386 ) OR ( TEST_architecture_arch STREQUAL x86_64 ) ) AND ON
)
qt_feature_definition("x86SimdAlways" "QT_COMPILER_SUPPORTS_SIMD_ALWAYS" VALUE "1")
qt_feature_config("x86SimdAlways" QMAKE_PRIVATE_CONFIG)
qt_feature("mips_dsp"
    LABEL "DSP"
    CONDITION ( TEST_architecture_arch STREQUAL mips ) AND TEST_arch_${TEST_architecture_arch}_subarch_dsp
)
qt_feature_definition("mips_dsp" "QT_COMPILER_SUPPORTS_MIPS_DSP" VALUE "1")
qt_feature_config("mips_dsp" QMAKE_PRIVATE_CONFIG)
qt_feature("mips_dspr2"
    LABEL "DSPr2"
    CONDITION ( TEST_architecture_arch STREQUAL mips ) AND TEST_arch_${TEST_architecture_arch}_subarch_dspr2
)
qt_feature_definition("mips_dspr2" "QT_COMPILER_SUPPORTS_MIPS_DSPR2" VALUE "1")
qt_feature_config("mips_dspr2" QMAKE_PRIVATE_CONFIG)
qt_feature("neon"
    LABEL "NEON"
    CONDITION ( ( TEST_architecture_arch STREQUAL arm ) OR ( TEST_architecture_arch STREQUAL arm64 ) ) AND TEST_arch_${TEST_architecture_arch}_subarch_neon
)
qt_feature_definition("neon" "QT_COMPILER_SUPPORTS_NEON" VALUE "1")
qt_feature_config("neon" QMAKE_PRIVATE_CONFIG)
qt_feature("posix_fallocate" PRIVATE
    LABEL "POSIX fallocate()"
    CONDITION TEST_posix_fallocate
)
qt_feature("alloca_h" PRIVATE
    LABEL "alloca.h"
    CONDITION TEST_alloca_h
)
qt_feature("alloca_malloc_h" PRIVATE
    LABEL "alloca() in malloc.h"
    CONDITION NOT QT_FEATURE_alloca_h AND TEST_alloca_malloc_h
)
qt_feature("alloca" PRIVATE
    LABEL "alloca()"
    CONDITION QT_FEATURE_alloca_h OR QT_FEATURE_alloca_malloc_h OR TEST_alloca_stdlib_h
)
qt_feature("stack-protector-strong" PRIVATE
    LABEL "stack protection"
    CONDITION QNX AND TEST_stack_protector
)
qt_feature("system-zlib" PRIVATE
    LABEL "Using system zlib"
    CONDITION ZLIB_FOUND
)
qt_feature("zstd" PRIVATE
    LABEL "Zstandard support"
    CONDITION ZSTD_FOUND
)
qt_feature("thread" PUBLIC
    SECTION "Kernel"
    LABEL "Thread support"
    PURPOSE "Provides QThread and related classes."
    AUTODETECT NOT WASM
)
qt_feature("future" PUBLIC
    SECTION "Kernel"
    LABEL "QFuture"
    PURPOSE "Provides QFuture and related classes."
    CONDITION QT_FEATURE_thread
)
qt_feature("concurrent" PUBLIC
    SECTION "Kernel"
    LABEL "Qt Concurrent"
    PURPOSE "Provides a high-level multi-threading API."
    CONDITION QT_FEATURE_future
)
qt_feature_definition("concurrent" "QT_NO_CONCURRENT" NEGATE VALUE "1")
qt_feature("dbus" PUBLIC PRIVATE
    LABEL "Qt D-Bus"
    AUTODETECT NOT UIKIT AND NOT ANDROID AND NOT WINRT
    CONDITION QT_FEATURE_thread
)
qt_feature_definition("dbus" "QT_NO_DBUS" NEGATE VALUE "1")
qt_feature("dbus-linked" PRIVATE
    LABEL "Qt D-Bus directly linked to libdbus"
    CONDITION QT_FEATURE_dbus AND DBus1_FOUND
    ENABLE INPUT_dbus STREQUAL 'linked'
    DISABLE INPUT_dbus STREQUAL 'runtime'
)
qt_feature("gui" PRIVATE
    LABEL "Qt Gui"
)
qt_feature_config("gui" QMAKE_PUBLIC_QT_CONFIG
    NEGATE)
qt_feature("network" PRIVATE
    LABEL "Qt Network"
)
qt_feature("sql" PRIVATE
    LABEL "Qt Sql"
    CONDITION QT_FEATURE_thread
)
qt_feature("testlib" PRIVATE
    LABEL "Qt Testlib"
)
qt_feature("widgets" PRIVATE
    LABEL "Qt Widgets"
    AUTODETECT NOT TVOS AND NOT WATCHOS
    CONDITION QT_FEATURE_gui
)
qt_feature_definition("widgets" "QT_NO_WIDGETS" NEGATE)
qt_feature_config("widgets" QMAKE_PUBLIC_QT_CONFIG
    NEGATE)
qt_feature("xml" PRIVATE
    LABEL "Qt Xml"
)
qt_feature("libudev" PRIVATE
    LABEL "udev"
    CONDITION Libudev_FOUND
)
qt_feature("qt_libinfix_plugins"
    LABEL "Use QT_LIBINFIX for Plugins"
    AUTODETECT OFF
    ENABLE ( NOT INPUT_qt_libinfix STREQUAL '' ) AND INPUT_qt_libinfix_plugins STREQUAL 'yes'
)
qt_feature_config("qt_libinfix_plugins" QMAKE_PRIVATE_CONFIG)
qt_feature("compile_examples"
    LABEL "Compile examples"
    AUTODETECT NOT WASM
)
qt_feature_config("compile_examples" QMAKE_PRIVATE_CONFIG)
qt_feature("dlopen" PRIVATE
    LABEL "dlopen()"
    CONDITION UNIX
)
qt_feature("relocatable" PRIVATE
    LABEL "Relocatable"
    PURPOSE "Enable the Qt installation to be relocated."
    AUTODETECT QT_FEATURE_shared
    CONDITION QT_FEATURE_dlopen OR WIN32 OR NOT QT_FEATURE_shared
)
qt_configure_add_summary_build_type_and_config()
qt_configure_add_summary_section(NAME "Build options")
qt_configure_add_summary_build_mode(Mode)
qt_configure_add_summary_entry(
    ARGS "optimize_debug"
    CONDITION NOT MSVC AND NOT CLANG AND ( QT_FEATURE_debug OR QT_FEATURE_debug_and_release )
)
qt_configure_add_summary_entry(
    ARGS "optimize_size"
    CONDITION NOT QT_FEATURE_debug OR QT_FEATURE_debug_and_release
)
qt_configure_add_summary_entry(ARGS "shared")
qt_configure_add_summary_entry(
    TYPE "firstAvailableFeature"
    ARGS "c11 c99 c89"
    MESSAGE "Using C standard"
)
qt_configure_add_summary_entry(
    TYPE "firstAvailableFeature"
    ARGS "c++2a c++17 c++14 c++11"
    MESSAGE "Using C++ standard"
)
qt_configure_add_summary_entry(
    ARGS "ccache"
    CONDITION UNIX
)
qt_configure_add_summary_entry(
    ARGS "enable_new_dtags"
    CONDITION LINUX
)
qt_configure_add_summary_entry(
    ARGS "enable_gdb_index"
    CONDITION GCC AND NOT CLANG AND ( QT_FEATURE_debug OR QT_FEATURE_force_debug_info OR QT_FEATURE_debug_and_release )
)
qt_configure_add_summary_entry(ARGS "relocatable")
qt_configure_add_summary_entry(ARGS "precompile_header")
qt_configure_add_summary_entry(ARGS "ltcg")
qt_configure_add_summary_section(NAME "Target compiler supports")
qt_configure_add_summary_entry(
    TYPE "featureList"
    ARGS "sse2 sse3 ssse3 sse4_1 sse4_2"
    MESSAGE "SSE"
    CONDITION ( ( TEST_architecture_arch STREQUAL i386 ) OR ( TEST_architecture_arch STREQUAL x86_64 ) )
)
qt_configure_add_summary_entry(
    TYPE "featureList"
    ARGS "avx avx2"
    MESSAGE "AVX"
    CONDITION ( ( TEST_architecture_arch STREQUAL i386 ) OR ( TEST_architecture_arch STREQUAL x86_64 ) )
)
qt_configure_add_summary_entry(
    TYPE "featureList"
    ARGS "avx512f avx512er avx512cd avx512pf avx512dq avx512bw avx512vl avx512ifma avx512vbmi"
    MESSAGE "AVX512"
    CONDITION ( ( TEST_architecture_arch STREQUAL i386 ) OR ( TEST_architecture_arch STREQUAL x86_64 ) )
)
qt_configure_add_summary_entry(
    TYPE "featureList"
    ARGS "aesni f16c rdrnd shani"
    MESSAGE "Other x86"
    CONDITION ( ( TEST_architecture_arch STREQUAL i386 ) OR ( TEST_architecture_arch STREQUAL x86_64 ) )
)
qt_configure_add_summary_entry(
    ARGS "x86SimdAlways"
    CONDITION ( ( TEST_architecture_arch STREQUAL i386 ) OR ( TEST_architecture_arch STREQUAL x86_64 ) ) AND NOT MSVC
)
qt_configure_add_summary_entry(
    ARGS "neon"
    CONDITION ( TEST_architecture_arch STREQUAL arm ) OR ( TEST_architecture_arch STREQUAL arm64 )
)
qt_configure_add_summary_entry(
    ARGS "mips_dsp"
    CONDITION ( TEST_architecture_arch STREQUAL mips )
)
qt_configure_add_summary_entry(
    ARGS "mips_dspr2"
    CONDITION ( TEST_architecture_arch STREQUAL mips )
)
qt_configure_end_summary_section() # end of "Target compiler supports" section
qt_configure_add_summary_section(NAME "Sanitizers")
qt_configure_add_summary_entry(ARGS "sanitize_address")
qt_configure_add_summary_entry(ARGS "sanitize_thread")
qt_configure_add_summary_entry(ARGS "sanitize_memory")
qt_configure_add_summary_entry(ARGS "sanitize_fuzzer_no_link")
qt_configure_add_summary_entry(ARGS "sanitize_undefined")
qt_configure_end_summary_section() # end of "Sanitizers" section
qt_configure_add_summary_entry(
    TYPE "firstAvailableFeature"
    ARGS "coverage_trace_pc_guard coverage_source_based"
    MESSAGE "Code Coverage Instrumentation"
    CONDITION QT_FEATURE_coverage
)
qt_configure_add_summary_entry(
    ARGS "appstore-compliant"
    CONDITION APPLE OR ANDROID OR WINRT OR WIN32
)
qt_configure_end_summary_section() # end of "Build options" section
qt_configure_add_summary_section(NAME "Qt modules and options")
qt_configure_add_summary_entry(ARGS "concurrent")
qt_configure_add_summary_entry(ARGS "dbus")
qt_configure_add_summary_entry(ARGS "dbus-linked")
qt_configure_add_summary_entry(ARGS "gui")
qt_configure_add_summary_entry(ARGS "network")
qt_configure_add_summary_entry(ARGS "sql")
qt_configure_add_summary_entry(ARGS "testlib")
qt_configure_add_summary_entry(ARGS "widgets")
qt_configure_add_summary_entry(ARGS "xml")
qt_configure_end_summary_section() # end of "Qt modules and options" section
qt_configure_add_summary_section(NAME "Support enabled for")
qt_configure_add_summary_entry(ARGS "pkg-config")
qt_configure_add_summary_entry(ARGS "libudev")
qt_configure_add_summary_entry(ARGS "system-zlib")
qt_configure_add_summary_entry(ARGS "zstd")
qt_configure_end_summary_section() # end of "Support enabled for" section
qt_configure_add_report_entry(
    TYPE NOTE
    MESSAGE "Using static linking will disable the use of dynamically loaded plugins. Make sure to import all needed static plugins, or compile needed modules into the library."
    CONDITION NOT QT_FEATURE_shared
)
qt_configure_add_report_entry(
    TYPE NOTE
    MESSAGE "Qt is using double for qreal on this system. This is binary-incompatible against Qt 5.1.  Configure with '-qreal float' to create a build that is binary-compatible with 5.1."
    CONDITION INPUT_qreal STREQUAL 'double' AND ( TEST_architecture_arch STREQUAL arm )
)
qt_configure_add_report_entry(
    TYPE ERROR
    MESSAGE "Debug build wihtout Release build is not currently supported on ios see QTBUG-71990. Use -debug-and-release."
    CONDITION IOS AND QT_FEATURE_debug AND NOT QT_FEATURE_debug_and_release
)
qt_configure_add_report_entry(
    TYPE WARNING
    MESSAGE "-debug-and-release is only supported on Darwin and Windows platforms.  Qt can be built in release mode with separate debug information, so -debug-and-release is no longer necessary."
    CONDITION INPUT_debug_and_release STREQUAL 'yes' AND NOT APPLE AND NOT WIN32
)
qt_configure_add_report_entry(
    TYPE ERROR
    MESSAGE "debug-only framework builds are not supported. Configure with -no-framework if you want a pure debug build."
    CONDITION QT_FEATURE_framework AND QT_FEATURE_debug AND NOT QT_FEATURE_debug_and_release
)
qt_configure_add_report_entry(
    TYPE ERROR
    MESSAGE "Command line option -coverage is only supported with clang compilers."
    CONDITION QT_FEATURE_coverage AND NOT CLANG
)
qt_configure_add_report_entry(
    TYPE ERROR
    MESSAGE "Command line option -sanitize fuzzer-no-link is only supported with clang compilers."
    CONDITION QT_FEATURE_sanitize_fuzzer_no_link AND NOT CLANG
)

qt_extra_definition("QT_VERSION_STR" "\"${PROJECT_VERSION}\"" PUBLIC)
qt_extra_definition("QT_VERSION_MAJOR" ${PROJECT_VERSION_MAJOR} PUBLIC)
qt_extra_definition("QT_VERSION_MINOR" ${PROJECT_VERSION_MINOR} PUBLIC)
qt_extra_definition("QT_VERSION_PATCH" ${PROJECT_VERSION_PATCH} PUBLIC)
