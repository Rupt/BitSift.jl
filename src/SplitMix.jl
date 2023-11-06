# https://web.archive.org/web/20220617005635/https://prng.di.unimi.it/SplitMix.c
struct SplitMix <: AbstractHash end

function query(::SplitMix, key::UInt64)::UInt64
    x = key * 0x9e3779b97f4a7c15
    x = xor(x, x >> 30) * 0xbf58476d1ce4e5b9
    x = xor(x, x >> 27) * 0x94d049bb133111eb
    return xor(x, x >> 31)
end

function encode(::SplitMix)::BitVector
    return BitVector()
end