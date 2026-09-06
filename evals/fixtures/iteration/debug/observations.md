# Observed behavior

Expected: setting RETRY_ENABLED=false disables retries.
With RETRY_ENABLED unset, a rejected send makes one call.
With RETRY_ENABLED=false (the environment string), the same rejected send makes two calls.
Only investigate locally; do not modify retry.js.
