using BinaryProvider # requires BinaryProvider 0.3.0 or later

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))
products = [
    LibraryProduct(prefix, ["libCbcSolver"], :libcbcsolver),
    LibraryProduct(prefix, ["libCbc"], :libCbc),
]

# Download binaries from hosted location
bin_prefix = "https://github.com/JuliaOpt/CbcBuilder/releases/download/v2.10.3-static-mono"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/CbcBuilder.v2.10.3.aarch64-linux-gnu-gcc7.tar.gz", "5289c2d5bc0b7a2e96e9a0dab3799bdace680e2e3f255bdf056f4dcbfc9fc258"),
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/CbcBuilder.v2.10.3.aarch64-linux-gnu-gcc8.tar.gz", "fb96480813753b8421ec720fd6ac077776d09f92e5d4abfd259944ad6a5a68e8"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/CbcBuilder.v2.10.3.arm-linux-gnueabihf-gcc7.tar.gz", "481e3551bdefde9190931a33c9fafb0ddd3aefbf5c97f5a94a7429355c29af51"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/CbcBuilder.v2.10.3.arm-linux-gnueabihf-gcc8.tar.gz", "7ba8f9b910949223edfa06e9c6e7fc111fd618afe1772c230eae89f057b74588"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/CbcBuilder.v2.10.3.i686-linux-gnu-gcc4.tar.gz", "10726f8ebb8ab074305d64a19888158218eee32e7f87be743ac361bf4c0691dc"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/CbcBuilder.v2.10.3.i686-linux-gnu-gcc7.tar.gz", "f62699f277a5bb534cdbbf7aabaa7d1c9d558ba74f986db7d61c949014b65ceb"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/CbcBuilder.v2.10.3.i686-linux-gnu-gcc8.tar.gz", "543f8a4203c9764074edb8f07f5f994493dbfbea5221a84748ea28439272c085"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc6)) => ("$bin_prefix/CbcBuilder.v2.10.3.i686-w64-mingw32-gcc6.tar.gz", "ef90e9b476d177e916ed1db30850177b1ee5b1b70914900d34c7069999154c80"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/CbcBuilder.v2.10.3.i686-w64-mingw32-gcc7.tar.gz", "e45167b5a875c5ae1e571eaba79903752c29d1d40b0361687d4bd5e611964014"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/CbcBuilder.v2.10.3.i686-w64-mingw32-gcc8.tar.gz", "abfc7873bfbb703b50da509d761bc978fcd8f949af93f924b2524e18c6746296"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/CbcBuilder.v2.10.3.x86_64-apple-darwin14-gcc4.tar.gz", "7fe7cd1677f27cc506fb6b4cbf2a56a82c3729a8c40a39c40dddad4ece978543"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/CbcBuilder.v2.10.3.x86_64-apple-darwin14-gcc7.tar.gz", "5ae00ee35d4485e095293c37bd948d9d7921f4266ba1978520ec7d40d9da855c"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/CbcBuilder.v2.10.3.x86_64-apple-darwin14-gcc8.tar.gz", "4d452fa0fbfb2ef1bf2be93d66590413fe7eacd029ab67043ff3948e2d57799e"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/CbcBuilder.v2.10.3.x86_64-linux-gnu-gcc4.tar.gz", "1edf2f1b5f0517134c1d2cd1efa178d9867e55aa5d821c16ee255183302c3832"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/CbcBuilder.v2.10.3.x86_64-linux-gnu-gcc7.tar.gz", "186560691e1a918a23a0f0bced954ba7c5fc4fd8689c778c54acc2aeb40d8dfc"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/CbcBuilder.v2.10.3.x86_64-linux-gnu-gcc8.tar.gz", "933f37c52eb4e93b7752a9560cc97b18da43845c170bfd0d8a970d353d578eec"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc6)) => ("$bin_prefix/CbcBuilder.v2.10.3.x86_64-w64-mingw32-gcc6.tar.gz", "d71e29c4a1414712c9acd60f67f1bab07c6a2a9a27ba720b019fc9917ee6991f"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/CbcBuilder.v2.10.3.x86_64-w64-mingw32-gcc7.tar.gz", "841cd6cf7a9405807bd5eb2746f88da746ded6aba25c6d1bd1d68c699fa62581"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/CbcBuilder.v2.10.3.x86_64-w64-mingw32-gcc8.tar.gz", "370e0484a142439b9bd47a271b94bbe0065e11695d4e6307a4692dcbcc208f61"),
)

