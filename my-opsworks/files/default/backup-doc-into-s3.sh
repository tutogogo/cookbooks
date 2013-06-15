#!/bin/bash

TMP_DIR=/tmp/`basename $0`.$$
DATE="`date +%F-%H_%M`"
COMPRESS_CMD="tar jcf"
S3CMD_PUT="s3cmd put"
DOC_FILE="/vol/mysql/documents"
DUMP_FILE="$DATE-documents"
COMPRESSED_FILE="$DUMP_FILE.tar.bz2"
S3BUCKET=$1

mkdir $TMP_DIR
cd $TMP_DIR
$COMPRESS_CMD $COMPRESSED_FILE $DOC_FILE
$S3CMD_PUT $COMPRESSED_FILE $S3BUCKET/documents/$COMPRESSED_FILE

cd
if [[ -d $TMP_DIR ]] ; then
rm -rf $TMP_DIR
fi
