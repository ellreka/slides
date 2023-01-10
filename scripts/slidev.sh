#!/bin/bash

case "$1" in
  build)
    slidev build --base /slides/$(basename $PWD)/ --out ../../dist/$(basename $PWD)
    ;;
  export)
    slidev export --output ./$(basename $PWD).pdf --dark
    ;;
  *)
    ;;
esac