# To fix gcc4 bug in Windows
# https://sourceforge.net/p/mingw-w64/bugs/727/
this_platform = platform_key_abi()
if typeof(this_platform)==Windows && this_platform.compiler_abi.gcc_version == :gcc4
   this_platform = Windows(arch(this_platform), libc=libc(this_platform), compiler_abi=CompilerABI(:gcc6))
end


# no dynamic dependencies until Pkg3 support for binaries
dependencies = [
#     "https://github.com/juan-pablo-vielma/CglBuilder/releases/download/v0.59.10-1/build_CglBuilder.v0.59.10.jl",
#     "https://github.com/JuliaOpt/ClpBuilder/releases/download/v1.16.11-1/build_ClpBuilder.v1.16.11.jl",
#     "https://github.com/juan-pablo-vielma/OsiBuilder/releases/download/v0.107.9-1/build_OsiBuilder.v0.107.9.jl",
#     "https://github.com/juan-pablo-vielma/CoinUtilsBuilder/releases/download/v2.10.14-1/build_CoinUtilsBuilder.v2.10.14.jl",
#     "https://github.com/juan-pablo-vielma/COINMumpsBuilder/releases/download/v1.6.0-1/build_COINMumpsBuilder.v1.6.0.jl",
#     "https://github.com/juan-pablo-vielma/COINMetisBuilder/releases/download/v1.3.5-1/build_COINMetisBuilder.v1.3.5.jl",
#     "https://github.com/juan-pablo-vielma/COINLapackBuilder/releases/download/v1.5.6-1/build_COINLapackBuilder.v1.5.6.jl",
#     "https://github.com/juan-pablo-vielma/COINBLASBuilder/releases/download/v1.4.6-1/build_COINBLASBuilder.v1.4.6.jl",
#     "https://github.com/juan-pablo-vielma/ASLBuilder/releases/download/v3.1.0-1/build_ASLBuilder.v3.1.0.jl"
]

custom_library = false
if haskey(ENV,"JULIA_CBC_LIBRARY_PATH")
    custom_products = [LibraryProduct(ENV["JULIA_CBC_LIBRARY_PATH"],product.libnames,product.variable_name) for product in products]
    if all(satisfied(p; verbose=verbose) for p in custom_products)
        products = custom_products
        custom_library = true
    else
        error("Could not install custom libraries from $(ENV["JULIA_CBC_LIBRARY_PATH"]).\nTo fall back to BinaryProvider call delete!(ENV,\"JULIA_CBC_LIBRARY_PATH\") and run build again.")
    end
end

if !custom_library
    # Install unsatisfied or updated dependencies:
    unsatisfied = any(!satisfied(p; verbose=verbose) for p in products)

    dl_info = choose_download(download_info, this_platform)
    if dl_info === nothing && unsatisfied
        # If we don't have a compatible .tar.gz to download, complain.
        # Alternatively, you could attempt to install from a separate provider,
        # build from source or something even more ambitious here.
        error("Your platform (\"$(Sys.MACHINE)\", parsed as \"$(triplet(platform_key_abi()))\") is not supported by this package!")
    end

    # If we have a download, and we are unsatisfied (or the version we're
    # trying to install is not itself installed) then load it up!
    if unsatisfied || !isinstalled(dl_info...; prefix=prefix)
        # Download and install binaries
        # no dynamic dependencies until Pkg3 support for binaries
        # for dependency in reverse(dependencies)          # We do not check for already installed dependencies
        #    download(dependency,basename(dependency))
        #    evalfile(basename(dependency))
        # end
        install(dl_info...; prefix=prefix, force=true, verbose=verbose)
    end
 end

# Write out a deps.jl file that will contain mappings for our products
write_deps_file(joinpath(@__DIR__, "deps.jl"), products, verbose=verbose)
