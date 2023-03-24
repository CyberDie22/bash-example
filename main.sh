
# Get the smallest UID that a normal user can have
# grep searches for the provided string in the input
# grep -E uses regular expressions to search
# sed '$LINEp;d' returns the line for line number $LINE
UID_MIN="$(cat /etc/login.defs | grep UID_MIN | grep -Eo '[0-9]+$' | sed '1p;d')"

# Get all users above $UID_MIN
USERS="$(getent passwd | cut -d: -f1,3 | awk -F: "\$2>=$UID_MIN" | cut -d$'\n' -f2- | cut -d: -f1)"

echo "$USERS"