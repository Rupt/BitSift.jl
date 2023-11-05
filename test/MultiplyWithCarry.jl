using Printf
function _ref_kiss_mwc(key::UInt64)::UInt64
    # https://web.archive.org/web/20221206094913/https://www.thecodingforums.com/threads/64-bit-kiss-rngs.673657/
    c::UInt64 = 123456123456123456
    x::UInt64 = 1234567890987654321
    for _ in 1:key
        t::UInt64 = (x << 58) + c
        c = x >> 6
        x += t
        c += x < t
    end
    return x
end

function _ref_kiss_mwc_rng(key::UInt64)::UInt64
    c::UInt64 = 123456123456123456
    x::UInt64 = 1234567890987654321
    a::UInt64 = UInt64(1) << 58 + 1
    modulus::UInt128 = (UInt128(a) << 64) - 1  # prime
    rng = MultiplyWithCarry64(modulus, c, x)
    return query(rng, key)
end

@testset "BitSift.MultiplyWithCarry" begin
    modulus::UInt128 = 0xffebb71d94fcdaf8ffffffffffffffff
    seed_c::UInt64 = 1
    seed_x::UInt64 = 3141592653589793238
    rng = MultiplyWithCarry64(modulus, seed_c, seed_x)
    # query
    @test typeof(query(rng, UInt64(0))) === UInt64
    # Reference: https://godbolt.org/z/fezcd1rqM
    @test _ref_kiss_mwc_rng(UInt64(0)) === 0x112210f4b16c1cb1
    @test _ref_kiss_mwc_rng(UInt64(1)) === 0xd6d8aba5615f0ef1
    @test _ref_kiss_mwc_rng(UInt64(2)) === 0x9b1d33e93424bf63
    @test _ref_kiss_mwc_rng(UInt64(3)) === 0x2a789697c9aa3b9f
    for i in UInt64.(0:8)
        @test _ref_kiss_mwc(i) === _ref_kiss_mwc_rng(i)
    end
    # Reference: https://godbolt.org/z/WTx4P8fnv
    @test query(rng, UInt64(0)) === 0x2b992ddfa23249d6
    @test query(rng, UInt64(1)) === 0x8ee32211fc720d27
    @test query(rng, UInt64(2)) === 0x8d4afc4090e4aa85
    @test query(rng, UInt64(3)) === 0x5dcc5d9277c19e28
    # encode
    code = encode(rng)
    @test length(code) === 256
    @test code[1:128] == encode(modulus)
    @test code[129:192] == encode(seed_c)
    @test code[193:256] == encode(seed_x)
end
