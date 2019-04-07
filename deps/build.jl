using BinaryProvider # requires BinaryProvider 0.3.0 or later

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))
products = [
    LibraryProduct(prefix, ["libipopt"], :libipopt),
    ExecutableProduct(prefix, "ipopt", :amplexe),
]

# Download binaries from hosted location
bin_prefix = "https://github.com/JuliaOpt/IpoptBuilder/releases/download/v3.12.10-1-static-1"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/IpoptBuilder.v3.12.10.aarch64-linux-gnu-gcc4.tar.gz", "5e0beb008d3682ca133cf02be1ff7c8701a16a23db5e0afddf2fbcc94080a12e"),
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/IpoptBuilder.v3.12.10.aarch64-linux-gnu-gcc7.tar.gz", "6cc74ad9af820bf64f86ec5307b69fc0d44c93ead25b99e1c5e5af917c2685f1"),
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/IpoptBuilder.v3.12.10.aarch64-linux-gnu-gcc8.tar.gz", "ec250935455991c27b4750ede1fc272b1c1666b594af6cde9e31b1808fa70fdf"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/IpoptBuilder.v3.12.10.arm-linux-gnueabihf-gcc4.tar.gz", "dab0ace4f78df30b75cad987123ca34b067692cf9a17dcb745deeb96f15e6d70"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/IpoptBuilder.v3.12.10.arm-linux-gnueabihf-gcc7.tar.gz", "701bccb71ca24b343ce3bc0c731803d01c6df37839ba6b71859e9d884031d253"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/IpoptBuilder.v3.12.10.arm-linux-gnueabihf-gcc8.tar.gz", "2347b1cbec4c741a6a9df167bc280ba395140790b264a30becffdfc54912c214"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/IpoptBuilder.v3.12.10.i686-linux-gnu-gcc4.tar.gz", "3b265136a867977b3b90971d9abe491f847181f9a0bf34d4e2fe193f07f4ae67"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/IpoptBuilder.v3.12.10.i686-linux-gnu-gcc7.tar.gz", "d1adc40c17367897b876859a05d789e1806835f1b3665afaa769cf5a5ce1293d"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/IpoptBuilder.v3.12.10.i686-linux-gnu-gcc8.tar.gz", "46857073b015fc2bc280fa0320a7e0614500e5e6669649ac34942af7c0d85d4c"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/IpoptBuilder.v3.12.10.i686-w64-mingw32-gcc4.tar.gz", "5f3b18194b66545bd9c7571920a6991d7285216cce360c7ab04cf1adbd73a7ff"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc6)) => ("$bin_prefix/IpoptBuilder.v3.12.10.i686-w64-mingw32-gcc6.tar.gz", "ebe32920c200002699ae0d3efb3122b9837a8c70f907516142cd54d711ac6c22"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/IpoptBuilder.v3.12.10.i686-w64-mingw32-gcc7.tar.gz", "322e5100b9ed4722aea3d6c31803234babce7c9cc28ce49465cd65772c93d994"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/IpoptBuilder.v3.12.10.i686-w64-mingw32-gcc8.tar.gz", "d9d6327f2e4b97d436fceaa32d0314f4b8824bd971f39fec01a87e9edd83180c"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/IpoptBuilder.v3.12.10.x86_64-apple-darwin14-gcc4.tar.gz", "1b3420794b883cc971d732afb0bac2608cf2a7e6bd80b5861b25cdc87f820a73"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/IpoptBuilder.v3.12.10.x86_64-apple-darwin14-gcc7.tar.gz", "ab8439358117294fa7c17e55af86893902041f99b25e1052cdb15b54d03f7fe7"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/IpoptBuilder.v3.12.10.x86_64-apple-darwin14-gcc8.tar.gz", "f76fef6a24fa44be02a7e70ee5dd49bfc06f84ee58e548ac07e1686e5198a0eb"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/IpoptBuilder.v3.12.10.x86_64-linux-gnu-gcc4.tar.gz", "5d67c14f31a224d756ee8d27a440541f86a0ecb1596af3f913b7748e1b213ccb"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/IpoptBuilder.v3.12.10.x86_64-linux-gnu-gcc7.tar.gz", "e6e64b0c15445bc1f910117c4aacad91d7e3f3dd70a66da5e607dd0960afde18"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/IpoptBuilder.v3.12.10.x86_64-linux-gnu-gcc8.tar.gz", "0968689197d4a4d85032ac0c8ce7cbfb7ebd6a1eddc740aaa0ee2dae806c0e96"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/IpoptBuilder.v3.12.10.x86_64-w64-mingw32-gcc4.tar.gz", "6d9bf56ee88647a203f178cb08333a2e7824a88099d4e376c6357c0eb52e9dd8"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc6)) => ("$bin_prefix/IpoptBuilder.v3.12.10.x86_64-w64-mingw32-gcc6.tar.gz", "72e5465e5b54ea4fac4234e1c680a96bc1c04723de4fbeb484323105ef088dcc"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/IpoptBuilder.v3.12.10.x86_64-w64-mingw32-gcc7.tar.gz", "ab365e3c6ba5fc28cbc9a02720a6e40ff4b88f947895e5339a49eb7d81840fc5"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/IpoptBuilder.v3.12.10.x86_64-w64-mingw32-gcc8.tar.gz", "e76f5862acb5d60435f13a1a66b7f189a8116a7f1b857fa01756629d7fb08f2a"),
)

# To fix gcc4 bug in Windows
# https://sourceforge.net/p/mingw-w64/bugs/727/
this_platform = platform_key_abi()
if typeof(this_platform)==Windows && this_platform.compiler_abi.gcc_version == :gcc4
   this_platform = Windows(arch(this_platform), libc=libc(this_platform), compiler_abi=CompilerABI(:gcc6))
end

function update_product(product::LibraryProduct, library_path, binary_path)
    LibraryProduct(library_path, product.libnames, product.variable_name)
end

function update_product(product::ExecutableProduct, library_path, binary_path)
    ExecutableProduct(joinpath(binary_path, basename(product.path)), product.variable_name)
end

custom_library = false
if haskey(ENV,"JULIA_IPOPT_LIBRARY_PATH") && haskey(ENV,"JULIA_IPOPT_EXECUTABLE_PATH")
    custom_products = [update_product(product, ENV["JULIA_IPOPT_LIBRARY_PATH"], ENV["JULIA_IPOPT_EXECUTABLE_PATH"]) for product in products]
    if all(satisfied(p; verbose=verbose) for p in custom_products)
        products = custom_products
        custom_library = true
    else
        error("Could not install custom libraries from $(ENV["JULIA_IPOPT_LIBRARY_PATH"]) and $(ENV["JULIA_IPOPT_EXECUTABLE_PATH"]).\nTo fall back to BinaryProvider call delete!(ENV,\"JULIA_IPOPT_LIBRARY_PATH\");delete!(ENV,\"JULIA_IPOPT_EXECUTABLE_PATH\") and run build again.")
    end
end

if !custom_library

    # Install unsatisfied or updated dependencies:
    unsatisfied = any(!satisfied(p; verbose=verbose) for p in products)

    dl_info = choose_download(download_info, platform_key_abi())
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
        install(dl_info...; prefix=prefix, force=true, verbose=verbose)
    end
end

# Write out a deps.jl file that will contain mappings for our products
write_deps_file(joinpath(@__DIR__, "deps.jl"), products, verbose=verbose)