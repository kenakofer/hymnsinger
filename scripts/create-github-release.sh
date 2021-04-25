#!/bin/bash
cd docs/local_lilypond_outputs
gh release create $1
gh release upload $1 *


