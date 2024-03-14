local function map(tabla, funcion)
    local nueva_tabla = {}
    for clave, valor in pairs(tabla) do
        nueva_tabla[clave] = funcion(valor)
    end
    return nueva_tabla
end



-- Función parcial para agregar un nombre a una persona
local function parcial(persona)
    return function(nombre)
        return agregar_nombre(persona, nombre)
    end
end

local persona = {
    nombre = "",
    apellido = "",
    edad = "",
    map = map
}

agregar_nombre = function(persona, nombre)
    persona.nombre = nombre
    return persona
end

agregar_apellido = function(persona, apellido)
    persona.apellido = apellido
    return persona
end

agregar_edad = function(persona, edad)
    persona.edad = edad
    return persona
end

cumple = function(persona)
    persona.edad = persona.edad + 1
    return persona
end

persona.agregar_nombre = agregar_nombre
persona.agregar_apellido = agregar_apellido
persona.agregar_edad = agregar_edad
persona.cumple = cumple

persona:agregar_nombre("Cosmo")
persona:agregar_apellido("Carpincho")
