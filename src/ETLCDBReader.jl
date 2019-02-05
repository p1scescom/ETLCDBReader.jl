module ETLCDBReader

using StringEncodings
using Images

## Base of ETL img 
abstract type ETLImg end

struct ETLMImg <: ETLImg
    etlnum :: UInt8
    sheetnum :: UInt8
    writernum :: UInt16
    serialnum :: UInt32
    charcode :: Char
    malefemale :: UInt8
    ageofwriter :: UInt8
    industryclass :: UInt8
    occupationclass :: UInt8
    data :: Array{Gray{N0f8},2}
end

struct ETLKImg <: ETLImg
    etlnum :: UInt8
    serialnum :: UInt64
    contents :: UInt8
    style :: UInt64
    charcode :: Char
    data :: Array{Gray{N0f8},2}
end

struct ETLCImg <: ETLImg
    etlnum :: UInt8
    sheetnum :: UInt8
    writernum :: UInt16
    serialnum :: UInt32
    charcode :: Char
    malefemale :: UInt8
    ageofwriter :: UInt8
    industryclass :: UInt8
    occupationclass :: UInt8
    data :: Array{Gray{N0f8},2}
end

struct ETLGImg <: ETLImg
    etlnum :: UInt8
    sheetnum :: UInt8
    writernum :: UInt16
    serialnum :: UInt32
    charcode :: Char
    malefemale :: UInt8
    ageofwriter :: UInt8
    industryclass :: UInt8
    occupationclass :: UInt8
    data :: Array{Gray{N0f8},2}
end

struct ETLBImg <: ETLImg
    etlnum :: UInt8
    serialnum :: UInt32
    charcode :: Char
    writernum :: UInt16
    data :: Array{Gray{N0f8},2}
end

const ETL = Array{<:ETLImg,1}

const ETLM = Array{ETLMImg,1}
const ETLK = Array{ETLKImg,1}
const ETLC = Array{ETLCImg,1}
const ETLG = Array{ETLGImg,1}
const ETLB = Array{ETLBImg,1}

etl9bwh = (64,63)

function bytes2uint(bytes::Array{UInt8}, T::Type{<:Unsigned})::T
    tmp::T = 0
    for b in bytes
        tmp += b
        tmp <<= 8
    end
    return tmp
end

getetlnum(img::ETLImg)::UInt8 = img.etlnum
getetlnum(imgs::ETL)::UInt8 = imgs[1].etlnum

function getetl9g(dirpath::String)::ETLG
end


function bytes2bit(bytes)
    data = Vector{UInt8}(undef, length(bytes)*8)
    i = 0 
    for b in bytes
        for j in 1:8
            data[8*i+j] = (bytes[i+1] & (1 << (8-j))) == 0 ? 0 : 1
        end
        i += 1
    end
    return data
end

function showterm(img::ETLImg)
    s = size(img.data)
    for i in 1:s[2]
        for j in 1:s[1]
            print(img.data[j, i] == 0 ? "00" : "11")
        end
        print("\n")
    end
end

function getetl9b(dirpath::String, getrange = 1:0xffffffffffffffff)::ETLB
    if dirpath[end] != '/' 
        dirpath = dirpath * '/'
    end
    etls = Vector{ETLBImg}()
    etlnum = 9
    etlfiles = filter(x -> occursin(r"ETL9B_[0-9]+", x), readdir(dirpath))
    writernum = 1
    serialnum = 1
    for filename in etlfiles
        open(dirpath * filename, "r") do file
            read(file, 576)
            while !eof(file)
                sheetnum = bytes2uint(read(file, 2), UInt16)
                charcode = decode(read(file, 2), "JIS_X0208")[1]
                read(file, 4)
                data = Gray.(N0f8.(reshape(bytes2bit(read(file, 504)), etl9bwh)))'
                read(file, 64)
                if minimum(getrange) <= serialnum <= maximum(getrange)
                    etlimg = ETLBImg(etlnum, serialnum, charcode, writernum, data)
                    push!(etls, etlimg) 
                end

                writernum += (serialnum % 3036 == 0) ? 1 : 0
                serialnum += 1
            end
        end
    end
    return etls
end

end # module
