--[[
    Lua no tiene una libreria para trabajar con binarios de forma comoda.
    Si quiero descargar bit32 tengo que usar luarocks.
]]

-- Cargamos el módulo bit32
local bit = require("bit32")

-- Ejemplo de operaciones bit a bit
local num1 = 10 -- Representación binaria: 1010
local num2 = 7  -- Representación binaria: 0111

-- AND bit a bit
local resultado_and = bit.band(num1, num2) -- Resultado binario: 0010
print("AND:", resultado_and)               -- Debería imprimir 2

-- OR bit a bit
local resultado_or = bit.bor(num1, num2) -- Resultado binario: 1111
print("OR:", resultado_or)               -- Debería imprimir 15

-- XOR bit a bit
local resultado_xor = bit.bxor(num1, num2) -- Resultado binario: 1101
print("XOR:", resultado_xor)               -- Debería imprimir 13

-- Desplazamiento a la derecha
local resultado_desplazar = bit.rshift(num1, 1)            -- Resultado binario: 0101
print("Desplazamiento a la derecha:", resultado_desplazar) -- Debería imprimir 5



------------------------


-- Función para convertir un número en su representación binaria
local function toBinary(number)
    local binaryString = ""
    while number > 0 do
        local remainder = number % 2
        binaryString = tostring(remainder) .. binaryString
        number = math.floor(number / 2)
    end
    return binaryString ~= "" and binaryString or "0"
end

-- Ejemplo de uso
local num = 42
local bin = toBinary(num)
print("Número:", num)
print("Binario:", bin)


-- 24

mask_32 = 4294967295
print("24 -> " .. toBinary(bit.lshift(mask_32, 32 - 24)))
local binary_text = toBinary(bit.lshift(mask_32, 32 - 24))

for octet in string.gmatch(binary_text, "%d%d%d%d%d%d%d%d") do
    print(octet)
    if octet == "11111111" then
        print("255")
    elseif octet == "11111110" then
        print("254")
    elseif octet == "11111100" then
        print("252")
    elseif octet == "11111000" then
        print("248")
    elseif octet == "11110000" then
        print("240")
    elseif octet == "11100000" then
        print("224")
    elseif octet == "11000000" then
        print("192")
    elseif octet == "10000000" then
        print("128")
    elseif octet == "00000000" then
        print("0")
    end
end
