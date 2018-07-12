#!/bin/sh
PROTO_PATH=../server/proto/
AS3_OUT=src/com/alisacasino/bingo/protocol/
PACKAGE=com.alisacasino.bingo.protocol
protoc --plugin=protoc-gen-as3=./protoc-gen-as3/protoc-gen-as3 --as3_out=$AS3_OUT -I $PROTO_PATH $PROTO_PATH/*

# weird stuff to fix namespaces
find $AS3_OUT -type f | grep '.as$' | xargs sed -i '' -e "s/^package \([A-Za-z]\)/package $PACKAGE.\1/" -e "s/^package  {/package $PACKAGE {/" -e "s/\(^.*\) \([A-Za-z]*Message.[A-Za-z]*Message\)\(.*$\)/\1 $PACKAGE.\2\3/" -e "s/ErrorMessage.ErrorCode/$PACKAGE.ErrorMessage.ErrorCode/" -e "s/SignInMessage.Platform/$PACKAGE.SignInMessage.Platform/" -e "s/PlayerMessage.Gender/$PACKAGE.PlayerMessage.Gender/" -e "s/import \([A-Za-z]*Message\)/import $PACKAGE.\1/"
