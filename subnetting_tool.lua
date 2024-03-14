#!/usr/bin/env lua
local bit32 = require("bit32")

arg[1] = "13.13.13.13/13"
--[[
    Diseño:
    Una tabla como estado principal donde las funciones van a ir modificandolo.
    Es imperativo pero voy a agregar las funciones a la tabla (OOP)
    por azucar sintactico.
]]

-- Argumento de entrada IP
if #arg ~= 1 then
    print "Ingrese el IPv4 que quiera convertir a CIDR"
    os.exit(1)
end

local dir = arg[1]

-- Estado principal plantilla

-- Funciones

local function valid_octet_range(octec)
    return octec and octec - 255 <= 0
end

local function valid_network_mask(mask)
    return mask and mask > 0 and mask <= 32
end

local function is_ipv4(ipv4)
    return valid_octet_range(ipv4.first_octet) and valid_octet_range(ipv4.second_octet) and
        valid_octet_range(ipv4.third_octet) and valid_octet_range(ipv4.fourth_octet) and
        valid_network_mask(ipv4.network_mask)
end

local function detach_ipv4(dir)
    local first_octet, second_octet, third_octet, fourth_octet, network_mask =
        dir:match("^([0-2]?[0-9]?[0-9])%.([0-2]?[0-9]?[0-9])%.([0-2]?[0-9]?[0-9])%.([0-2]?[0-9]?[0-9])/([0-3]?[0-9])$")
    return tonumber(first_octet), tonumber(second_octet), tonumber(third_octet), tonumber(fourth_octet),
        tonumber(network_mask)
end

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

local function calc_binary_text(ipv4)
    return toBinary(ipv4.first_octet) ..
        toBinary(ipv4.second_octet) .. toBinary(ipv4.third_octet) .. toBinary(ipv4.fourth_octet)
end

local function calc_network_mask(ipv4)
    local mask_32 = 4294967295
    local binary_text = toBinary(bit32.lshift(mask_32, (32 - ipv4.network_mask)))
    local number_text = ""

    for octet in string.gmatch(binary_text, "%d%d%d%d%d%d%d%d") do
        print(octet)
        if octet == "11111111" then
            -- print("255")
            number_text = number_text .. ".255"
        elseif octet == "11111110" then
            -- print("254")
            number_text = number_text .. ".254"
        elseif octet == "11111100" then
            -- print("252")
            number_text = number_text .. ".252"
        elseif octet == "11111000" then
            -- print("248")
            number_text = number_text .. ".248"
        elseif octet == "11110000" then
            -- print("240")
            number_text = number_text .. ".240"
        elseif octet == "11100000" then
            -- print("224")
            number_text = number_text .. ".224"
        elseif octet == "11000000" then
            -- print("192")
            number_text = number_text .. ".192"
        elseif octet == "10000000" then
            -- print("128")
            number_text = number_text .. ".128"
        elseif octet == "00000000" then
            -- print("0")
            number_text = number_text .. ".0"
        end
    end

    number_text = string.sub(number_text, 2)
    return number_text, binary_text
end


-- Las talas se pasan por referencia
local function table_ipv4_create(dir)
    local ipv4 = {}

    ipv4.first_octet, ipv4.second_octet,
    ipv4.third_octet, ipv4.fourth_octet, ipv4.network_mask = detach_ipv4(dir)

    -- ipv4.first_octet = first_octet
    -- ipv4.second_octet = second_octet
    -- ipv4.third_octet = third_octet
    -- ipv4.fourth_octet = fourth_octet
    -- ipv4.network_mask = network_mask

    if not is_ipv4(ipv4) then
        return nil
    end

    ipv4.binary_text = calc_binary_text(ipv4)
    ipv4.network_mask_text, ipv4.network_mask_binary_text = calc_network_mask(ipv4)
    -- ipv4.network_id_text = calc_networt_id_text(ipv4)
    -- ipv4.network_id_binary = calc_network_id_binary(ipv4)
    -- ipv4.broadcast_address_text = calc_broadcast_address_text(ipv4)
    -- ipv4.broadcast_address_text_binary = calc_broadcast_address_text_binary(ipv4)
    ipv4.total_host = math.floor(2 ^ (32 - ipv4.network_mask))
    ipv4.usable_host = math.floor(ipv4.total_host - 2)
    return ipv4
end

-- Funciones agregadas a objeto ipv4

-- main

local ipv4 = table_ipv4_create(dir)


if ipv4 then
    -- nro puertos
    print(ipv4.total_host)
    print(ipv4.usable_host)



    -- Network ID
    -- print(ipv4.first_octet)
    -- print(ipv4.second_octet)
    -- print(ipv4.third_octet)
    -- print(ipv4.fourth_octet)
    --print(network_id(ipv4))
    --print(broadcast_address(ipv4))


    -- Broadcast Address
else
    print "IPv4 Incorrecto el formato"
end

-- local ipv4 = {
--     decimal = { first_octet = 192, second_octe = 168, third_octet = 1, fourth_octet = 1 },
--     binary = 11100011001,
--     network_mask_text = "\24",
--     network_mask_binary = 1111111111,
--     total_host = 64,
--     usable_host = 62,
--     network_id_text = "192.168.1.0",
--     network_id_binary = 100100102,
--     broadcast_address_text = "192.168.1.63",
--     broadcast_address_text_binary = 11001001
-- }
