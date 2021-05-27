#!/bin/bash
#
# Get OCSP response of given X.509 cert and save as [cert_name].ocsp
#
# 21 May 2021
# Chul-Woong Yang
# cwyang@gmail.com
#
# Usage: ocsp.sh cert_name
#

set -euo pipefail

CERT=$1
OPENSSL=openssl
CURL=curl

URL=$($OPENSSL x509 -in $CERT -noout -ext authorityInfoAccess | grep OCSP)
URL=${URL##*URI:}
ISSUER=$($OPENSSL x509 -in $CERT -noout -ext authorityInfoAccess | grep Issuers)
ISSUER=${ISSUER##*URI:}

echo $URL
echo $ISSUER
$OPENSSL ocsp -issuer <($CURL -so - $ISSUER | $OPENSSL x509 -inform der) -cert $CERT -url $URL -resp_text -noverify -respout $CERT.ocsp > $CERT.ocsptxt

