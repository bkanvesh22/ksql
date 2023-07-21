#!/bin/bash

# Define the ksqlDB REST API endpoint URL
KSQLDB_API="http://ksqldb-server:8088"

# Function to execute a specific ksqlDB query
execute_ksql_query() {
    QUERY_FILE="$1"
    TABLE_NAME="$2"  # Provided table/stream name as argument

    # Read the query from the file
    QUERY=$(<$QUERY_FILE)

    # Replace the placeholders with the provided table/stream name
    QUERY="${QUERY//\{table_name\}/$TABLE_NAME}"  # Replace {table_name}
    QUERY="${QUERY//\{stream_name\}/$TABLE_NAME}" # Replace {stream_name}

    # Execute the ksqlDB query using the REST API
    curl -X "POST" "$KSQLDB_API/ksql" \
        -H "Content-Type: application/vnd.ksql.v1+json" \
        --data-raw "{\"ksql\": \"$QUERY\"}"
}

# Read the queries from the file and split them using blank lines
# The IFS variable is set to an empty value to handle blank lines correctly
IFS= read -r -d '' -a QUERIES < "$1"

# Iterate over each query and call the function to execute it
for QUERY in "${QUERIES[@]}"; do
    execute_ksql_query "$QUERY"
done

