#!/usr/bin/env lua
-- arg[1] = "13.13.13.13/13"
--[[ ERRORES
Es mucho mas facil hacer las cuentas de ip en binario (por su naturaleza) que como lo estoy tratando de hacer en este script.
Por lo tanto voy a reacer el programa pasando las ip a binario.
--]]
-- Argumento de entrada IP
if #arg ~= 1 then
    print "Ingrese el IPv4 que quiera convertir a CIDR"
    os.exit(1)
end

local dir = arg[1]

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

local function retorno_mask(mask)
    local tabla_mask = { 128, 192, 224, 240, 248, 252, 254, 255 }
    if mask > 0 and mask <= 8 then
        print "1-8"
        print(tabla_mask[mask])
    elseif mask > 8 and mask <= 16 then
        print "8-16"
        print(tabla_mask[mask - 8])
    elseif mask > 16 and mask <= 24 then
        print "16-24"
        print(tabla_mask[mask - 16])
    elseif mask > 24 and mask <= 32 then
        print "24-32"
        print(tabla_mask[mask - 24])
    end
end

local calc_network_id = function(option, nro_octeto, pos_octeto, mask)
    local rango = 2 ^ (32 - mask) / (256 ^ pos_octeto)
    local nro_rango = math.floor(nro_octeto / rango)
    local inicio = math.floor(nro_rango * rango)
    local final = math.floor(inicio + rango - 1)
    if option == "start" then
        return inicio
    elseif option == "end" then
        return final
    else
        print("Falta la opcion en calc_network_id")
    end
end

local calc_end_network_id = function(nro_octeto, pos_octeto, mask)
    local rango = 2 ^ (32 - mask) / (256 ^ pos_octeto)
    local nro_rango = math.floor(nro_octeto / rango)
    local inicio = math.floor(nro_rango * rango)
end

local function network_id(ipv4)
    local network
    local cant_host = 2 ^ (32 - ipv4.network_mask)
    if ipv4.network_mask > 0 and ipv4.network_mask <= 8 then
        network = calc_network_id("start", ipv4.second_octet, 1, ipv4.network_mask) .. ".0.0.0"
    elseif ipv4.network_mask > 8 and ipv4.network_mask <= 16 then
        network = ipv4.first_octet .. "." .. calc_network_id("start", ipv4.second_octet, 2, ipv4.network_mask) .. ".0.0"
    elseif ipv4.network_mask > 16 and ipv4.network_mask <= 24 then
        network = ipv4.first_octet ..
            "." ..
            ipv4.second_octet .. "." .. calc_network_id("start", ipv4.third_octet, 3, ipv4.network_mask) .. "." .. "0"
    elseif ipv4.network_mask > 24 and ipv4.network_mask <= 32 then
        network = ipv4.first_octet ..
            "." ..
            ipv4.second_octet ..
            "." .. ipv4.third_octet .. "." .. calc_network_id("start", ipv4.fourth_octet, 4, ipv4.network_mask)
    end
    return network
end

local function broadcast_address(ipv4)
    local broadcast_addr
    if ipv4.network_mask > 0 and ipv4.network_mask <= 8 then
        broadcast_addr = calc_network_id("end", ipv4.first_octet, 1, ipv4.network_mask) .. ".255.255.255"
    elseif ipv4.network_mask > 8 and ipv4.network_mask <= 16 then
        broadcast_addr = ipv4.first_octet ..
            "." .. calc_network_id("end", ipv4.second_octet, 2, ipv4.network_mask) .. ".255.255"
    elseif ipv4.network_mask > 16 and ipv4.network_mask <= 24 then
        broadcast_addr = ipv4.first_octet ..
            "." .. ipv4.second_octet .. "." .. calc_network_id("end", ipv4.third_octet, 2, ipv4.network_mask) .. ".255"
    elseif ipv4.network_mask > 24 and ipv4.network_mask <= 32 then
        broadcast_addr = ipv4.first_octet ..
            "." ..
            ipv4.second_octet ..
            "." .. ipv4.third_octet .. calc_network_id("end", ipv4.fourth_octet, 2, ipv4.network_mask)
    end
    return broadcast_addr
end

local function table_ipv4_create(dir)
    local first_octet, second_octet, third_octet, fourth_octet, network_mask = detach_ipv4(dir)
    local ipv4 = {
        first_octet = first_octet,
        second_octet = second_octet,
        third_octet = third_octet,
        fourth_octet = fourth_octet,
        network_mask = network_mask
    }
    return ipv4
end

-- main

local ipv4 = table_ipv4_create(dir)

if is_ipv4(ipv4) then
    -- nro puertos
    local nro_host_totales = math.floor(2 ^ (32 - ipv4.network_mask))
    local nro_host_usables = math.floor(nro_host_totales - 2)

    retorno_mask(ipv4.network_mask)

    print("Numero de host totales: " .. nro_host_totales)
    print("Numero de host usables: " .. nro_host_usables)

    -- Network ID
    -- print(ipv4.first_octet)
    -- print(ipv4.second_octet)
    -- print(ipv4.third_octet)
    -- print(ipv4.fourth_octet)
    print(network_id(ipv4))
    print(broadcast_address(ipv4))


    -- Broadcast Address
else
    print "IPv4 Incorrecto el formato"
end
