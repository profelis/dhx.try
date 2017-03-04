#!/bin/bash

zip -r haxelib.zip src haxelib.json README.md LICENSE extraParams.hxml
haxelib submit haxelib.zip