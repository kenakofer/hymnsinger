#!/bin/bash
cd docs//local-lilypond-outputs
gh release create $1
gh release upload $1 *
