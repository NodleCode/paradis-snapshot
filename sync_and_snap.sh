#!/bin/bash

ONFURL='https://node-6957502816543653888.lh.onfinality.io/ws?apikey=09b04494-3139-4b57-a5d1-e1c4c18748ce'
LOCALURL='http://localhost:9944'
LOCALWS='ws://localhost:9944'


# # Show some debug info before we start script for now:
# for  URL in $LOCALURL $ONFURL
# do
#   curl -s --request POST   --url $URL  --header 'Content-Type: application/json'   --data '{
#     "jsonrpc": "2.0",
#       "method": "state_getRuntimeVersion",
#       "params": [],
#       "id": 1
#     }' | jq .result.specVersion | sed 's/^/try-runtime-snapshot-paradis-spec-/'

#   curl -s --request POST   --url $URL  --header 'Content-Type: application/json'   --data '{
#     "jsonrpc": "2.0",
#       "method": "chain_getFinalizedHead",
#       "params": [],
#       "id": 1
#     }' | jq .result
#   curl -s --request POST   --url $URL  --header 'Content-Type: application/json'   --data '{
#     "jsonrpc": "2.0",
#       "method": "system_health",
#       "params": [],
#       "id": 1
#     }' | jq .result.isSyncing

#   curl -s --request POST   --url $URL  --header 'Content-Type: application/json'   --data '{
#     "jsonrpc": "2.0",
#       "method": "chain_getHeader",
#       "params": [],
#       "id": 1
#     }' | jq .result.number
#   echo
# done

ONFBLOCK=`  curl -s --request POST   --url $ONFURL  --header 'Content-Type: application/json'   --data '{
    "jsonrpc": "2.0",
      "method": "chain_getHeader",
      "params": [],
      "id": 1
    }' | jq .result.number |sed s/\"//g| tr [a-z] [A-Z]`

LOCALBLOCK=`  curl -s --request POST   --url $LOCALURL  --header 'Content-Type: application/json'   --data '{
    "jsonrpc": "2.0",
      "method": "chain_getHeader",
      "params": [],
      "id": 1
    }' | jq .result.number|sed s/\"//g| tr [a-z] [A-Z]`

HEAD=`curl -s --request POST   --url $LOCALURL  --header 'Content-Type: application/json'   --data '{
    "jsonrpc": "2.0",
      "method": "chain_getFinalizedHead",
      "params": [],
      "id": 1
    }' | jq .result|tr -d \"`

DIFF=`echo $(( $ONFBLOCK-$LOCALBLOCK  ))| tr -d -`
echo Hello head=$HEAD $ONFBLOCK-$LOCALBLOCK  $DIFF $(( $DIFF >10 )) 

# TODO use diff to wait until local is in sync
REV=`curl -s --request POST  --url $LOCALURL  --header 'Content-Type: application/json'   --data '{
    "jsonrpc": "2.0",
      "method": "state_getRuntimeVersion",
      "params": [],
      "id": 1
    }' | jq .result.specVersion`
TIME=`date --iso-8601=seconds --utc`
TAG=`echo S$TIME |sed s/\+00:00//|sed s/[:-]//g`_SPEC_${REV}_AT_$LOCALBLOCK
echo Time: $TIME > rellog
echo -n Rev:  >>rellog

echo $REV >> rellog
echo Tag: $TAG >>rellog
echo ChainHead: $HEAD >>rellog
cat rellog

git commit rellog -m AutomaticRelease
git tag $TAG
gh release create $TAG -F rellog 
try-runtime create-snapshot paradis-snap-full.snap -u $LOCALWS --at $HEAD
