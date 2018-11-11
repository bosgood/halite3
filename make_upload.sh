#!/usr/bin/env bash
rm packaged_$1.zip
cd $1
zip -r ../packaged_$1.zip *
cd -
