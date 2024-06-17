#!/usr/bin/env bash
cp ./${1}/${1}_pkg.vsh local/packages
cp -r "./${1}/${1}.d" local/packages
