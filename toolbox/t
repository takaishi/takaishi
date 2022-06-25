#!/usr/bin/env bash

set -x

file=~/src/github.com/takaishi/takaishi/t.rb

touch $file

sed -i '1s/^/\n\n__END__\n/' $file

code $file

