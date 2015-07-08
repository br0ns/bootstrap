#!/bin/bash

source "$(dirname "$0")/bootstrap"

run rm /dev/null

if [ ! -f .ssh/id_rsa ] ; then
    echo "Installing SSH private key"
    mkdir -p .ssh
    while :; do
        (base64 -d | gpg > .ssh/id_rsa) <<EOF
jA0EAwMC4OEtK9RCCQRgyeqF3bgsvskYeSRRXjac5IDzu93LlhdO71NFQqIeqrt2a9KFX33g9EcR
eg6ctw4rBN/PCOk4JbX7Gv9fcOfN9Z+XTGFAQHOf17TlcdDrNsfUvLJMDTovJIlh5MDSYACDbgHx
AR1zxBe0/MsPucbpObA3N3SAoTpu0bzePfXCiiAbVdGyAr6zwzCTLlH2huhBl5CLx2bpfMLXApsO
5u76KpcB060Qgkyjyzysj74PPeAqtNFgsETm3cpilUk6KlMAnj27tbe+JLV07KZ5Z2ypSNAGLvpq
o8Aq88FkLZ0sHEFrY19VF7o4jz7yLc9kKveaA2q5WZ0p+44O9DvD2+TBXWVBsrscVPeJ8Tvpa6Cq
oVZjNHidikJqe9JwjNHgu6jrkm+TDCGVl9vkJj0mD+TqREiC98qTFU7DNA564S+3r6bC4J/BbT/H
Nhn923Po7vr1GUr02Ki/mnthaebHMot3B5ugXx6dHnnM6kj8U5tHsEQftm17GV3ms5dBYDHr6IRZ
q0Ja4Ww0x9bX3Rpsm8Xq7D3fieNPEiVbb3j4hHbtew3zEqusfxDQUJF7VWdeJlzGm/tyQvnwlKR4
HiY9vm7+N0bjIoF7QDUyVfopy4pB6Dy27eQoP1XT2jc7ybu/nVaPA7uf3Y6hqrLN4eRpfx+pHemu
JLPcbJDpNB5z4D20nnmoI52RSJimUoeLaP9NS9EMSzIxWjo5jyLYi6wkggHtciIJIIML1/qLhSjg
D2xBa3Dv0Ji5FUKAVuY9b8YK3pKVD6Pw1TUrXLPDsO8i70BL+7epNACsRlRFhWmLLr6XtdG3GC5Y
JoVQg+haEkbrJ7fi8LJtwgfWCJIzfj8CS0YC/gExUojVoK3LRu+FlR+8X2Pb8+t9GXLn1660JeFE
E/GBf2J/vE/CKoeUBPwSdYG11EyAnsz9F1eFMK2KeTtfZtJFCDVb/77QhIG7DX36UwtyPUqUVrkB
F2CnwWF1DgOmIqeB+gp1cwwPkA4/QrqmVzvAU8xLElzX5Shts1hCnbaCAvOHTPV2g1mfuA/knpOT
X2g4iuqifssQ3+Bpr8ZQulWPb3bCytSejS6kS7ZhxMkUlIVbrb3CnocIKdPrpV88iWLg/B+CqL6p
rIaLUlCPvHkTMclEItZ4mD7cWAeD0yhoBHnYjHtemn48qJTN5ukCDTR+tfVfIjBEFbaPIFkXOak7
uEcNbw7VZou++KXPmM2+dZ7DgV8VqxNYCzTmy0LncGFPQcRspPODPUJrBfVSAd5rZzBvdpsUOAAS
28qpedkC06Zi51O61EMxNlzaMTIj41mNoTRTz4qD729mUc6awHnd6vbdweTh0ms5wfNOB5mW7e6n
cO1/1oDDSEPnrz581jOKwGmxXRo24LxLnp74fEMIGYVecWQ3p6lalxtZGvZ7ZsJUhYhLEgTP3Vqn
qvI312WXYtU1BZuBkOO6adiHMiz7tUhNzfCqHSpgEOZtB64+KIgyd62Xwx/mSBsDWwou63gMIlbO
NKBs+7XpXFobNP4EnvG50O+phW3LeHeT/MRTH97t2BmkiJRlAdV4Fx5rzZplaBwV6CxPuh7879rl
wf178WdsPygOWcUFBeHljNwpjN9z1w1Z7rkXOSK9FTcqn0cVS3jD5lxrcLU9w4SDVsEbxRtd0XWJ
zmtGuw7zcrfQPOWNnn5kFQppDr2MgzpHdheSfEMs8SDv/KLIKN2S2+wd4T/wFgofDCnq3fwoquXX
0rVtgUJteS7NFRsxxrwyWcjiguID3AharqL4P3E=
EOF
        if [ $? -eq 0 ] ; then
            break
        fi
    done
    chmod 0400 .ssh/id_rsa
    ssh-keygen -y -f .ssh/id_rsa > .ssh/id_rsa.pub
    assert [ -f .ssh/id_rsa ]
fi
