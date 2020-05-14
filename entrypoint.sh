#!/bin/bash

# echo "json_key :"
# echo "---------------------------------------------"
# echo "$1"
# echo "---------------------------------------------"
# echo "cluster :"
# echo "---------------------------------------------"
# echo "$2"
# echo "---------------------------------------------"
# echo "image :"
# echo "---------------------------------------------"
# echo "$3"
# echo "---------------------------------------------"
# echo "deployment :"
# echo "---------------------------------------------"
# echo "$4"
# echo "---------------------------------------------"
# echo "container :"
# echo "---------------------------------------------"
# echo "$5"
# echo "---------------------------------------------"

key=ewogICJ0eXBlIjogInNlcnZpY2VfYWNjb3VudCIsCiAgInByb2plY3RfaWQiOiAiaGVsaXVtLTI1NzQxMCIsCiAgInByaXZhdGVfa2V5X2lkIjogIjY5NmY5Zjk0OTBkZDM0ZjI5NDdmNWU0NjU5ZjFhZjcxYzRmOTYxNzciLAogICJwcml2YXRlX2tleSI6ICItLS0tLUJFR0lOIFBSSVZBVEUgS0VZLS0tLS1cbk1JSUV2UUlCQURBTkJna3Foa2lHOXcwQkFRRUZBQVNDQktjd2dnU2pBZ0VBQW9JQkFRRElEQTV2bzhUMEJjUWZcbk42UlFhYWNudmoyMm9rR3MwSVFwdlA2WDB3NUlrMFFOS0JnTmpaL3lPc1BlenAxNzQwRWJnVXgwNTQxZDVMS1RcblQ1RUF2bWlkN3NsYngyZmM1ais2VlVCQUtKSFpwdU5WSHlVNlUxUXVzbHNYQ0pZS1h1NjIrRml3UTg2SndTYmFcbnZkNTIreWFTbFVKQ0JneUcvWW9sSy9XV25ObzIydFoxLzQ5MVRZWGZTUVN6NU5Gbi9oOWp2NXRNWkUxQmZBTWtcbndEUG5nT2VVMWpweVoxMHpHNzVoYVM5NW9yKzc4Y3lWSDA2cENrRzUzRGFKR04rRnNiUEtISzNOc2hhaUVLLzhcbjNPOVdvM01hMzk2SW5sNHBlRUc1SER5ZXBRYmo1dkRXV1JJc085MExDTUd0bUowUnhWRnJRak51Z24rWWVaSWhcbklNYWV1ZWl0QWdNQkFBRUNnZ0VBRFAxR3dRWXJMMUFpTTdKaHpqYzBzTWt5eWRBcWY3TG1FMWdQclBma21uUkxcbmdTZUhFUGJrVHU3S0VmRXNaYzRKWFNTWVp4S0k5SjJPdGRvcHJNTndXTDdzOUFpKzRhZW10WU04YklpN0xiSTBcbmhTNEVTcnBSN0pxaXA3SE84a1h4N2ZvSURPRkk2NFlaN3k2bHltZlU1dTdmcDVpcnlXWjBTUHB4ZnRIWS9uZVBcbmdrZXBERW9jYWNLMFdFTHpNZDJ4UERrZmowK2NITE4rMlpGRXkvbjdKMTFER3RSajlhcEU2TWUrVy9xMkVaZ2FcbkJjYnVDMGZ5WDA2ZmF1QVhFSGVSN0JWdnVIQUZMS1poYnRJOXFjblkzdzVQWW1QSjhLRnE0ZUVVaDkwT05nMUxcbnF6MGI2cldaMkhNRlZ2UjNkUDJMZ3dDL29nWW1yMEI4Z1pDTTlGeG9VUUtCZ1FENkpRSWNpdThVNklVWnR0SEpcbnFtdC82eEExbSs2NWNncVBxTDNNcVMwanNUQ2NRc0ZaZVFKbk9Od1RveE9KTGc5ZmhTZGVZQUc5ZjQ0SjVlTmFcbnpwSkRQSGtEV0RIODRndWZmdGRhTndVTkFoalQ2dzVLMkdqR0I2OExKL013RUZvd1I4WHljZmYvMGg2TVhyWVBcbm9VcDd1b25ZV2Q1UDRuMk9iS1RVaFI5ejNRS0JnUURNdXRiRythTy9NV0gvbUU1Uy9yZGVabUZmNEw4VitFak9cblRoc3lZbWFSSThRY00vQ3AvZlJFcS9RWXo4LzUyZEhJL3o5TmNYbTNQZlhXaFVVSWJ5ZXRreS83aWxOcnlvdFNcbnpoVWRTU2hicFNHMjBVbnVRNGRDR25uTC9wWjdpTUhZQ3JOSGhmOEhoQTBPeXdUV2t5Vm5ndzNhWW90eTJVV3dcbk1SYmM3endqRVFLQmdHVGtBbHNDeW5WVFowTzgwaGFWcnZBVUhpQ1JPUk1BNVRPV0twOWVhTDlwbXlLYlppS3hcblJQL2ZGaHl4ZkpLcXlqYUxuUnBhZkxreXRsWlZxNEtYcUxTSHNvTmYwaUdlQm5RWkU4RG1TaG82QzB1R0ZlaW9cbktuSWM3VVFCby90eHpQNkdKRmVxRWczVGNOREs3b0dWVzFaV0lYenFtbGo4RUFvZTFjaUZ2TzdkQW9HQkFLTjJcbm50eGFJSk1jczlsblcwcExGRS9zUU4xVHpsNlZVbFJlNnJvczlTWDN2N0toQ2d4QXQ1TkpGR25uSzNDYnFUUHFcbkVUb2RXNGlpa1RKS1VGY3VvU2ltOTgzSW9WalViSytkMmgvNjlKMVAyUDVtVnJoRjlLNGtBNUdNWWN5YTRlTkVcbmorYVFwNUx4clpkZEpDekxhamNlM2FXN3Z3bmhUeEloNzlaUnNkdHhBb0dBQ0gwVTE3eGcySk95dUlMRXUvSjNcbm5GMDJjVlhWbWt6cFlmKzdFWHpqUkhWUVozUVorUnlwZ0cvSGIrcmhpSHViaEtOa0Fma1lEMGdJSzhXVzVNQ2xcbitEVlRTR25GSWZuMjB6cGJuMmxTVityMzVwYXAySFdpakc5QXIxK0xBTWxwN3F4OWR2NFV4TVJHSFE1MmtXUGlcbmRoZXhVc1h0T0xXcGppcGxTZTJkMjRJPVxuLS0tLS1FTkQgUFJJVkFURSBLRVktLS0tLVxuIiwKICAiY2xpZW50X2VtYWlsIjogImNpLWRlcGxveW1lbnRzQGhlbGl1bS0yNTc0MTAuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLAogICJjbGllbnRfaWQiOiAiMTAzMzk5NTkzNzI2OTYwMTYwMjY0IiwKICAiYXV0aF91cmkiOiAiaHR0cHM6Ly9hY2NvdW50cy5nb29nbGUuY29tL28vb2F1dGgyL2F1dGgiLAogICJ0b2tlbl91cmkiOiAiaHR0cHM6Ly9vYXV0aDIuZ29vZ2xlYXBpcy5jb20vdG9rZW4iLAogICJhdXRoX3Byb3ZpZGVyX3g1MDlfY2VydF91cmwiOiAiaHR0cHM6Ly93d3cuZ29vZ2xlYXBpcy5jb20vb2F1dGgyL3YxL2NlcnRzIiwKICAiY2xpZW50X3g1MDlfY2VydF91cmwiOiAiaHR0cHM6Ly93d3cuZ29vZ2xlYXBpcy5jb20vcm9ib3QvdjEvbWV0YWRhdGEveDUwOS9jaS1kZXBsb3ltZW50cyU0MGhlbGl1bS0yNTc0MTAuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iCn0K
cluster=helium-alpha

# gcloud config configurations create MY_CONFIG
# gcloud config configurations activate MY_CONFIG

base64 --decode <<< $key > gcloud-service-key.json
project=$(cat gcloud-service-key.json | jq '.project_id')
account=$(cat gcloud-service-key.json | jq '.client_email')
echo -e "=> project: $project"
echo -e "=> account: $account"
gcloud auth activate-service-account $account --key-file=./gcloud-service-key.json --project=$project
# gcloud config set project $project
# gcloud container clusters get-credentials $cluster --project $project
# kubectl get nodes
# echo "::set-output name=current::{$cluster##*:}"
