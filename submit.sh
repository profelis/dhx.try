#!/bin/bash

zip -r haxelib.zip src haxelib.json README.md LICENCE extraParams.hxml
haxelib submit haxelib.zip