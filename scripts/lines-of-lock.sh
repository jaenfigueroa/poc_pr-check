texto=$(git diff --stat origin/dev)

# ---------------------------------------------------------------------------------

# Eliminar la última línea del texto
texto_sin_ultima_linea=$(echo "$texto" | head -n -1)

# Inicializar el objeto JSON
json_string="{"

# Procesar cada línea del texto modificado
while IFS= read -r line; do
    # Utilizar expresiones regulares con sed para extraer el nombre del archivo y el valor
    file=$(echo "$line" | sed -n 's/^[[:space:]]*\([^ ]\+\)[[:space:]]*|.*$/\1/p')
    value=$(echo "$line" | sed -n 's/.*|\s*\([0-9]\+\).*$/\1/p')

    # Agregar al objeto JSON
    json_string="$json_string \"$file\": $value,"

done <<< "$texto_sin_ultima_linea"

# Eliminar la última coma y cerrar el objeto JSON
json_string="${json_string%,} }"

# ---------------------------------------------------------------------------------

# Filtrar solo los elementos que incluyen "-lock" en el nombre
filtered_json=$(echo "$json_string" | jq 'with_entries(select(.key | test("-lock.json$|-lock.yaml$|yarn.lock$|-lockb$")))')


# ---------------------------------------------------------------------------------

suma_valores=$(echo "$filtered_json" | jq '[.[]] | add')

# --------------------------------------------------------------------
echo $suma_valores
